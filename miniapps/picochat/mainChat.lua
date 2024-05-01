--[[pod_format="raw",created="2024-03-23 02:18:36",modified="2024-05-01 19:27:15",revision=4902]]
--[[
		PicoChat 1.2
			By Hessery
			
		With help from:
			- Pyrochiliach
			- PixelDud
		
		-- Commands: --
		/nick 'name'
		/server 'address'
		
]]--

--window { width = 127, height = 205, title = "PicoChat", resizeable = true }

-- Text wrapping poke
--poke(0x5f36, 0x80)

-- Include libs
include "miniapps/picochat/lib/basexx.lua"
include "miniapps/picochat/lib/string.lua"
include "miniapps/picochat/wordWrap.lua"
include "miniapps/picochat/decode.lua"
include "miniapps/picochat/getOnNil.lua"

function save()
	store("/appdata/picochat/user.pod", { address = server, name = username })
end

outMsg = ""
timer = 120
displayLog = ""
oldRet = ""
mute = false
lines = 0
width = 150
resize = 0

-- Init vars that get saved between sessions
user = fetch("/appdata/picochat/user.pod")
if user then
	username = user.name
	server = user.address
else
	server = "nenjine.com"
	username = "Anon"
	mkdir("/appdata/picochat/")
	save()
end

-- Main loop
firsTimeChat=true
function updateChat()

	--added this line to fake initi function without having it
--	if firsTimeChat then send() firstTimeChat=false end 	-- Get the msg log
	

	-- Fetch updates
	timer -= 1
	if timer <= 0 then send() timer = 120 end
	-- Gui
	--chatGui.y = get_display():height() - 12
	chatGui:update_all()
	
	-- Draw the text
	if displayLog == "" then displayLog = " > Looking for server..." end
	--log = word_wrap(displayLog, get_display():width(), false)
	--log = displayLog
	
	--[[ count lines
	local i = 0
	local c = 1
	local subStr = "\n"
	repeat
		if sub(log, i, i) == subStr then
			c += 1
		end
		i += 1
	until i == #log
	
	lines = c]]--
end

function drawChat()
	-- Experimental lazy log draw
	--local i = #displayLog

	local h = 0
	if stat(1) < 0.25 then 
	--	cls()
		--while stat(1) < 0.25 and i > #displayLog-7 and h<130 do
		for i=#displayLog,#displayLog-9,-1 do
		
			if h<130 then
				-- Word wrap single line
				local s = word_wrap(displayLog[i], 125, false)
				--local s = displayLog[i]
				-- Count '\n's
				local n = 0
				
				for o = 0, #s do
					if sub(s, o, o) == "\n" then --if letter you're on is a \n
						n += 1
					end
				end
				-- Add height to h
				h += n * 8
				-- Draw
				print(s, 10, 165 - h,7)
			--	i -= 1
			end
		end
	end

	-- Draw the gui
	chatGui:draw_all()
	-- Count back towards 15
	--local s = log
	--width = get_display():width()
	--print(s, 0, gui.y - (lines * 11))
	--print(width, 0, 0)
	
	if buggedChat==true then
		rectfill(20,70,100,115,17)
		print("PicoChat is\nunavailable\nat the moment,\ntry later!",23,73,19)
	end

	if username=="Anon" then 
		rectfill(10,21,114,35,28)
		print("\014type:\34/NICK [YOUR-NAME]\34\nto choose a nickname!",14,23,19)
	else
		rectfill(10,21,114,31,28)
		print("Hey, "..username.."!",14,23,19) 
	end
		
end

buggedChat=false
-- Fetching functions
function send(msg)
	-- Change to GET if MSG is blank
	adr = getOnNil(msg)
	
	-- Send our msg off
	local ret = ""
	local c = cocreate(function()
		ret = fetch(adr)
	end)
	
	local count=0
	local fixvar = costatus(c)
	while (fixvar != "dead") do
		coresume(c)
		
		count=count+1
		
		if count>100 then 
			fixvar = "dead" 
			buggedChat=true
		end
		
	end
	
	if ret != nil then
		if ret != oldRet then
			oldRet = ret
			displayLog = decode(ret)
			
			--oldRet = ret
			--local out = word_wrap(decode(ret), width, false)
			--local out = decode(ret)
			-- Return what fetch returned
			--displayLog = out
		end
	end

	return c
end


--[[ Only bell if you weren't the last person to chat
	local i = #displayLog - 1
	local out = ""
	repeat
		if sub(displayLog, i, i) == "\n" then
			out = sub(displayLog, i+2, i+#username+1)
			i = 1
		end
		i -= 1
	until i == 0
	if response != lastLog and out != username and mute != true then 
		music(0) 
		lastLog = response 
	end
end]]--




-- Update details from windows
on_event("name", function(ret)
	username = ret.data
	save()
end)

on_event("server", function(ret)
	server = ret.data
	save()
end)

on_event("resize", (function() 
	oldRet = ""
end))

-- Init the menu items
menuitem {
	id = 1,
	label = "Change Name",
	action = (function()
		create_process("name.lua", {pw=pid(), data=username})
	end)
}

menuitem {
	id = 0,
	label = "Change Server",
	action = (function()
		create_process("server.lua", {pw=pid(), data=server})
	end)
}

menuitem {
	id = 2,
	label = "Mute / Unmute",
	action = (function()
		if mute then mute = false else mute = true end
	end)
}
-- Create the msgbox
chatGui = create_gui()
msgbar = chatGui:attach_text_editor({
	x = 7, 
	y = 177-12, 
	width = 109,
--	width_rel = 1.0,
	height = 12,
--	height_rel = 1.0,
	max_lines = 1,
	key_callback = { 
		enter = (function()
			-- Check to see if a command
			local str = msgbar:get_text()[1]
			if sub(str, 1, 6) == "/nick " and #str >= 7 then
				username = sub(str, 7)
				save()
			elseif sub(str, 1, 8) == "/server " and #str >= 9 then
				server = sub(str, 9)
				save()
			elseif str=="" or str==" " or str=="/nick" or str=="/nick " then 
				 --if wrong typing clear txt bar
			else
				send(msgbar:get_text()[1])
			end
			msgbar:set_text("")
			msgbar:set_keyboard_focus(false)
		end),
		click = function(self)
			--set_keyboard_focus(true)
			msgbar:set_keyboard_focus(true)
		end
	}
})

--if msgbar.clicked==true and homeBtn.clicked==false and backBtn.clicked==false then
--msgbar:set_text{"/nick "}
--msgbar:set_keyboard_focus(true) --this alone takes 8% CPU
--msgbar:click({mx=1000,my=2})
--end