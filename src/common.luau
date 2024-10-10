--[[
Name: common.luau
Description: 
	Basic utility thats just abstracted away from main code to clean it up
]]

local common = {}
local shaped = require("./shaped")

-- Referenced from: Figure 12 - Structure of a finder pattern
function common.finderPattern()
	local pattern = shaped.array(7, 7, 0)

	for y = 1, 7 do
		for x = 1, 7 do
			-- Fill edges
			if (y == 1 or y == 7) or (x == 1 or x == 7) then
				pattern[y][x] = 1
			end

			-- Inner box
			if (y >= 3 and y <= 5) and (x >= 3 and x <= 5) then
				pattern[y][x] = 1
			end
		end
	end

	return pattern
end

-- Referenced from: 5.3.6 - Alightment Patterns:
--	"constructed of 5 × 5 dark modules, 3 × 3 lightmodules and a single central dark module."
function common.alignmentPattern()
	local pattern = shaped.array(5, 5, 0)

	for y = 1, 5 do
		for x = 1, 5 do
			-- Fill edges
			if (y == 1 or y == 5) or (x == 1 or x == 5) then
				pattern[y][x] = 1
			end
		end
	end

	-- Center
	pattern[3][3] = 1

	return pattern
end

function common.inRange(x: number, min: number, max: number, exclusive: boolean?)
	if exclusive then
		return x > min and x < max
	end

	return x >= min and x <= max
end

function common.serializeTable(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)

	if name then
		tmp = tmp .. name .. " = "
	end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp = tmp .. common.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. '"[inserializeable datatype:' .. type(val) .. ']"'
	end

	return tmp
end

return common