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

local function genV1()
	local code = shaped.array(21, 21, 0)

	shaped.merge(code, common.finderPattern(), 0,    0)
	shaped.merge(code, common.finderPattern(), 21-7, 0)
	shaped.merge(code, common.finderPattern(), 0, 21-7)

	return code
end

function QR.new(data: string, params: any)
	local analyzed = analyze(data, params)

	print()
	print(`QR Analysis for: {data}`)
	print(common.serializeTable(analyzed))

	return setmetatable({pattern = genV1()}, {
		__tostring = function(self)
			local out = {''}

			for _, row in ipairs(self.pattern) do
				local full = table.concat(row,' '):gsub('1', '■'):gsub('0', '.')
				table.insert(out, full)
			end

			return table.concat(out,'\n')
		end
	})
end

-- local lexer = require('./analyze/lexer')

-- local l = lexer.new('aaaabbbccd')
-- l:read(true)
-- print(l:readMatching(function(b)
-- 	return b == string.byte('a')
-- end))

-- print(l:read())

QR.new("https://www.example.com/", 2)
QR.new(string.upper("https://www.example.com/45894892123123a"), 2)
QR.new("456867634", 2)




return QR