--[[pod_format="raw",created="2024-06-11 03:38:38",modified="2024-06-13 23:29:50",revision=1200]]
firstTimeSettings=true
settingsGUI = create_gui()

function bootSettings()
	local title = settingsGUI:attach{x=7,y=19,width=113,height=17,
						draw=function(self) 
							g369.fillBG(self,19)
							print("\014settings",41,6,7) 
						end}
	local scrollView = settingsGUI:attach{x = title.x, y = title.y+title.height, width = 113, height = 171}
	local scrollable = scrollView:attach{x=0,y=3,width=113,height=171}
	
	local appVrs = scrollable:attach{x=0,y=0,width=113,height=16,
			draw = function(self)  
				--rectfill(0,0,self.width,self.height,17)
				print("miniOS:",5,4,0)
				print(appVersion,78,4,19)
				g369.bottomLine(self,17) --line(0,14,119,14,17)
			end}
			
	local checkUpdate = scrollable:attach{x=0,y=appVrs.height,
											width=113,height=16,clicked=false,
			draw=function(self)
				if self.clicked==true then 
					rectfill(0,0,self.width,self.height,19) 
					print("Check updates...",5,4,7)
				else
					print("Check updates...",5,4,0)
				end
				g369.bottomLine(self,17)--line(0,14,119,14,17)
			end,
			tap=function(self)
				if not updatePhone.isLatestVersion() then 
					lastPage=currentPage currentPage="update"
				else notify("\130: Couldn't find update...") end
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}	
						
	local reinstall = scrollable:attach{x=0,y=checkUpdate.y+checkUpdate.height,
											width=113,height=16,clicked=false,
			draw=function(self)
				if self.clicked==true then 
					rectfill(0,0,self.width,self.height,19) 
					print("Move my PicoPhone!",5,4,7)
				else
					print("Move my PicoPhone...",5,4,0)
				end
				g369.bottomLine(self,17)--line(0,14,119,14,17)
			end,
			tap=function(self)
				currentPage="installer"
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}		
			
	local phoneCol = scrollable:attach{x=0,y=reinstall.y+reinstall.height,
											width=113,height=16,
			draw=function(self)
				print("Phone color:",5,4,0)
				g369.bottomLine(self,17)--line(0,14,119,14,17)
				
				rectfill(78,4,84,10,0)
				rect(89,4,95,10,6)
				rectfill(100,4,106,10,6)
				
				if phoneColor==0 then rect(76,2,86,12,24) 
				elseif phoneColor==7 then rect(87,2,97,12,24) 
				else  rect(98,2,108,12,24) end
			end,
			tap=function(self)
				if phoneColor==0 then phoneColor=7
				elseif phoneColor==7 then phoneColor=6
				else phoneColor=0 end
			end}	
	
	local sleepTimer = scrollable:attach{x=0,y=phoneCol.y+phoneCol.height,
								width=113,height=16,
			draw=function(self)
				print("Sleep Timer:",5,4,0)
				g369.bottomLine(self,17)--line(0,14,119,14,17)
				
				print("\01420S",68,5,0)	
				print("\01440S",82,5,0)
				print("\014off",96,5,0)
				
				if timeSleepNow==600 then rect(66,2,80,12,24) 
				elseif timeSleepNow==1200 then rect(80,2,94,12,24) 
				else  rect(94,2,108,12,24) end
			end,
			tap=function(self)
				if timeSleepNow==600 then timeSleepNow=1200 
				elseif timeSleepNow==1200 then timeSleepNow=0
				else timeSleepNow=600 end
			end}
--[[
local bgCol = scrollable:attach{x=0,y=30,width=113,height=15,
			draw=function(self)
				print("BG (default:1):",4,14,0)
				line(0,14,119,14,17)
				
				rectfill(80,4,86,10,0)
				rect(91,4,97,10,6)
				rectfill(102,4,108,10,6)
			end,
			tap=function(self)
	
			end
}		
--]]



	scrollable:attach_scrollbars{autohide=true}

end