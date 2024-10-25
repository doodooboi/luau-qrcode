-- Taken from https://dev.to/maxart2501/let-s-develop-a-qr-code-generator-part-iii-error-correction-1kbm
-- I don't get this at all

local LOG = {}
local EXP = {}

for i = 0, 255 do
	LOG[i] = 0
	EXP[i] = 0
end

-- Populate LOG and EXP
do
	local value = 1
	for exponent = 1, 255 do
		value = value > 127 and bit32.bxor((bit32.lshift(value, 1)), 285) or bit32.lshift(value, 1)
		LOG[value] = exponent % 255
		EXP[exponent % 255] = value
	end
end

local function mul(a, b)
	if a ~= 0 and b ~= 0 then
		return EXP[(LOG[a] + LOG[b]) % 255]
	else
		return 0
	end
end

local function div(a, b)
	return EXP[(LOG[a] + LOG[b] * 254) % 255]
end

local function polyMul(poly1, poly2)
	local coeffs = {}

	for i = 1, #poly1 + #poly2 - 1 do
		coeffs[i] = 0
	end

	for index = 1, #coeffs do
		local coeff = 0
		for p1index = 1, index do
			local p2index = index - p1index + 1
			if poly1[p1index] and poly2[p2index] then
				coeff = bit32.bxor(coeff, mul(poly1[p1index], poly2[p2index]))
			end
		end
		coeffs[index] = coeff
	end
	return coeffs
end

local function polyRest(dividend, divisor)
	local quotientLength = #dividend - #divisor + 1
	local rest = {}
	for i = 1, #dividend do
		rest[i] = dividend[i]
	end

	for count = 1, quotientLength do
		if rest[1] ~= 0 then
			local factor = div(rest[1], divisor[1])
			local subtr = {}
			for i = 1, #rest do
				subtr[i] = 0
			end
			local mulResult = polyMul(divisor, { factor })
			for i = 1, #mulResult do
				subtr[i] = mulResult[i]
			end
			for i = 1, #rest do
				rest[i] = bit32.bxor(rest[i], (subtr[i] or 0))
			end
		end
		table.remove(rest, 1)
	end
	return rest
end

local function getGeneratorPoly(degree)
	local lastPoly = { 1 }
	for index = 0, degree - 1 do
		lastPoly = polyMul(lastPoly, { 1, EXP[index] })
	end
	return lastPoly
end

return function (codewords: {number}, total_codewords: number): {any}
	local degree = total_codewords - #codewords
	local messagePoly = {}
	
	for i = 1, total_codewords do
		messagePoly[i] = 0
	end

	for i = 1, #codewords do
		messagePoly[i] = codewords[i]
	end

	return polyRest(messagePoly, getGeneratorPoly(degree))
end