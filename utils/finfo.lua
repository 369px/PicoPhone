--[[pod_format="raw",created="2023-10-08 09:24:50",modified="2024-06-07 15:03:22",revision=2106,stored="2023-21-29 09:21:19"]]
--[[
	finfo.lua
	
	collection of file info tables, independent of gui
	indexed by filename; fel (file gui elements) can point at this
]]
-- global
finfo = {}
function deselect_all()
	for k,v in pairs(finfo) do
		v.selected = false
	end
	update_file_info_menu_item()
end

-- means "start dragging"
function drag_selected_files(msg)
	
	update_file_info_menu_item()
	
	-- skip if already dragging files or haven't moved far
	-- enough from initial point
	if (dragging_files) return
	if (abs(msg.mx - msg.mx0) < 3 and abs(msg.my - msg.my0) < 3) return
		
	
	dragging_files = {}
--	printh("dragging selected files")

	for k,v in pairs(finfo) do
		if (v.selected) then
			v.fullpath = fullpath(v.filename)
			local mx,my = mouse()
			-- 0.1.0c: set offsets here (wm handles this, but mouse moved by the time message arrives)
			v.xo = v.x - mx
			v.yo = v.y - my
			add(dragging_files, v)
			--printh("added "..v.fullpath..string.format(" %d %d",v.x,v.y))
		end
	end
	
	-- sort by distance to mouse cursor
	local mx, my = mouse()
	--local v = dragging_files[1]
	--printh("mx, my: "..mx.." "..my)
	--printh("fx, fy: "..v.x.." "..v.y)
	
	for i=1,#dragging_files do
		local v = dragging_files[i]
		v.dist = (v.x - mx)^2 + (v.y - my)^2
	end

--[[
	-- maybe can't support sort with current cpu model (crosses c boundary)
	table.sort(dragging_files, function(m0, m1)
		if (m0.dist == m1.dist) return m0.filename < m1.filename
		return m0.dist < m1.dist
	end)
]]

	local tbl = dragging_files
	for pass=1,#tbl do
		for i=1,#tbl-1 do
			if (tbl[i].dist == tbl[i+1].dist and tbl[i].filename > tbl[i+1].filename) or
				tbl[i].dist > tbl[i+1].dist
			then
				tbl[i],tbl[i+1] = tbl[i+1],tbl[i]
			end
		end
	end
	
	if (#dragging_files > 0) then
		-- send a message to window manager
		send_message(3,{
			event = "drag_items",
			items	 = dragging_files
		})
	else
		dragging_files = nil -- cancel; nothing to drag
	end
		
end



function update_file_info(clear)

--	printh("update_file_info..")

	-- for debugging; clear when interface is regenerated
	-- update: used to update icons via filenav_refresh broadcasted message
	if (clear) then
		finfo = {}
		last_files_pod = nil
	end
	
	update_file_info_menu_item()
	
	-- fetch current list
	local files = ls(pwd())
	
	-- no change; no need to update
	if (pod{mode,pwd(),files} == last_files_pod) then
		return
	end
	
	last_files_pod = pod{mode,pwd(),files}
	
	filenames = {}

	-- search for added /changed files
	local found = {}
	for i=1,#files do
	
		local filename = files[i]
		found[filename] = true
		if (not finfo[filename]) finfo[filename] = {}
		local f = finfo[filename]
		
		local attrib, size, mount_desc = fstat(filename)
		
		-- update / create info
		f.pod_type = "file_reference" -- used by dragging_items
		f.filename = filename
		f.fullpath = fullpath(filename)
		f.selected = f.selected or false
		f.attrib   = f.attrib or attrib
		f.size     = f.size or size
		f.icon     = get_file_icon(filename)

		add(filenames, f.filename)
	end
	
--[[
	-- clear out missing items
	for k,v in pairs(finfo) do
		if (not found[k]) finfo[k] = nil
	end
]]

--[[
	-- store as sorted list (files)
	filenames = {}
	for k,v in pairs(finfo) do
		add(filenames, k)
	end
]]

	--table.sort(filenames) -- commented; maybe can't support table.sort with current cpu model (crosses c boundary)

	-- update: sort by list order
--[[
	local tbl = filenames
	for pass=1,#tbl do
		for i=1,#tbl-1 do
			if tbl[i] > tbl[i+1] then
				tbl[i],tbl[i+1] = tbl[i+1],tbl[i]
			end
		end
	end
]]

	-- update gui elements
	if (mode == "grid") generate_fels_grid()
	if (mode == "list") generate_fels_list()
	if (mode == "desktop") generate_fels_desktop()
	
	--printh("========= updated_file_info =========")
	--printh(pod(finfo))

end

function open_selected_file_info()
	for k,v in pairs(finfo) do
		if (v.selected) then
			create_process("/system/apps/about.p64", 
			{
				argv={v.fullpath},
				window_attribs = {workspace = "current", autoclose=true}
			})
		end
	end
end

function update_file_info_menu_item()
	-- update menu item
	local which = nil
	for k,v in pairs(finfo) do
		if (v.selected) which = v.fullpath
	end
	
	if (which) then
		
		menuitem{
			id="file_info",	
			label = "\^:1c367f7777361c00 File Info",
			shortcut = "Ctrl-I",
			action = function()
				create_process("/system/apps/about.p64", 
					{argv={which}, window_attribs={workspace = "current", show_in_workspace=true, autoclose=true}})				
			end
		}

		menuitem{
			id="delete_file",	
			label = "\^:3e7f5d5d773e2a00 Delete File",
			action = function()
				mkdir("/ram/compost")
				local res = mv(which, "/ram/compost/"..which:basename())
				if (res) then
					notify("error: "..tostring(res))
				else
					notify("moved to ".."/ram/compost/"..which:basename())
				end
			end
		}
		
		-- rename 
		if (mode ~= "desktop") then
			menuitem{
				id="rename",
				label = "\^:0f193921213f0015 Rename "..(fstat(which) == "folder" and "Folder" or "File"),
				action = function()
					intention_filename = which -- the filename that caused menu item to be added
					push_intention("rename")
				end
			}
		end

		-- open in host
		local kind, size, origin = fstat(which)

		if (not origin or origin:sub(1,5) == "host:") then
			menuitem{
				id="open_host_path",	
--				label = "\^:00304f4141417f00 View in Host OS",
				label = "\^:0b1b3b033f3f3f00 View in Host OS",

				action = function()
					send_message(2, {event="open_host_path", path = which, _delay = 0.25}) -- delay so that mouse isn't held while new window is opening
				end
			}
		else
			-- remove
			menuitem{id="open_host_path"}
		end

	else
		-- no item selected

		-- clear entries
		menuitem{id="file_info"}
		menuitem{id="delete_file"}
		menuitem{id="rename"}

		-- open host folder

		local kind, size, origin = fstat(pwd())

		if (not origin) then -- or origin:sub(1,5) ~= "/ram/") then
			menuitem{
				id="open_host_path",	
				label = "\^:00304f4141417f00 Open Host OS Folder",
				action = function()
					send_message(2, {event="open_host_path", path = pwd(), _delay = 0.25})
				end
			}
		else
			-- remove
			menuitem{id="open_host_path"}
		end

	end


	


	
end





