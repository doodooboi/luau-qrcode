local char_indicator_bits = {
	MICRO = {
		[1] = { numeric = 3 },
		[2] = { numeric = 4, alphanumeric = 3 },
		[3] = { numeric = 5, alphanumeric = 4, byte = 4, kanji = 3 },
		[4] = { numeric = 6, alphanumeric = 5, byte = 5, kanji = 4 },
	},

	QR = {
		[1] = { numeric = 10, alphanumeric = 09, byte = 08, kanji = 08 },
		[2] = { numeric = 12, alphanumeric = 11, byte = 16, kanji = 10 },
		[3] = { numeric = 14, alphanumeric = 13, byte = 16, kanji = 12 },
	},
}

local data_capacities = {
	MICRO = {
		[1] = {
			L = { codewords = 3, bits = 0 },
		},
		[2] = {
			L = { codewords = 5, bits = 0 },
			M = { codewords = 4, bits = 0 },
		},
		[3] = {
			L = { codewords = 11, bits = 0 },
			M = { codewords = 9, bits = 0 },
		},
		[4] = {
			L = { codewords = 16, bits = 0 },
			M = { codewords = 14, bits = 0 },
			Q = { codewords = 10, bits = 0 },
		},
	},

	QR = {
		[1] = {
			L = { codewords = 19, bits = 0 },
			M = { codewords = 16, bits = 0 },
			Q = { codewords = 13, bits = 0 },
			H = { codewords = 9, bits = 0 },
		},
		[2] = {
			L = { codewords = 34, bits = 0 },
			M = { codewords = 28, bits = 0 },
			Q = { codewords = 22, bits = 0 },
			H = { codewords = 16, bits = 0 },
		},
		[3] = {
			L = { codewords = 55, bits = 0 },
			M = { codewords = 44, bits = 0 },
			Q = { codewords = 34, bits = 0 },
			H = { codewords = 26, bits = 0 },
		},
		[4] = {
			L = { codewords = 80, bits = 0 },
			M = { codewords = 64, bits = 0 },
			Q = { codewords = 48, bits = 0 },
			H = { codewords = 36, bits = 0 },
		},
		[5] = {
			L = { codewords = 108, bits = 0 },
			M = { codewords = 86, bits = 0 },
			Q = { codewords = 62, bits = 0 },
			H = { codewords = 46, bits = 0 },
		},
		[6] = {
			L = { codewords = 136, bits = 0 },
			M = { codewords = 108, bits = 0 },
			Q = { codewords = 76, bits = 0 },
			H = { codewords = 60, bits = 0 },
		},
		[7] = {
			L = { codewords = 156, bits = 0 },
			M = { codewords = 124, bits = 0 },
			Q = { codewords = 88, bits = 0 },
			H = { codewords = 66, bits = 0 },
		},
		[8] = {
			L = { codewords = 194, bits = 0 },
			M = { codewords = 154, bits = 0 },
			Q = { codewords = 110, bits = 0 },
			H = { codewords = 86, bits = 0 },
		},
		[9] = {
			L = { codewords = 232, bits = 0 },
			M = { codewords = 182, bits = 0 },
			Q = { codewords = 132, bits = 0 },
			H = { codewords = 100, bits = 0 },
		},
		[10] = {
			L = { codewords = 274, bits = 0 },
			M = { codewords = 216, bits = 0 },
			Q = { codewords = 154, bits = 0 },
			H = { codewords = 122, bits = 0 },
		},
		[11] = {
			L = { codewords = 324, bits = 0 },
			M = { codewords = 254, bits = 0 },
			Q = { codewords = 180, bits = 0 },
			H = { codewords = 140, bits = 0 },
		},
		[12] = {
			L = { codewords = 370, bits = 0 },
			M = { codewords = 290, bits = 0 },
			Q = { codewords = 206, bits = 0 },
			H = { codewords = 158, bits = 0 },
		},
		[13] = {
			L = { codewords = 428, bits = 0 },
			M = { codewords = 334, bits = 0 },
			Q = { codewords = 244, bits = 0 },
			H = { codewords = 180, bits = 0 },
		},
		[14] = {
			L = { codewords = 461, bits = 0 },
			M = { codewords = 365, bits = 0 },
			Q = { codewords = 261, bits = 0 },
			H = { codewords = 197, bits = 0 },
		},
		[15] = {
			L = { codewords = 523, bits = 0 },
			M = { codewords = 415, bits = 0 },
			Q = { codewords = 295, bits = 0 },
			H = { codewords = 223, bits = 0 },
		},
		[16] = {
			L = { codewords = 589, bits = 0 },
			M = { codewords = 453, bits = 0 },
			Q = { codewords = 325, bits = 0 },
			H = { codewords = 253, bits = 0 },
		},
		[17] = {
			L = { codewords = 647, bits = 0 },
			M = { codewords = 507, bits = 0 },
			Q = { codewords = 367, bits = 0 },
			H = { codewords = 283, bits = 0 },
		},
		[18] = {
			L = { codewords = 721, bits = 0 },
			M = { codewords = 563, bits = 0 },
			Q = { codewords = 397, bits = 0 },
			H = { codewords = 313, bits = 0 },
		},
		[19] = {
			L = { codewords = 795, bits = 0 },
			M = { codewords = 627, bits = 0 },
			Q = { codewords = 445, bits = 0 },
			H = { codewords = 341, bits = 0 },
		},
		[20] = {
			L = { codewords = 861, bits = 0 },
			M = { codewords = 669, bits = 0 },
			Q = { codewords = 485, bits = 0 },
			H = { codewords = 385, bits = 0 },
		},
		[21] = {
			L = { codewords = 932, bits = 0 },
			M = { codewords = 714, bits = 0 },
			Q = { codewords = 512, bits = 0 },
			H = { codewords = 406, bits = 0 },
		},
		[22] = {
			L = { codewords = 1006, bits = 0 },
			M = { codewords = 782, bits = 0 },
			Q = { codewords = 568, bits = 0 },
			H = { codewords = 442, bits = 0 },
		},
		[23] = {
			L = { codewords = 1094, bits = 0 },
			M = { codewords = 860, bits = 0 },
			Q = { codewords = 614, bits = 0 },
			H = { codewords = 464, bits = 0 },
		},
		[24] = {
			L = { codewords = 1174, bits = 0 },
			M = { codewords = 914, bits = 0 },
			Q = { codewords = 664, bits = 0 },
			H = { codewords = 514, bits = 0 },
		},
		[25] = {
			L = { codewords = 1276, bits = 0 },
			M = { codewords = 1000, bits = 0 },
			Q = { codewords = 718, bits = 0 },
			H = { codewords = 538, bits = 0 },
		},
		[26] = {
			L = { codewords = 1370, bits = 0 },
			M = { codewords = 1062, bits = 0 },
			Q = { codewords = 754, bits = 0 },
			H = { codewords = 596, bits = 0 },
		},
		[27] = {
			L = { codewords = 1468, bits = 0 },
			M = { codewords = 1128, bits = 0 },
			Q = { codewords = 808, bits = 0 },
			H = { codewords = 628, bits = 0 },
		},
		[28] = {
			L = { codewords = 1531, bits = 0 },
			M = { codewords = 1193, bits = 0 },
			Q = { codewords = 871, bits = 0 },
			H = { codewords = 661, bits = 0 },
		},
		[29] = {
			L = { codewords = 1631, bits = 0 },
			M = { codewords = 1267, bits = 0 },
			Q = { codewords = 911, bits = 0 },
			H = { codewords = 701, bits = 0 },
		},
		[30] = {
			L = { codewords = 1735, bits = 0 },
			M = { codewords = 1373, bits = 0 },
			Q = { codewords = 985, bits = 0 },
			H = { codewords = 745, bits = 0 },
		},
		[31] = {
			L = { codewords = 1843, bits = 0 },
			M = { codewords = 1455, bits = 0 },
			Q = { codewords = 1033, bits = 0 },
			H = { codewords = 793, bits = 0 },
		},
		[32] = {
			L = { codewords = 1955, bits = 0 },
			M = { codewords = 1541, bits = 0 },
			Q = { codewords = 1115, bits = 0 },
			H = { codewords = 845, bits = 0 },
		},
		[33] = {
			L = { codewords = 2071, bits = 0 },
			M = { codewords = 1631, bits = 0 },
			Q = { codewords = 1171, bits = 0 },
			H = { codewords = 901, bits = 0 },
		},
		[34] = {
			L = { codewords = 2191, bits = 0 },
			M = { codewords = 1725, bits = 0 },
			Q = { codewords = 1231, bits = 0 },
			H = { codewords = 961, bits = 0 },
		},
		[35] = {
			L = { codewords = 2306, bits = 0 },
			M = { codewords = 1812, bits = 0 },
			Q = { codewords = 1286, bits = 0 },
			H = { codewords = 986, bits = 0 },
		},
		[36] = {
			L = { codewords = 2434, bits = 0 },
			M = { codewords = 1914, bits = 0 },
			Q = { codewords = 1354, bits = 0 },
			H = { codewords = 1054, bits = 0 },
		},
		[37] = {
			L = { codewords = 2566, bits = 0 },
			M = { codewords = 1992, bits = 0 },
			Q = { codewords = 1426, bits = 0 },
			H = { codewords = 1096, bits = 0 },
		},
		[38] = {
			L = { codewords = 2702, bits = 0 },
			M = { codewords = 2102, bits = 0 },
			Q = { codewords = 1502, bits = 0 },
			H = { codewords = 1142, bits = 0 },
		},
		[39] = {
			L = { codewords = 2812, bits = 0 },
			M = { codewords = 2216, bits = 0 },
			Q = { codewords = 1582, bits = 0 },
			H = { codewords = 1222, bits = 0 },
		},
		[40] = {
			L = { codewords = 2956, bits = 0 },
			M = { codewords = 2334, bits = 0 },
			Q = { codewords = 1666, bits = 0 },
			H = { codewords = 1276, bits = 0 },
		},
	},
}

-- Setup bit count for data_capacities
for subver, all in pairs(data_capacities) do
	for index, main in ipairs(all) do
		for ecc, data in pairs(main) do
			if subver == "MICRO" and (index == 1 or index == 3) then
				data.bits = data.codewords * 8 - 4
			else
				data.bits = data.codewords * 8
			end

			print(`{subver}-{index}{ecc}: \{ codewords = {data.codewords}, bits = {data.bits} }`)
		end
	end
end

-- Referenced from: Table 1 — Codeword capacity of all versions of QR code
-- Note: Will probably be cleaned as the project continues, I don't know whats needed at the moment
local total_capacities = {
	MICRO = {
		[1] = {
			f_pattern_modules = 70,
			format_version_modules = 15,
			capacity_codewords = 5,
			capacity_bits = 36,
			remainder_bits = 0,
		},
		[2] = {
			f_pattern_modules = 74,
			format_version_modules = 15,
			capacity_codewords = 10,
			capacity_bits = 10 * 8,
			remainder_bits = 0,
		},
		[3] = {
			f_pattern_modules = 78,
			format_version_modules = 15,
			capacity_codewords = 17,
			capacity_bits = 132,
			remainder_bits = 0,
		},
		[4] = {
			f_pattern_modules = 82,
			format_version_modules = 15,
			capacity_codewords = 24,
			capacity_bits = 24 * 8,
			remainder_bits = 0,
		},
	},

	QR = {
		[01] = {
			f_pattern_modules = 202,
			format_version_modules = 31,
			capacity_codewords = 26,
			capacity_bits = 26 * 8,
			remainder_bits = 0,
		},
		[02] = {
			f_pattern_modules = 235,
			format_version_modules = 31,
			capacity_codewords = 44,
			capacity_bits = 44 * 8,
			remainder_bits = 7,
		},
		[03] = {
			f_pattern_modules = 243,
			format_version_modules = 31,
			capacity_codewords = 70,
			capacity_bits = 70 * 8,
			remainder_bits = 7,
		},
		[04] = {
			f_pattern_modules = 251,
			format_version_modules = 31,
			capacity_codewords = 100,
			capacity_bits = 100 * 8,
			remainder_bits = 7,
		},
		[05] = {
			f_pattern_modules = 259,
			format_version_modules = 31,
			capacity_codewords = 134,
			capacity_bits = 134 * 8,
			remainder_bits = 7,
		},
		[06] = {
			f_pattern_modules = 267,
			format_version_modules = 31,
			capacity_codewords = 172,
			capacity_bits = 172 * 8,
			remainder_bits = 7,
		},
		[07] = {
			f_pattern_modules = 390,
			format_version_modules = 67,
			capacity_codewords = 196,
			capacity_bits = 196 * 8,
			remainder_bits = 0,
		},
		[08] = {
			f_pattern_modules = 398,
			format_version_modules = 67,
			capacity_codewords = 242,
			capacity_bits = 242 * 8,
			remainder_bits = 0,
		},
		[09] = {
			f_pattern_modules = 406,
			format_version_modules = 67,
			capacity_codewords = 292,
			capacity_bits = 292 * 8,
			remainder_bits = 0,
		},
		[10] = {
			f_pattern_modules = 414,
			format_version_modules = 67,
			capacity_codewords = 346,
			capacity_bits = 346 * 8,
			remainder_bits = 0,
		},
		[11] = {
			f_pattern_modules = 422,
			format_version_modules = 67,
			capacity_codewords = 404,
			capacity_bits = 404 * 8,
			remainder_bits = 0,
		},
		[12] = {
			f_pattern_modules = 430,
			format_version_modules = 67,
			capacity_codewords = 466,
			capacity_bits = 466 * 8,
			remainder_bits = 0,
		},
		[13] = {
			f_pattern_modules = 438,
			format_version_modules = 67,
			capacity_codewords = 532,
			capacity_bits = 532 * 8,
			remainder_bits = 0,
		},
		[14] = {
			f_pattern_modules = 611,
			format_version_modules = 67,
			capacity_codewords = 581,
			capacity_bits = 581 * 8,
			remainder_bits = 3,
		},
		[15] = {
			f_pattern_modules = 619,
			format_version_modules = 67,
			capacity_codewords = 655,
			capacity_bits = 655 * 8,
			remainder_bits = 3,
		},
		[16] = {
			f_pattern_modules = 627,
			format_version_modules = 67,
			capacity_codewords = 733,
			capacity_bits = 733 * 8,
			remainder_bits = 3,
		},
		[17] = {
			f_pattern_modules = 635,
			format_version_modules = 67,
			capacity_codewords = 815,
			capacity_bits = 815 * 8,
			remainder_bits = 3,
		},
		[18] = {
			f_pattern_modules = 643,
			format_version_modules = 67,
			capacity_codewords = 901,
			capacity_bits = 901 * 8,
			remainder_bits = 3,
		},
		[19] = {
			f_pattern_modules = 651,
			format_version_modules = 67,
			capacity_codewords = 991,
			capacity_bits = 991 * 8,
			remainder_bits = 3,
		},
		[20] = {
			f_pattern_modules = 659,
			format_version_modules = 67,
			capacity_codewords = 1085,
			capacity_bits = 1085 * 8,
			remainder_bits = 3,
		},
		[21] = {
			f_pattern_modules = 882,
			format_version_modules = 67,
			capacity_codewords = 1156,
			capacity_bits = 1156 * 8,
			remainder_bits = 4,
		},
		[22] = {
			f_pattern_modules = 890,
			format_version_modules = 67,
			capacity_codewords = 1258,
			capacity_bits = 1258 * 8,
			remainder_bits = 4,
		},
		[23] = {
			f_pattern_modules = 898,
			format_version_modules = 67,
			capacity_codewords = 1364,
			capacity_bits = 1364 * 8,
			remainder_bits = 4,
		},
		[24] = {
			f_pattern_modules = 906,
			format_version_modules = 67,
			capacity_codewords = 1474,
			capacity_bits = 1474 * 8,
			remainder_bits = 4,
		},
		[25] = {
			f_pattern_modules = 914,
			format_version_modules = 67,
			capacity_codewords = 1588,
			capacity_bits = 1588 * 8,
			remainder_bits = 4,
		},
		[26] = {
			f_pattern_modules = 922,
			format_version_modules = 67,
			capacity_codewords = 1706,
			capacity_bits = 1706 * 8,
			remainder_bits = 4,
		},
		[27] = {
			f_pattern_modules = 930,
			format_version_modules = 67,
			capacity_codewords = 1828,
			capacity_bits = 1828 * 8,
			remainder_bits = 4,
		},
		[28] = {
			f_pattern_modules = 1203,
			format_version_modules = 67,
			capacity_codewords = 1921,
			capacity_bits = 1921 * 8,
			remainder_bits = 3,
		},
		[29] = {
			f_pattern_modules = 1211,
			format_version_modules = 67,
			capacity_codewords = 2051,
			capacity_bits = 2051 * 8,
			remainder_bits = 3,
		},
		[30] = {
			f_pattern_modules = 1219,
			format_version_modules = 67,
			capacity_codewords = 2185,
			capacity_bits = 2185 * 8,
			remainder_bits = 3,
		},
		[31] = {
			f_pattern_modules = 1227,
			format_version_modules = 67,
			capacity_codewords = 2323,
			capacity_bits = 2323 * 8,
			remainder_bits = 3,
		},
		[32] = {
			f_pattern_modules = 1235,
			format_version_modules = 67,
			capacity_codewords = 2465,
			capacity_bits = 2465 * 8,
			remainder_bits = 3,
		},
		[33] = {
			f_pattern_modules = 1243,
			format_version_modules = 67,
			capacity_codewords = 2611,
			capacity_bits = 2611 * 8,
			remainder_bits = 3,
		},
		[34] = {
			f_pattern_modules = 1251,
			format_version_modules = 67,
			capacity_codewords = 2761,
			capacity_bits = 2761 * 8,
			remainder_bits = 3,
		},
		[35] = {
			f_pattern_modules = 1574,
			format_version_modules = 67,
			capacity_codewords = 2876,
			capacity_bits = 2876 * 8,
			remainder_bits = 0,
		},
		[36] = {
			f_pattern_modules = 1582,
			format_version_modules = 67,
			capacity_codewords = 3034,
			capacity_bits = 3034 * 8,
			remainder_bits = 0,
		},
		[37] = {
			f_pattern_modules = 1590,
			format_version_modules = 67,
			capacity_codewords = 3196,
			capacity_bits = 3196 * 8,
			remainder_bits = 0,
		},
		[38] = {
			f_pattern_modules = 1598,
			format_version_modules = 67,
			capacity_codewords = 3362,
			capacity_bits = 3362 * 8,
			remainder_bits = 0,
		},
		[39] = {
			f_pattern_modules = 1606,
			format_version_modules = 67,
			capacity_codewords = 3532,
			capacity_bits = 3532 * 8,
			remainder_bits = 0,
		},
		[40] = {
			f_pattern_modules = 1614,
			format_version_modules = 67,
			capacity_codewords = 3706,
			capacity_bits = 3706 * 8,
			remainder_bits = 0,
		},
	},
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

		-- Not really an indicator, but its under the table
		terminator = { QR = 4, M1 = 3, M2 = 5, M3 = 7, M4 = 9 },
	},

	-- Referenced from: Table 3 — Number of bits in the character count indicator for QR code
	char_count_indicator_bits = {
		MICRO = function(ver: number, mode: "numeric" | "alphanumeric" | "byte" | "kanji"): number
			return char_indicator_bits.MICRO[ver][mode]
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

			return char_indicator_bits.QR[i][mode]
		end,
	},

	modes = {
		alphanumeric = "alphanumeric",
		byte = "byte",
		kanji = "kanji",
		numeric = "numeric",
	},

	data_capacity = function(ver: number, micro: boolean?)
		if micro then
			return data_capacities.MICRO[ver]
		end

		return data_capacities.QR[ver]
	end,

	total_capacity = function(ver: number, micro: boolean?)
		if micro then
			return total_capacities.MICRO[ver]
		end

		return total_capacities.QR[ver]
	end,

	raw_total_capacity = total_capacities,
	raw_data_capacity = data_capacities,
}
