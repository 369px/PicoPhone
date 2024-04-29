--[[pod_format="raw",created="2024-03-29 08:26:08",modified="2024-03-29 08:27:42",revision=2]]
function getOnNil(msg)
	if msg == nil then
		return "http://"..server.."/"..rnd(1).."/+get"
	else
		return "http://"..server.."/"..rnd(1).."/"..basexx.to_base32("<"..username.."> "..msg.."\n")
	end
end