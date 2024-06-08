--[[pod_format="raw",created="2024-05-07 15:03:35",modified="2024-06-08 22:43:07",revision=2424]]
itemDropped={}

function itemDropped.check()
	on_event("drop_items", function(msg)	
		
		notify("\130: Oh an item! Let me see...")
		
		if itemDropped.tooManyItems(msg) then return end--max one item!
		
		local path = msg.items[1].fullpath --path of the dropped item
		if itemDropped.wrongFileName(path) then return end
		

		if currentPage=="midi2pico" then itemDropped.miditron(path)
		elseif currentPage=="cPanel" then itemDropped.cPanel(path)
		else notify("\130: What are you trying to do?")
		end
	
	end)
end

function itemDropped.tooManyItems(msg)
		if #msg.items==0 then
			state = "ERR:\ngot no items"
			notify("\130: What? I think I got no items.. try again")
			return true
		elseif #msg.items>1 then 
			notify("\130: You uploaded too many items! Just one at a time please!")
			return true
		else return false end
end

function itemDropped.wrongFileName(path)
	if not path then
		state = "ERR: spaces in\nfilename(?)"
		notify("\130: Something's wrong with the file name! Are there any spaces in there?")
		return
	end
end

function itemDropped.miditron(path)
	state = "importing..."
		
	local ext = path:ext()
	if ext!="mid" and ext!="midi" then
		state = ext and ("ERR: need .mid or .midi, \ngot ."..ext) or ("ERR: need .mid or .midi, \ngot folder")
		return
	end
	
	local midi_file = fetch(path)
	if not midi_file then return end
		
	local path_without_ext
	if (ext=="mid")  path_without_ext = path:sub(1,-5)
	if (ext=="midi") path_without_ext = path:sub(1,-6)
		
	output_sfx_name = "/ram/cart/sfx/"..path_without_ext:basename()..".sfx"
		
	state = "processing..."
	coro = cocreate(convertToPicotron)
	coresume(coro,midi_file,output_sfx_name,parameters)
end

function itemDropped.cPanel(path)
	local ext = path:ext()
	if ext!="p64" and ext!="p64.png" then
		notify("You can only save a .p64 or a .p64.png inside a slot")
		return
	end

	local icon = 	get_file_icon(path)
	
	local title=fetch_metadata(path).title

	
	notify("\130: "..path.." saved!")
	
	if not phone_userdata.slot1 then
		phone_userdata.slot1 = {}
		phone_userdata.slot1.path=path
		phone_userdata.slot1.icon=icon
		phone_userdata.slot1.title=title
		
		store("/appdata/369/phone_userdata.pod",phone_userdata)
		--cPanelGUI.cart1.path=path
		--cPanelGUI.cart1.icon=icon
		
		
	elseif not phone_userdata.slot2 then
		phone_userdata.slot2 = {}
		phone_userdata.slot2.path=path
		phone_userdata.slot2.icon=icon
		phone_userdata.slot2.title=title
		
		store("/appdata/369/phone_userdata.pod",phone_userdata)
		
	elseif not phone_userdata.slot3 then
		phone_userdata.slot3 = {}
		phone_userdata.slot3.path=path
		phone_userdata.slot3.icon=icon
		phone_userdata.slot3.title=title
		
		store("/appdata/369/phone_userdata.pod",phone_userdata)
		
	else notify("\130: Right-click a slot and tap again to delete it and add a new one")
	end
	
	send_message(2, {event="kill_process", proc_id=filenavCart})
	
end