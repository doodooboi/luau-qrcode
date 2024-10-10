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
		alphanumeric = 'alphanumeric',
		byte = 'byte',
		kanji = 'kanji',
		numeric = 'numeric'
	}
}
