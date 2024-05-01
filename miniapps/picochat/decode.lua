--[[pod_format="raw",created="2024-03-29 08:21:42",modified="2024-05-01 19:27:15",revision=878]]
function decode(code)
	-- Trim it
	code = sub(code, 1, #code-1)
	
	-- Decode it
	local resArr = string.explode(code, "-")
	for i = 1, #resArr do
		resArr[i] = basexx.from_base32(resArr[i])
	end	
	
	-- Return the array
	return resArr
	-- Stringify the array
	--local res = ""
	--for i = 1, #resArr do
	--	res = res..resArr[i]
	--end
	
	-- Return it as a whole string
	--return res
end