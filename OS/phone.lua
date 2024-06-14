--[[pod_format="raw",created="2024-06-11 03:29:00",modified="2024-06-14 16:42:03",revision=824]]
firstTimeEver=true
gui = create_gui()

function bootPhone()
	local display = gui:attach{x = 7, y = 7, width = 113, height = 171,
					click=function(self) timeToSleep=0 end}
	
	--STATUS BAR---
	local statusBar = display:attach{x=0,y=0,width=113,height=12,
							draw=function(self) drawFunctions.statusBar(self) end
	}
	
	--sleep button
	local sleepBtn = statusBar:attach{x=92,y=0,width=21,height=12,
						clicked=false,cursor="pointer",
							draw=function(self)
								if self.clicked==false then drawFunctions.sleepBtn(self,24)
								else drawFunctions.sleepBtn(self,8) end
							end,
							tap=function(self)
								closedPage=currentPage powerState="OFF" currentPage="sleep" 
							end,
							click=function(self) self.clicked = true end,
							release=function(self) self.clicked=false end
	}
							
	local backBtn = statusBar:attach{x=0,y=0,width=30,height=11,
							clicked=false,cursor="pointer",tapped=false,
							draw=function(self)
								if self.clicked==false then drawFunctions.backBtn(self,19)
								else drawFunctions.backBtn(self,17) end
							end,
							update=function(self)
									if (self.tapped==true) then  
										if currentPage!="menu" then
											currentPage=lastPage  updateTacoMsg()
											self.tapped=false
										else
											lastPage=currentPage currentPage="settings"
											self.tapped=false
										end
									end
								
							end,
							tap=function(self) self.tapped=true end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	
	local popUp = display:attach{x=5,y=57,width=103,height=70,clicked=false,
					draw=function(self) 
						if popItUp() then drawPopUp(self) popUpQuestion() end			
					end,
					update=function(self)
						if popItUp() then popUpQuestion() end
					end,
					tap=function(self) tapPopUp(self) end,
					click=function(self) self.clicked = true end,
					release=function(self) self.clicked=false end
	}
					
	
	local homeBtn = gui:attach{x=53,y=182,width=18,height=18,clicked=false,cursor="pointer",
					draw=function(self) if self.clicked==true then circ(9,9,9,6) end end,
					tap=function(self) currentPage="menu" end,
					click=function(self) self.clicked = true  updateTacoMsg() end,
					release=function(self) self.clicked=false end
	}
end	

function popItUp()
	if currentPage=="update"
	then return true
	else return false
	end
end

function drawPopUp(el)
	g369.fillBG(el,19) g369.BGbord(el,6)

	local yes={x1=7,y1=el.height-25,x2=37,y2=el.height-8}
	local no
	
	rectfill(yes.x1,yes.y1,yes.x2,yes.y2,
				clickedZone(el,19,113,49,130) and 1 or 17) --if element clicked, color 1
	line(yes.x1,yes.y2,yes.x2,yes.y2,1)
	print("YES",16,el.height-20,
			clickedZone(el,19,113,49,130) and 7 or 19) --if el clicked, color 7
	
	rectfill(el.width-39,el.height-25,el.width-8,el.height-8,
				clickedZone(el,76,113,107,130) and 1 or 17)
	line(el.width-39,el.height-8,el.width-8,el.height-8,1)
	print("NO",76,el.height-20,
			clickedZone(el,76,113,107,130) and 7 or 19)
	
	spr(1,43,el.height-24)
end

function popUpQuestion()
	if currentPage=="update" 
	then print("NEW UPDATE: "..updatePhone.lastVersion.."\nDo you want me to\nupdate now?",7,7,7) end
end

function tapPopUp(el)
	if clickedZone(el,19,113,49,130) then 
		if currentPage=="update" then updatePhone.loadUpdate() end
	elseif clickedZone(el,76,113,107,130) then 
		if currentPage=="update" then currentPage="menu" end
	end
end