local constants = require("../constants")
local common = require("../common")

local _m = constants.mode_indicators
local mode_indicators = {
	MICRO = {
		[2] = {
			str = common.dec2bin(_m.byte.M2, _m.length.M2),
			bits = _m.length.M2,
		},
		[3] = {
			str = common.dec2bin(_m.byte.M3, _m.length.M3),
			bits = _m.length.M3,
		},
		[4] = {
			str = common.dec2bin(_m.byte.M4, _m.length.M4),
			bits = _m.length.M4,
		},
	},

	QR = {
		str = common.dec2bin(_m.byte.QR, _m.length.QR),
		bits = _m.length.QR,
	},
}

-- Referenced from: Formula(2)
local function cost(mode_ind_bits: number, char_ind_bits: number, data_length: number)
	return mode_ind_bits + char_ind_bits + (8 * data_length)
end

return {
	cost = function(input: string, ver: number, micro: boolean)
		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.byte)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.byte)

		return cost(mode_ind.bits, char_ind_bits, #input)
	end,

	process = function(input: string, ver: number, micro: boolean): string
		local length = #input
		local bytes = {}

		for i = 1, length do
			local byte = input:sub(i,i):byte()

			table.insert(bytes, common.dec2bin(byte, 8))
		end

		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.byte)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.byte)

		return table.concat({
			mode_ind.str,
			common.dec2bin(length, char_ind_bits),
			table.concat(bytes),
		})
	end,
}
