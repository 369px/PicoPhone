--[[pod_format="raw",created="2024-05-01 23:52:48",modified="2024-06-13 23:33:01",revision=8591]]
cPanelGUI = create_gui()
cPanelGUI.firstTime=true
cPanelGUI.disableAll=false

function bootCPanel()
	
	local defaultMSG = "\014   \130click something!"

	local title = cPanelGUI:attach{x=7,y=19,width=113,height=17,
						draw=function(self) 
							g369.fillBG(self,19)
							print("\014control panel",31,6,7) 
						end}

	local fastLoad = cPanelGUI:attach{x=7,y=title.y+title.height,width=113,height=65,
						draw=function(self)
							g369.fillBG(self,6)
							print("FAST-LOADER",29,7,19)
						--	line(24,19,89,19,19)
							rectfill(0,self.height-3,self.width,self.height,19)
						end	}
	--[[					
	local txtBar = cPanelGUI:attach{x=7,y=fastLoad.y+fastLoad.height,width=113,height=20,clicked=false,
						draw=function(self)
							g369.fillBG(self,19)
							g369.bottomLine(self,5)
						end	}

	txtEditor = txtBar:attach_text_editor({ --text bar to insert name of cart
		x=3,y=4,
		width=107,
		height=14,
		markup=false,
		bgcol=19,
		fgcol=7,
		cartSlot=0,
		action=false, --to check if a gui element has been clicked
		currentTxt="",
		typedEnter=false,
	--	has_focus=false,
		key_callback = { 
				enter = (function(self)
					local userInput = checkSlashInPath(txtEditor.get_text()[1])
					--to do: add "/" at beginning of path of there isn't one	
					
					--get_file_icon(userInput)
					if fstat(userInput) then --if file exist
						--put file path inside currentText variable
						txtEditor.currentTxt = userInput
						--activate typedEnter variable
						txtEditor.typedEnter=true
					
						notify("Saving '"..txtEditor.currentTxt..
								"' in slot #"..txtEditor.cartSlot.."...")
						
						txtEditor:set_text("") --put txtEditor settings to default
						txtEditor:set_keyboard_focus(false)
					else
						notify("\130: File path doesn't exist!")
					end
				end)}
	})
	txtEditor:set_keyboard_focus(false)
	
						  
	local txtEdClickable = txtBar:attach{x=0,y=0,width=txtBar.width,height=txtBar.height,
					draw=function(self)
						if not txtEditor:has_keyboard_focus() then 
							print(defaultMSG,9,7,7) 
							txtEditor.fgcol=19
						else txtEditor.fgcol=7
						end
					end
	}--]]

	local rowY=25
	
	local cart1, cart2, cart3
	
	cart1 = fastLoad:attach{ idSlot=1,x = 5, y = rowY,width=31,height=25,
							cursor="pointer",clicked=false,rightClick=false,col=6,
							draw=function(self) drawSlot(self,phone_userdata.slot1) end,
							tap=function(self)
								--tapSlot(self,phone_userdata.slot1)	
								if self.rightClick then 
									
									if 	not cPanelGUI.disableAll then 
										phone_userdata.slot1 = nil
										store("/appdata/369/phone_userdata.pod",phone_userdata)
										self.rightClick=false
									end
										
									cPanelGUI.disableAll=false
								else
									fastloadCart(phone_userdata.slot1) 
								end
								
							end,
							click=function(self,msg) 
								cart2.clicked = false cart2.rightClick = false
								cart3.clicked = false cart3.rightClick = false
								if msg.mb==2 then --self.clicked=false 
									cPanelGUI.disableAll=false
									self.rightClick=true
								--	self.clicked=true
								else 
									self.clicked=true 
									if cPanelGUI.disableAll then self.rightClick=false end
								end
							end,
							release=function(self) self.clicked=false end
	}
	
	cart2 = fastLoad:attach{ idSlot=2, x = 41, y = rowY,width=31,height=25,
							cursor="pointer",clicked=false,rightClick=false,col=6,
							draw=function(self) drawSlot(self,phone_userdata.slot2) end,
							tap=function(self) 
								--tapSlot(self,phone_userdata.slot1)	
								if self.rightClick then 
									if 	not cPanelGUI.disableAll then 
										phone_userdata.slot2 = nil
										store("/appdata/369/phone_userdata.pod",phone_userdata)
										self.rightClick=false
									end
									cPanelGUI.disableAll=false
									
								else fastloadCart(phone_userdata.slot2) 
								end
							end,
							click=function(self,msg) 
								cart1.clicked = false cart1.rightClick = false
								cart3.clicked = false cart3.rightClick = false
								if msg.mb==2 then --self.clicked=false 
									cPanelGUI.disableAll=false
									self.rightClick=true
								else 
									self.clicked=true 
									if cPanelGUI.disableAll then self.rightClick=false end
								end
							end,
							release=function(self) self.clicked=false end
	}
	
	cart3 = fastLoad:attach{ idSlot=3, x = 77, y = rowY,width=31,height=25,
							cursor="pointer",clicked=false,rightClick=false,col=6,
							draw=function(self) drawSlot(self,phone_userdata.slot3) end,
							tap=function(self) 
								--tapSlot(self,phone_userdata.slot1)	
								if self.rightClick then 
									if 	not cPanelGUI.disableAll then 
										phone_userdata.slot3 = nil
										store("/appdata/369/phone_userdata.pod",phone_userdata)
										self.rightClick=false
										
									end
									cPanelGUI.disableAll=false
								else fastloadCart(phone_userdata.slot3) 
								end
							end,
							click=function(self,msg) 
								cart2.clicked = false cart2.rightClick = false
								cart1.clicked = false cart1.rightClick = false
								if msg.mb==2 then 
									cPanelGUI.disableAll=false
									--self.clicked=false
									self.rightClick=true
								else 
									self.clicked=true 
									if cPanelGUI.disableAll then self.rightClick=false end
								end
							end,
							--hover=function(self) self.col=8 end,
							release=function(self) self.clicked=false end
	}	
		
	local scrollView = cPanelGUI:attach{x = 7, y=fastLoad.y+fastLoad.height, width = 113, height = 171,
							draw = function(self)
								--rect(0,0,self.width-1,self.height-1,19)
								
							end
	}
	
	local scrollable = scrollView:attach{x=0,y=0,width=113,height=146}
	
	local rowDistance=16
	
	local newCart = scrollable:attach{x=0,y=rowDistance*0,width=113,height=rowDistance,
			cancel=false,clicked=false,tapped=false,
			draw = function(self)  
				if self.tapped==true then 
					rectfill(0,0,self.width,self.height,17)
					print("Save current cart?\ny=yes / n=no",4,4,7)
					line(3,self.height-1,self.width-4,self.height-1,28)
				elseif self.tapped==false then
					print("Start a new cart...",4,4,0)
					line(3,self.height-1,self.width-4,self.height-1,17)
				end
			end,
			update=function(self) 
				if self.tapped==true then
					if self.height<28 then
						self.height+=4
					end
					
					if keyp("y") then 
						run_terminal_command("save")
						notify("\130: Cart saved! Loading new cart...")
						self.tapped=false self.cancel=false
						
						for i=1,30 do
							flip()
						end
					end
					
					if keyp("n")  then
						notify("\130: Loading new cart...") 
						self.tapped=false self.cancel=false
					end
					
					
				else
					if self.height>16 then
						self.height-=2
						
						if self.cancel==false and self.height==18
						then 
							run_terminal_command("load #new") 
							notify("\130: New cart loaded!") 
						end
					end
				end
			end,
			tap=function(self) 
				if 	self.tapped==false then self.tapped=true
				else self.tapped=false self.cancel=true end
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}	
	
	local anyWhen = scrollable:attach{x=0,y=rowDistance*1,width=113,height=rowDistance,
			draw=function(self)
				if self.y!=newCart.height then
					self.y=newCart.height
					
				end
				
				print("Restore lost cart! \147",4,4,0)
				line(3,self.height-1,self.width-4,self.height-1,17)
				--rect(0,0,self.width-1,self.height-1,19)
				
			end,
			tap=function(self)
				--run_program_in_new_process(pwd(), argv)
			end}
	
--	scrollable:attach_scrollbars{autohide=true}
	
	cPanelGUI.click=function(self)
				--		txtEditor:set_keyboard_focus(false)
				--		txtEditor:set_text("")	
						
			if not cart1.clicked and not cart2.clicked and not cart3.clicked
			and not newCart.clicked
			then self.disableAll=true end
				
			--		if self.disableAll and cart1.rightClick then cart1.rightClick=false
			--		else self.disableAll=true end
						
						
						
	end

end

function drawSlot(el,userdataSlot)
	if userdataSlot then 
		if el.clicked then g369.BGbord(el,15) end
									
		if el.rightClick and not cPanelGUI.disableAll then 
			g369.fillBG(el,8)
			print("\014tap to\nclear\nslot",2,2,7)
		else drawP64(userdataSlot,7,0) 
		end				
	else
		if el.clicked==false then g369.emptySlot(3,0,el.idSlot,el.col)
		else g369.emptySlot(3,0,el.idSlot,19) end
	end	
end

function drawP64(userdataSlot,x,y)
	spr(userdataSlot.icon,x,y) --7,0
	if userdataSlot.title then print("\014"..userdataSlot.title,x-7,y+20,1)
	else print("\014NoTitle?",x-7,y+20,1) end
end

function showFilenavTooltray()	
	filenavCart = create_process(
		"/system/apps/filenav.p64", -- this is the location in the filesystem of the app we want to run
		{
			path = "/", -- this is the folder where you want the filebrowser to open to
			--open_with = env().prog_name, -- this is the app you want to open the file with (env().prog_name will be the current program)
			window_attribs = { -- these are attributes which change how to app is run
				x=calcFileNavYPos(), y=10, width=160, height=240,
			   workspace = "tooltray", -- this is the workspace the app will run in
			  	autoclose=true
			}
		}
	)
end

function calcFileNavYPos()
	if phone_userdata.position == "left" then return 150 end
	if phone_userdata.position == "center" then return 10 end
	return 170
end

function tapSlot(el,userdataSlot)

end

function fastloadCart(userdataSlot)
	if not userdataSlot then
		notify("\130: Drop a cart to load it inside a slot!")
		if phone_userdata.position != "desktop" then
			showFilenavTooltray()
		end
	else
		run_terminal_command("load "..userdataSlot.path)
		notify("\130: "..userdataSlot.path.." loaded in /ram/cart")
	end

--exit(process_id)

--[[
	textEd:set_keyboard_focus(true)
	textEd:set_text("")
	textEd.action=true
	
	textEd.cartSlot=slotNum
	notify("\130: Paste in a cart path to save it in slot #"..textEd.cartSlot.."!")

	textEd.bgcol=19 textEd.fgcol=7


--[[
	if not textEd:has_keyboard_focus() then
		textEd.bgcol=19 textEd.fgcol=17
		textEd.cartSlot=slotNum
		textEd:set_text("")
		textEd:set_keyboard_focus(true)
		notify("\130: paste in a cart path to save it in slot "..textEd.cartSlot.."!")
	else
		textEd:set_keyboard_focus(false)
		textEd:set_text("\014click and paste cart path")
		textEd.bgcol=6 textEd.fgcol=19
		notify("\130: click a slot and paste in a cart path!")
	end
	
--]]
end