local QR_char_count_indicator_bits = {
	{ numeric = 10, alphanumeric = 09, byte = 08, kanji = 08 },
	{ numeric = 12, alphanumeric = 11, byte = 16, kanji = 10 },
	{ numeric = 14, alphanumeric = 13, byte = 16, kanji = 12 },
}

local MICRO_char_count_indicator_bits = {
	{ numeric = 3 },
	{ numeric = 4, alphanumberic = 3 },
	{ numeric = 5, alphanumberic = 4, byte = 4, kanji = 3 },
	{ numeric = 6, alphanumberic = 5, byte = 5, kanji = 4 },
}

return {
	-- Referenced from: Table 2 — Mode indicators for QR code
	mode_indicators = {
		length = { QR = 4, M1 = 0, M2 = 1, M3 = 2, M4 = 3 },

		ECI = { QR = 0b0111 },
		numeric = { QR = 0b0001, M2 = 0, M3 = 0, M4 = 0 },
		alphanumeric = { QR = 0b0010, M2 = 1, M3 = 1, M4 = 1 },
		byte = { QR = 0b0100, M2 = 2, M3 = 2, M4 = 2 },
		kanji = { QR = 0b1000, M2 = 3, M3 = 3, M4 = 3 },

		structured_append = { QR = 0b0011 },
	},

	-- Referenced from: Table 3 — Number of bits in the character count indicator for QR code
	char_count_indicator_bits = {
		MICRO = function(ver: number, mode: "numeric" | "alphanumeric" | "byte" | "kanji"): number
			return MICRO_char_count_indicator_bits[ver][mode]
		end,

		QR = function(ver: number, mode: "numeric" | "alphanumeric" | "byte" | "kanji"): number
			local i = 0
			if ver >= 1 and ver <= 9 then
				i = 1
			elseif ver >= 10 and ver <= 26 then
				i = 2
			elseif ver >= 27 and ver <= 40 then
				i = 3
			else
				error(`Invalid QR version! got {ver}, expected range(1, 40)`)
			end

			return QR_char_count_indicator_bits[i][mode]
		end,
	},

	modes = {
		alphanumeric = "alphanumeric",
		byte = "byte",
		kanji = "kanji",
		numeric = "numeric",
	},

	-- Referenced from: Table 1 — Codeword capacity of all versions of QR code
	-- Note: Will probably be cleaned as the project continues, I don't know whats needed at the moment
	codeword_capacity = {
		["M1"] = { modules_per_side = 11,  f_pattern_modules = 70,   format_version_modules = 15, capacity = 5,    remainder_bits = 0 },
		["M2"] = { modules_per_side = 13,  f_pattern_modules = 74,   format_version_modules = 15, capacity = 10,   remainder_bits = 0 },
		["M3"] = { modules_per_side = 15,  f_pattern_modules = 78,   format_version_modules = 15, capacity = 17,   remainder_bits = 0 },
		["M4"] = { modules_per_side = 17,  f_pattern_modules = 82,   format_version_modules = 15, capacity = 24,   remainder_bits = 0 },
		[01]   = { modules_per_side = 21,  f_pattern_modules = 202,  format_version_modules = 31, capacity = 26,   remainder_bits = 0 },
		[02]   = { modules_per_side = 25,  f_pattern_modules = 235,  format_version_modules = 31, capacity = 44,   remainder_bits = 7 },
		[03]   = { modules_per_side = 29,  f_pattern_modules = 243,  format_version_modules = 31, capacity = 70,   remainder_bits = 7 },
		[04]   = { modules_per_side = 33,  f_pattern_modules = 251,  format_version_modules = 31, capacity = 100,  remainder_bits = 7 },
		[05]   = { modules_per_side = 37,  f_pattern_modules = 259,  format_version_modules = 31, capacity = 134,  remainder_bits = 7 },
		[06]   = { modules_per_side = 41,  f_pattern_modules = 267,  format_version_modules = 31, capacity = 172,  remainder_bits = 7 },
		[07]   = { modules_per_side = 45,  f_pattern_modules = 390,  format_version_modules = 67, capacity = 196,  remainder_bits = 0 },
		[08]   = { modules_per_side = 49,  f_pattern_modules = 398,  format_version_modules = 67, capacity = 242,  remainder_bits = 0 },
		[09]   = { modules_per_side = 53,  f_pattern_modules = 406,  format_version_modules = 67, capacity = 292,  remainder_bits = 0 },
		[10]   = { modules_per_side = 57,  f_pattern_modules = 414,  format_version_modules = 67, capacity = 346,  remainder_bits = 0 },
		[11]   = { modules_per_side = 61,  f_pattern_modules = 422,  format_version_modules = 67, capacity = 404,  remainder_bits = 0 },
		[12]   = { modules_per_side = 65,  f_pattern_modules = 430,  format_version_modules = 67, capacity = 466,  remainder_bits = 0 },
		[13]   = { modules_per_side = 69,  f_pattern_modules = 438,  format_version_modules = 67, capacity = 532,  remainder_bits = 0 },
		[14]   = { modules_per_side = 73,  f_pattern_modules = 611,  format_version_modules = 67, capacity = 581,  remainder_bits = 3 },
		[15]   = { modules_per_side = 77,  f_pattern_modules = 619,  format_version_modules = 67, capacity = 655,  remainder_bits = 3 },
		[16]   = { modules_per_side = 81,  f_pattern_modules = 627,  format_version_modules = 67, capacity = 733,  remainder_bits = 3 },
		[17]   = { modules_per_side = 85,  f_pattern_modules = 635,  format_version_modules = 67, capacity = 815,  remainder_bits = 3 },
		[18]   = { modules_per_side = 89,  f_pattern_modules = 643,  format_version_modules = 67, capacity = 901,  remainder_bits = 3 },
		[19]   = { modules_per_side = 93,  f_pattern_modules = 651,  format_version_modules = 67, capacity = 991,  remainder_bits = 3 },
		[20]   = { modules_per_side = 97,  f_pattern_modules = 659,  format_version_modules = 67, capacity = 1085, remainder_bits = 3 },
		[21]   = { modules_per_side = 101, f_pattern_modules = 882,  format_version_modules = 67, capacity = 1156, remainder_bits = 4 },
		[22]   = { modules_per_side = 105, f_pattern_modules = 890,  format_version_modules = 67, capacity = 1258, remainder_bits = 4 },
		[23]   = { modules_per_side = 109, f_pattern_modules = 898,  format_version_modules = 67, capacity = 1364, remainder_bits = 4 },
		[24]   = { modules_per_side = 113, f_pattern_modules = 906,  format_version_modules = 67, capacity = 1474, remainder_bits = 4 },
		[25]   = { modules_per_side = 117, f_pattern_modules = 914,  format_version_modules = 67, capacity = 1588, remainder_bits = 4 },
		[26]   = { modules_per_side = 121, f_pattern_modules = 922,  format_version_modules = 67, capacity = 1706, remainder_bits = 4 },
		[27]   = { modules_per_side = 125, f_pattern_modules = 930,  format_version_modules = 67, capacity = 1828, remainder_bits = 4 },
		[28]   = { modules_per_side = 129, f_pattern_modules = 1203, format_version_modules = 67, capacity = 1921, remainder_bits = 3 },
		[29]   = { modules_per_side = 133, f_pattern_modules = 1211, format_version_modules = 67, capacity = 2051, remainder_bits = 3 },
		[30]   = { modules_per_side = 137, f_pattern_modules = 1219, format_version_modules = 67, capacity = 2185, remainder_bits = 3 },
		[31]   = { modules_per_side = 141, f_pattern_modules = 1227, format_version_modules = 67, capacity = 2323, remainder_bits = 3 },
		[32]   = { modules_per_side = 145, f_pattern_modules = 1235, format_version_modules = 67, capacity = 2465, remainder_bits = 3 },
		[33]   = { modules_per_side = 149, f_pattern_modules = 1243, format_version_modules = 67, capacity = 2611, remainder_bits = 3 },
		[34]   = { modules_per_side = 153, f_pattern_modules = 1251, format_version_modules = 67, capacity = 2761, remainder_bits = 3 },
		[35]   = { modules_per_side = 157, f_pattern_modules = 1574, format_version_modules = 67, capacity = 2876, remainder_bits = 0 },
		[36]   = { modules_per_side = 161, f_pattern_modules = 1582, format_version_modules = 67, capacity = 3034, remainder_bits = 0 },
		[37]   = { modules_per_side = 165, f_pattern_modules = 1590, format_version_modules = 67, capacity = 3196, remainder_bits = 0 },
		[38]   = { modules_per_side = 169, f_pattern_modules = 1598, format_version_modules = 67, capacity = 3362, remainder_bits = 0 },
		[39]   = { modules_per_side = 173, f_pattern_modules = 1606, format_version_modules = 67, capacity = 3532, remainder_bits = 0 },
		[40]   = { modules_per_side = 177, f_pattern_modules = 1614, format_version_modules = 67, capacity = 3706, remainder_bits = 0 },
	},
}
