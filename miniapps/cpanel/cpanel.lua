--[[pod_format="raw",created="2024-05-01 23:52:48",modified="2024-05-02 13:09:08",revision=496]]
local areYouSure=false

firstTimeCPanel=true
cPanelGUI = create_gui()
function bootCPanel()
	local title = cPanelGUI:attach{x=10,y=22,width=113,height=15,draw=function(self) print("\014control panel",27,2,19) end}
	
	local scrollView = cPanelGUI:attach{x = 7, y = 7, width = 113, height = 171}
	local scrollable = scrollView:attach{x=0,y=25,width=113,height=171}
	
	local newCart = scrollable:attach{x=0,y=0,width=113,height=15,
			draw = function(self)  
				if self.clicked==true then 
					rectfill(0,0,self.width,self.height,19)
					print("Remember to save!",4,4,7)
				else
					print("Start New Cart (save)",4,4,0)
				end
				
				line(0,14,119,14,17)
			end,
			tap=function(self) run_terminal_command("load #new") end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}
			--[[
	local time = scrollable:attach{x=0,y=15,width=113,height=15,
			draw=function(self)
				print("Phone color:",4,4,0)
				line(0,14,119,14,17)
				
				rectfill(80,4,86,10,0)
				rect(91,4,97,10,6)
				rectfill(102,4,108,10,6)
				
				if phoneColor==0 then rect(78,2,88,12,24) 
				elseif phoneColor==7 then rect(89,2,99,12,24) 
				else  rect(100,2,110,12,24) end
			end,
			tap=function(self)
				if phoneColor==0 then phoneColor=7
				elseif phoneColor==7 then phoneColor=6
				else phoneColor=0 end
			end}
			
	local reinstall = scrollable:attach{x=0,y=30,width=113,height=15,clicked=false,
			draw=function(self)
				if self.clicked==true then 
					rectfill(0,0,self.width,self.height,19) 
					print("Move my PicoPhone!",4,4,7)
				else
					print("Move my PicoPhone...",4,4,0)
				end
				line(0,14,119,14,17)
			end,
			tap=function(self)
			--	currentPage="installer"
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}
	
		
				--	run_terminal_command("load #new")
				--	run_terminal_command("save")  --sometimes it doesn't have time to save!
				

	scrollable:attach_scrollbars{autohide=true}

--[[
	local confirmMSG = cPanelGUI:attach{x=8,y=30,width=103,height=100,
							choiceYes=false,choiceNo=false,choiceCancel=false,
							draw=function(self)
								if areYouSure==true then 
									rectfill(self.x,self.y,self.width,self.height,19)
									--rect(self.x,self.y,self.width-1,self.height-1,28)
									
								end
							end
	}--]]
	
end