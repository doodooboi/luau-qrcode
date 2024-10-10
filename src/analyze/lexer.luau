--!strict
--[[
Name: lexer.luau
Description:
	Simple utility for reading characters and keeping track of them
]]

local NULL = ''--string.char(0)

type lexer_impl = {
	__index: lexer_impl,

	new: (input: string) -> lexer,
	read: (self: lexer, peek: boolean?) -> string,

	-- returns the characters it read, and the amount
	readMatching: (self: lexer, matcher: (byte: number) -> boolean) -> (string, number),

	-- Used to go backwards and set pos, readPos accordingly
	revert: (self: lexer, length: number) -> (),

	-- Returns how much character are left to read
	eof: (self: lexer) -> number
}

export type lexer = typeof(setmetatable({} :: {
	source: string,
	length: number,

	char: string,

	pos: number,
	readPos: number
}, {} :: lexer_impl))

local lexer: lexer_impl = {} :: lexer_impl
lexer.__index = lexer

function lexer.new(input) 
	local self = setmetatable({
		source = input,
		length = #input,

		char = '',

		pos = 0,
		readPos = 1,
	}, lexer)

	return self
end

function lexer:read(peek)
	if self.readPos >= self.length + 1 then
		if peek then
			return NULL
		end

		self.char = NULL
	else
		if peek then
			return self.source:sub(self.readPos, self.readPos)
		end

		self.char = self.source:sub(self.readPos, self.readPos)
	end

	self.pos = self.readPos
	self.readPos += 1

	return self.char
end

function lexer:readMatching(matcher)
	local start = self.readPos
	local length = 0

	while true do
		local peek = self:read(true)

		if not matcher(peek:byte()) then
			break
		end

		self:read()
		length += 1
	end

	if length == 0 then
		return '', 0
	end

	return self.source:sub(start, start + length - 1), length
end

function lexer:revert(length)
	self.readPos -= length
	self.pos -= length

	self.readPos = math.clamp(self.readPos, 1, self.length)
	self.pos = math.clamp(self.pos, 0, self.length)
end

function lexer:eof()
	return (self.length - self.pos) + 1
end

return lexer