--[[pod_format="raw",created="2024-03-25 05:16:06",modified="2024-03-29 07:26:34",revision=220]]
--[[
	String fuctions missing from picotron
	By Hessery
]]--

-- Converts all lower case characters to uppper case characters
function string.upper(str)
	local out = ""
	for i = 1, #str do
		local c = ord(str, i)
		if c >= 97 and c <= 122 then c -= 32 end
		out = out..chr(c)
	end
	return out
end

-- Converts all upper case characters to lower case characters
function string.lower(str)
	local out = ""
	for i = 1, #str do
		local c = ord(str, i)
		if c >= 65 and c <= 90 then c += 32 end
		out = out..chr(c)
	end
	return out
end

-- Converts a string into an array breaking at the delimiter
function string.explode(str, delim)
	local i = 0
	local out = {}
	repeat
		if sub(str, i, i) == delim then
			out[#out+1] = sub(str, 0, i-1)
			str = sub(str, i+1)
			i = -1
		end
		i += 1
	until i == #str
	out[#out+1] = str
	return out
end

-- Returns the dimensions of a string
function string.dim(str)
  local width, height = print(str, 0, 1000)
  return width, height - 1000
end