--[[
Name: shaped.luau
Description:
	Basic utility for creating shaped arrays

]]

local shaped = {}

function shaped.array<T>(x: number, y: number, initial: T): { { T } }
	local out = {}

	for cY = 1, y do
		local row = {}

		for cX = 1, x do
			row[cX] = initial
		end

		table.insert(out, row)
	end

	return out
end

function shaped.merge(target, source, x: number, y: number)
	local sourceSizeY = #source
	local sourceSizeX = #source[1]

	for cY = 1, sourceSizeY do
		local tY = cY + y
		if not target[tY] then
			break
		end

		for cX = 1, sourceSizeX do
			local tX = cX + x
			if not target[tX] then
				break
			end

			target[tY][tX] = source[cY][cX]
		end
	end
end

return shaped