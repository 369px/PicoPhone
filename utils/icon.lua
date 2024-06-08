--[[pod_format="raw",created="2023-10-05 07:40:42",modified="2024-06-06 16:38:17",revision=1252,stored="2023-59-07 07:59:44"]]
--[[
	icon.lua
	
	get an icon for a file by type / metadata
	get_file_icon(filename)
]]
local index_for_type = {
	lua = 8,
	gfx = 9,
	map = 10,
	sfx = 11,
	pos = 12,
	txt = 13,
	p64 = 16,
	["p64.png"] = 16,
	["p64.rom"] = 16,
	loc = 3,
	pod = 12
	
}


function get_file_icon(filename)

	-- look for icon in metadata
	local md = fetch_metadata(filename)
	if (md and md.icon and md.icon:width() == 16) then
		return md.icon
	end
	
	local ext = filename:ext()
	
	-- folder sprite if a folder (but .p64 doesn't count)

	local kind,size,origin = fstat(filename)
	if (ext ~= "p64" and ext ~= "p64.rom" and ext ~= "p64.png" and kind == "folder")
	then
		if (origin and origin:sub(1,5) == "host:") return get_spr(4)
		return get_spr(2)
	end
	
	return get_spr(index_for_type[ext] or 1) 
	--return 1 if spr path is unvalid or has no icon
end





















































































































