local constants = require("../constants")
local common = require("../common")

local _m = constants.mode_indicators
local mode_indicators = {
	MICRO = {
		[2] = {
			str = common.dec2bin(_m.alphanumeric.M2, _m.length.M2),
			bits = _m.length.M2,
		},
		[3] = {
			str = common.dec2bin(_m.alphanumeric.M3, _m.length.M3),
			bits = _m.length.M3,
		},
		[4] = {
			str = common.dec2bin(_m.alphanumeric.M4, _m.length.M4),
			bits = _m.length.M4,
		},
	},

	QR = {
		str = common.dec2bin(_m.alphanumeric.QR, _m.length.QR),
		bits = _m.length.QR,
	},
}

-- Thanks ChatGPT
-- Referenced from: Table 5 — Encoding and decoding table for the alphanumeric mode
local lookup = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["A"] = 10,
	["B"] = 11,
	["C"] = 12,
	["D"] = 13,
	["E"] = 14,
	["F"] = 15,
	["G"] = 16,
	["H"] = 17,
	["I"] = 18,
	["J"] = 19,
	["K"] = 20,
	["L"] = 21,
	["M"] = 22,
	["N"] = 23,
	["O"] = 24,
	["P"] = 25,
	["Q"] = 26,
	["R"] = 27,
	["S"] = 28,
	["T"] = 29,
	["U"] = 30,
	["V"] = 31,
	["W"] = 32,
	["X"] = 33,
	["Y"] = 34,
	["Z"] = 35,
	[" "] = 36,
	["$"] = 37,
	["%"] = 38,
	["*"] = 39,
	["+"] = 40,
	["-"] = 41,
	["."] = 42,
	["/"] = 43,
	[":"] = 44,
}

-- B = M + C + 11(D div 2) + 6(D mod 2)
local function cost(mode_ind_bits: number, char_ind_bits: number, data_length: number)
	return mode_ind_bits + char_ind_bits + (11 * (data_length // 2)) + (6 * (data_length % 2))
end

return {
	cost = function(input: string, ver: number, micro: boolean)
		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.alphanumeric)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.alphanumeric)
			
		return cost(mode_ind.bits, char_ind_bits, #input)
	end,

	process = function(input: string, ver: number, micro: boolean): string
		local length = #input
		local groups = {}

		for i = 1, length, 2 do
			local char1 = input:sub(i, i)
			local char2 = input:sub(i + 1, i + 1)

			if #char2 > 0 then
				local sum = (lookup[char1] * 45) + lookup[char2]

				table.insert(groups, common.dec2bin(sum, 11))
			else
				table.insert(groups, common.dec2bin(lookup[char1], 6))
			end
		end

		local mode_ind = if micro then mode_indicators.MICRO[ver] else mode_indicators.QR
		local char_ind_bits = if micro
			then constants.char_count_indicator_bits.MICRO(ver, constants.modes.alphanumeric)
			else constants.char_count_indicator_bits.QR(ver, constants.modes.alphanumeric)

		return table.concat({
			mode_ind.str,
			common.dec2bin(length, char_ind_bits),
			table.concat(groups),
		})
	end,
}
