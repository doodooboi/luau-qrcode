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

local modes = {
	[constants.modes.numeric] = require("./modes/numerical"),
	[constants.modes.alphanumeric] = require("./modes/alphanumerical"),
	[constants.modes.byte] = require("./modes/byte"),
}

local function createBaseQR(ver: number, micro: boolean?)
	local size = common.getSize(ver, micro)

	local code = shaped.array(size, size, 0)

	shaped.merge(code, common.finderPattern(), 0, 0)
	shaped.merge(code, common.finderPattern(), size - 7, 0)
	shaped.merge(code, common.finderPattern(), 0, size - 7)

	return code
end

function generateCodewords(analyzed: {analyze.analysisResult}, ver: number, micro: boolean?, ecc: 'L' | 'M' | 'Q' | 'H')
	local _stream = {}
	local length = 0

	-- Generate the bit stream for each mode
	for _, analysis in ipairs(analyzed) do
		length += analysis.cost

		local processed =  modes[analysis.mode].process(analysis.read, ver, micro)
		table.insert(_stream, processed)
	end

	print(table.concat(_stream, '\n'))
	print(length, #table.concat(_stream))

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
		table.insert(codewords, bitstream:sub(i, i+7))
	end

	-- Versions M1 and M3's final codeword is 4 bits, not 8
	if micro and (ver == 1 or ver == 3) then
		local max = #codewords
		codewords[max] = codewords[max]:sub(1, 4)
	end

	print(`Length: {#bitstream}`)
	print(`Codewords: {#codewords}`)
end

function QR.new(data: string, params: {ecc: 'L' | 'M' | 'Q' | 'H'})
	local analyzed, ver, micro = analyze(data, params.ecc or 'L')

	print()
	print(`{if micro then 'M' else 'QR'}-{ver}{params.ecc}: {data}`)--Analysis for: {data}`)
	-- print(common.serializeTable(analyzed))

	generateCodewords(analyzed, ver, micro, params.ecc)
	print('--')

	return setmetatable({ pattern = createBaseQR(1, false) }, {
		__tostring = function(self)
			local out = { "" }

			for _, row in ipairs(self.pattern) do
				local full = table.concat(row, " "):gsub("1", "■"):gsub("0", ".")
				table.insert(out, full)
			end

			return table.concat(out, "\n")
		end,
	})
end

local bb = "https://vscode.dev/tunnel/ubuntu/home/master/development/qrcode"
-- QR.new(bb, {ver = 4, micro = false})

QR.new('1', {ecc = 'L'})
QR.new("1A", { ecc = "M" })
QR.new("a", { ecc = "Q" })
QR.new(bb, { ecc = "H" })

return QR
