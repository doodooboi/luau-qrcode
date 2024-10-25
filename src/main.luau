--[[
Name: QR.luau
Description:
	Generate QR codes using pure luau

Notes:
	ISO 18004:2024 Referenced

	Currently lets implement it with arrays for simplicity, then we can use buffers
]]

local QR = {}

local shaped = require("./shaped")
local common = require("./common")
local analyze = require("./analyze/analyze")
local constants = require("./constants")
local ecc = require('./ecc')

local modes = {
	[constants.modes.numeric] = require("./modes/numerical"),
	[constants.modes.alphanumeric] = require("./modes/alphanumerical"),
	[constants.modes.byte] = require("./modes/byte"),
}

local function createBaseQR(ver: number, micro: boolean?)
	local size = common.getSize(ver, micro)

	local matrix = shaped.array(size, size, 0)

	-- Timing patterns
	local timing_row = 7 -- The row for horizontal timing pattern (1-based index)
	for col = 1, size do
		if col ~= 7 then -- Skip the finder pattern column
			matrix[timing_row][col] = (col % 2 == 1) and 1 or 0 -- 1 for black, 0 for white
		end
	end

	local timing_col = 7 -- The column for vertical timing pattern (1-based index)
	for row = 1, size do
		if row ~= 7 then -- Skip the finder pattern row
			matrix[row][timing_col] = (row % 2 == 1) and 1 or 0 -- 1 for black, 0 for white
		end
	end

	-- Finder patterns
	shaped.merge(matrix, common.finderPattern(), 0, 0) -- Top Right
	shaped.merge(matrix, common.finderPattern(), size - 7, 0) -- Top Left
	shaped.merge(matrix, common.finderPattern(), 0, size - 7) -- Bottom Right

	-- Alignment patterns
	for _, pair in ipairs(constants.alignment_coords[ver]) do
		print(`({pair.row}, {pair.col})`)
		shaped.merge(matrix, common.alignmentPattern(), pair.row - 2, pair.col - 2)
	end

	return matrix
end

print('Alignment Patterns')
for v = 1, 40 do
	local cpairs = constants.alignment_coords[v]

	local strpairs = {}
	for _, pair in ipairs(cpairs) do
		table.insert(strpairs, `({pair.row}, {pair.col})`)
	end

	print(`QR-{v}: [{#cpairs}] = \{{table.concat(strpairs, ', ')}}`)
end

function generateDataCodewords(analyzed: {analyze.analysisResult}, ver: number, micro: boolean?, ecc: 'L' | 'M' | 'Q' | 'H'): {number}
	local _stream = {}
	local length = 0

	-- Generate the bit stream for each mode
	for _, analysis in ipairs(analyzed) do
		length += analysis.cost

		local processed =  modes[analysis.mode].process(analysis.read, ver, micro)
		table.insert(_stream, processed)
	end

	local bitCapacity = constants.data_capacity(ver, micro)[ecc].bits
	local terminatorLength = constants.mode_indicators.terminator[if micro then `M{ver}` else "QR"] -- 4 for QR-3

	-- Add terminator if possible
	if bitCapacity - length > 0 then
		-- Constrain max bits to length of terminator
		local toAdd = math.min(terminatorLength, bitCapacity - length)

		table.insert(_stream, string.rep("0", toAdd))
		length += toAdd
	end

	-- Add padding bits if it doesn't align into a full codeword
	local extraBits = length % 8
	if extraBits > 0 then
		table.insert(_stream, string.rep('0', 8 - extraBits))
		extraBits = 8 - extraBits

		length += extraBits
	end

	-- Extend bit stream to completely fill data capacity
	if bitCapacity - length > 0 then
		local i = 1
		local padCodewords = {'11101100', '00010001'}

		while bitCapacity - length > 0 do
			table.insert(_stream, padCodewords[i])

			length += 8
			i = 3 - i
		end

		-- M-3 and M-1 micro QR codes represent final pad as 0000
		if (ver == 1 or ver == 3) and micro then
			local max = #_stream

			_stream[max] = '0000'
		end
	end

	-- M-3 and M-1 micro QR codes have final codeword at 4 bits
	if (ver == 1 or ver == 3) and micro then
		local max = #_stream

		_stream[max] = _stream[max]:sub(1, 4)
	end

	local codewords = {}
	local bitstream = table.concat(_stream)

	for i = 1, #bitstream, 8 do
		local byte = ''
		-- Versions M1 and M3's final codeword is 4 bits, not 8
		if #bitstream - i == 7 and micro and (ver == 1 or ver == 3) then 
			byte = bitstream:sub(i, i+3)
		else
			byte = bitstream:sub(i, i + 7)
		end

		table.insert(codewords, tonumber(byte, 2) :: number)
	end


	print(`Length: {#bitstream}`)
	print(`Codewords: {#codewords}`)

	return codewords
end

local function fillMatrix(matrix: { { number} }, codewords: {number})
	
end

function QR.new(data: string, params: {ecc: 'L' | 'M' | 'Q' | 'H'})
	local analyzed, ver, micro = analyze(data, params.ecc or 'L')
	-- ver = 7

	print()
	print(`{if micro then 'M' else 'QR'}-{ver}{params.ecc}: {data}`)--Analysis for: {data}`)
	-- print(common.serializeTable(analyzed))

	local data_codewords = generateDataCodewords(analyzed, ver, micro, params.ecc)
	local ecc_codewords = ecc(data_codewords, constants.total_capacity(ver, micro).capacity_codewords)
	
	print()
	print(`{#ecc_codewords} ECC Codewords:`)
	print(`[{table.concat(ecc_codewords, ', ')}]`)

	print(`{#data_codewords} Data Codewords:`)
	print(`[{table.concat(data_codewords, ", ")}]`)

	local codeword_sequence = {}
	table.move(data_codewords, 1, #data_codewords, 1, codeword_sequence)
	table.move(ecc_codewords, 1, #ecc_codewords, #codeword_sequence + 1, codeword_sequence)

	print(`{#codeword_sequence} Total codewords:`)
	print(`[{table.concat(codeword_sequence, ", ")}]`)

	local matrix = createBaseQR(ver)
	-- matrix[1][1] = 0

	return setmetatable({ pattern = matrix }, {
		__tostring = function(self)
			local out = { "" }

			for i, row in ipairs(self.pattern) do
				local full = `{if i < 10 then `{i} ` else i} {table.concat(row, " "):gsub("1", "■"):gsub("0", ".")}`
				table.insert(out, full)
			end

			return table.concat(out, "\n")
		end,
	})
end

local bb = "https://vscode.dev/tunnel/ubuntu/home/master/development/qrcode"
-- QR.new(bb, {ver = 4, micro = false})

-- QR.new('1', {ecc = 'L'})
-- QR.new("1A", { ecc = "M" })
-- QR.new("a", { ecc = "Q" })
-- QR.new(bb, { ecc = "H" })

print(QR.new('https://www.qrcode.com/', {ecc = 'M'}))
return QR
