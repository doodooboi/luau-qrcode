--[[
Name: analyze.luau
Description:
	Efficiently choose modes for various data streams which maximize compression

Notes:
	In order to determine the smallest version, lets try 3 codes with different versions that affect mode switching
		V1
		V10
		V27
]]

local constants = require("../constants")
local common = require("../common")
local lexer = require("./lexer")

local modes = {
	[constants.modes.numeric] = require("../modes/numerical"),
	[constants.modes.byte] = require("../modes/byte"),
	[constants.modes.alphanumeric] = require("../modes/alphanumerical"),
}

export type analysisResult = {
	mode: string,
	read: string,
	cost: number,
	_tmpCost: { micro: number, normal: number },
	_excluded: { number },
}

-- Referenced from: Table J.1 — Exclusive subset byte values for QR code modes
local exclusive_subsets = {
	numeric = function(byte: number)
		return byte and (byte >= 0x30 and byte <= 0x39)
	end,

	alphanumeric = function(byte: number)
		-- Check for Space, $, %
		return byte
			and (
				byte == 0x20
				or byte == 0x24
				or byte == 0x25
				-- Check for *, + 
				or byte == 0x2A
				or byte == 0x2B
				-- Check for -, ., /
				or (byte >= 0x2D and byte <= 0x2F)
				-- Check for :
				or byte == 0x3A
				-- Check for A to Z
				or (byte >= 0x41 and byte <= 0x5A)
			)
	end,

	byte = function(byte: number)
		-- Check if byte is in the allowed ranges
		return byte
			and (
				(byte >= 0x00 and byte <= 0x1F)
				or (byte >= 0x21 and byte <= 0x23)
				or (byte >= 0x26 and byte <= 0x29)
				or byte == 0x2C
				or (byte >= 0x3B and byte <= 0x40)
				or (byte >= 0x5B and byte <= 0x7F)
				or (byte >= 0xA0 and byte <= 0xDF)
			)
	end,

	kanji = function(byte: number)
		return false
	end,
}

local function getThreshold<T>(ver: number, thresholds: { T }): T
	if common.inRange(ver, 1, 9) then
		return thresholds[1]
	elseif common.inRange(ver, 10, 26) then
		return thresholds[2]
	else
		return thresholds[3]
	end
end

local function selectInitialMode(lex: lexer.lexer, ver: number)
	local initialChar = lex:read()
	local initialByte = initialChar:byte()

	if exclusive_subsets.byte(initialByte) then
		return { mode = constants.modes.byte, read = initialChar }
	end

	-- Implement kanji later
	if exclusive_subsets.kanji(initialByte) then
		return "kanji", 1
	end

	if exclusive_subsets.alphanumeric(initialByte) then
		local alphanumericChars = initialChar .. lex:readMatching(exclusive_subsets.alphanumeric)
		local threshold = getThreshold(ver, { 6, 7, 8 })

		if #alphanumericChars < threshold then
			return { mode = constants.modes.byte, read = alphanumericChars }
		else
			return { mode = constants.modes.alphanumeric, read = alphanumericChars }
		end
	end

	if exclusive_subsets.numeric(initialByte) then
		local numericChars = initialChar .. lex:readMatching(exclusive_subsets.numeric)
		local numericCount = #numericChars

		-- Determine thresholds based on the version
		local byteThreshold = getThreshold(ver, { 4, 4, 5 })
		local alphanumericThreshold = getThreshold(ver, { 7, 8, 9 })

		-- Check what follows after the numeric characters
		local nextByte = lex:read(true):byte()
		if exclusive_subsets.byte(nextByte) and numericCount < byteThreshold then
			numericChars ..= lex:read()
			return { mode = constants.modes.byte, read = numericChars }
		elseif exclusive_subsets.alphanumeric(nextByte) and numericCount < alphanumericThreshold then
			numericChars ..= lex:read()
			return { mode = constants.modes.alphanumeric, read = numericChars }
		end

		-- If none of the conditions apply, select Numeric mode
		return { mode = constants.modes.numeric, read = numericChars }
	end

	return ""
end

local function formatAnalysis(analysis)
	return `Mode: {analysis.mode}, Read: {analysis.read}`
end

local DEBUGGING = false
local function log(...)
	if not DEBUGGING then
		return
	end

	print(...)
end

local function newAnalysis(
	masterRecord: { analysisResult },
	oldResult: analysisResult,
	mode: string,
	read: string,
	_eof: number,
	run: number
)
	log(`-> Switching to {mode} mode. EOF: {_eof}`)
	log(`-> Analysis run {run} ended.`)
	log(`-> [OLD]: {formatAnalysis(oldResult)}`)

	table.insert(masterRecord, oldResult)

	local newAnalysis = {
		mode = mode,
		read = read,
		cost = { micro = -1, normal = -1 },
	}

	log(`-> [NEW]: {formatAnalysis(newAnalysis)}`)

	return newAnalysis
end

-- Referenced from: J.2 Optimisation for QR code symbols
local function QR_analyze(input: string, ver: number): { analysisResult }
	local charLexer = lexer.new(input)

	local initialAnalysis = selectInitialMode(charLexer, ver)
	local currentAnalysis = initialAnalysis

	local analyzed: { analysisResult } = { initialAnalysis }

	log(`Initial Analysis: {formatAnalysis(initialAnalysis)}`)

	local r = 0
	local maxr = #input + 10

	while charLexer:eof() > 0 do
		if r > maxr then
			return analyzed
		end
		r += 1

		log(`Analysis run {r} started. {formatAnalysis(currentAnalysis)}`)
		-- everytime we read matching characters, but we don't meed the threshold
		-- we still need to add them to the current analyis.read, so we keep track here
		local read = ""

		if currentAnalysis.mode == constants.modes.byte then
			-- implement Kanji (b.1)

			local peeked = charLexer:read(true):byte()
			log(`-> Byte peeked: {peeked and string.char(peeked) or "EOF"}({peeked})`)

			-- b.2
			if exclusive_subsets.alphanumeric(peeked) then
				local alphanumericChars = charLexer:readMatching(exclusive_subsets.alphanumeric)
				local alphanumericThreshold = getThreshold(ver, { 11, 15, 16 })

				local count = #alphanumericChars

				if count >= alphanumericThreshold and exclusive_subsets.byte(charLexer:read(true):byte()) then
					currentAnalysis = newAnalysis(
						analyzed,
						currentAnalysis,
						constants.modes.alphanumeric,
						alphanumericChars,
						charLexer:eof(),
						r
					)

					continue
				end

				read = alphanumericChars
				-- print("AAAA", charLexer:read(true))
			end

			-- b.3 and b.4
			if exclusive_subsets.numeric(peeked) then
				local numericChars = charLexer:readMatching(exclusive_subsets.numeric)
				-- First test b.3 threshold
				local numericThreshold = getThreshold(ver, { 6, 8, 9 })

				local count = #numericChars
				local peeked2 = charLexer:read(true):byte()

				-- b.3
				if count >= numericThreshold and exclusive_subsets.byte(peeked2) then
					currentAnalysis = newAnalysis(
						analyzed,
						currentAnalysis,
						constants.modes.numeric,
						numericChars,
						charLexer:eof(),
						r
					)

					continue
				end

				numericThreshold = getThreshold(ver, { 6, 7, 8 })

				-- b.4
				if count >= numericThreshold and exclusive_subsets.alphanumeric(peeked2) then
					currentAnalysis = newAnalysis(
						analyzed,
						currentAnalysis,
						constants.modes.numeric,
						numericChars,
						charLexer:eof(),
						r
					)

					continue
				end

				read = numericChars
			end

			-- none of the subsets were tried
			if #read == 0 then
				read = charLexer:read()
			end
		elseif currentAnalysis.mode == constants.modes.alphanumeric then
			local peeked = charLexer:read(true):byte()
			log(`-> Alpha peeked: {peeked and string.char(peeked) or "EOF"}({peeked})`)

			if exclusive_subsets.byte(peeked) then
				currentAnalysis =
					newAnalysis(analyzed, currentAnalysis, constants.modes.byte, charLexer:read(), charLexer:eof(), r)

				continue
			end

			if exclusive_subsets.numeric(peeked) then
				local numericChars = charLexer:readMatching(exclusive_subsets.numeric)
				local numericThreshold = getThreshold(ver, { 13, 15, 17 })

				local peeked2 = charLexer:read(true):byte()

				if #numericChars >= numericThreshold and exclusive_subsets.alphanumeric(peeked2) then
					currentAnalysis = newAnalysis(
						analyzed,
						currentAnalysis,
						constants.modes.numeric,
						numericChars,
						charLexer:eof(),
						r
					)

					continue
				end

				read = numericChars
			else
				read = charLexer:read()
			end
		elseif currentAnalysis.mode == constants.modes.numeric then
			local read2 = charLexer:read()
			local byte = read2:byte()

			log(`-> Numerical peeked: {byte and string.char(byte) or "EOF"}({byte})`)

			local byteSubset = exclusive_subsets.byte(byte)
			local alphaSubset = not byteSubset and exclusive_subsets.alphanumeric(byte)

			if byteSubset or alphaSubset then
				local m = if byteSubset then constants.modes.byte else constants.modes.alphanumeric

				currentAnalysis = newAnalysis(analyzed, currentAnalysis, m, read2, charLexer:eof(), r)

				continue
			end

			read = read2
		end

		-- no mode switching happened, add to read
		-- TODO: switch to table.concat for faster implementation, as concatting strings is slow
		currentAnalysis.read ..= read

		if charLexer:eof() == 0 then
			table.insert(analyzed, currentAnalysis)
		end

		log(`Analysis run {r} ended. Mode: {currentAnalysis.mode}, Read: {currentAnalysis.read}`)
		-- print("Analysis:", currentAnalysis.read, currentAnalysis.mode)
	end

	-- sometimes it'll duplicate, im too lazy to fix for now
	if #analyzed > 1 then
		local a1 = analyzed[1]
		local a2 = analyzed[2]

		if a1.mode == a2.mode and a2.read == a1.read then
			table.remove(analyzed, 1)
		end
	end

	return analyzed
end

local function getSmallestVersion(data, ecc: "L" | "M" | "Q" | "H", micro: boolean?): number?
	local toSearch = if micro then constants.raw_data_capacity.MICRO else constants.raw_data_capacity.QR

	local excluded
	if micro then
		if data.trial == 1 then
			excluded = { 2, 3, 4 }
		elseif data.trial == 2 then
			excluded = {1, 3, 4}
		end
	end

	for ver, verData in ipairs(toSearch) do
		if excluded and table.find(excluded, ver) then
			continue
		end

		verData = verData[ecc]

		if data.cost <= verData.bits then
			return ver
		end
	end

	return
end

return function(input: string, ecc: "L" | "M" | "H" | "Q"): ({ analysisResult }, number, boolean)
	local analysisResults = {}
	local trialResults = { micro = {}, normal = {} }

	-- These versions change required thresholds during analysis
	for trial, ver in ipairs({ 1, 10, 27 }) do
		local analyzed = QR_analyze(input, ver)
		local totalCost = 0
		local switches = 0

		-- Calulate cost and mode switches of each result
		for i, result: analysisResult in ipairs(analyzed) do
			if not modes[result.mode] then
				print(`Failed to analyze cost for {result.mode} mode!`)
				continue
			end

			local cost = modes[result.mode].cost(result.read, ver, false)
			result.cost = cost

			totalCost += cost
			switches += 1
		end

		table.insert(trialResults.normal, {
			cost = totalCost,
			switches = switches,
			trial = trial,
		})

		table.insert(analysisResults, analyzed)
	end

	-- TODO: Micro analysis

	-- sort to make smallest cost first index
	table.sort(trialResults.micro, function(cost1, cost2)
		return cost1.cost < cost2.cost
	end)

	table.sort(trialResults.normal, function(cost1, cost2)
		return cost1.cost < cost2.cost
	end)

	local smallest = {
		micro = nil, --getSmallestVersion(trialResults.micro[1], ecc, true),
		normal = getSmallestVersion(trialResults.normal[1], ecc, false),
	}

	local ver = smallest.micro or smallest.normal
	local costMode = if smallest.micro then "micro" else "normal"

	return analysisResults[trialResults[costMode][1].trial], ver, costMode == "micro"
end
