local constants = require("../constants")
local common = require("../common")

local _m = constants.mode_indicators
local mode_indicators = {
	MICRO = {
		[2] = {
			str = common.dec2bin(_m.numeric.M2, _m.length.M2),
			bits = _m.length.M2,
		},
		[3] = {
			str = common.dec2bin(_m.numeric.M3, _m.length.M3),
			bits = _m.length.M3,
		},
		[4] = {
			str = common.dec2bin(_m.numeric.M4, _m.length.M4),
			bits = _m.length.M4,
		},
	},

	QR = {
		str = common.dec2bin(_m.numeric.QR, _m.length.QR),
		bits = _m.length.QR,
	},
}

-- Referenced from: Formula(1)
local function cost(mode_ind_bits: number, char_ind_bits: number, data_length: number)
	local d_mod = data_length % 3
	local R = if d_mod == 0 then 0 else if d_mod == 1 then 4 else 7

	return mode_ind_bits + char_ind_bits + (10 * (data_length // 3)) + R
end

return {
	cost = function(input: string, ver: number, micro: boolean)
		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.numeric)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.numeric)

		return cost(mode_ind.bits, char_ind_bits, #input)
	end,

	process = function(input: string, ver: number, micro: boolean): string
		local groups = {}
		local length = #input

		for i = 1, length, 3 do
			local group = input:sub(i, i + 2)
			local bits = 10

			if #group == 1 then
				bits = 4
			elseif #group == 2 then
				bits = 7
			end

			table.insert(groups, common.dec2bin(tonumber(group) :: number, bits))
		end

		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.numeric)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.numeric)

		return table.concat({
				mode_ind.str,
				common.dec2bin(length, char_ind_bits),
				table.concat(groups),
		})
	end,
}
