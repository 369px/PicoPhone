--[[pod_format="raw",created="2024-06-11 03:37:35",modified="2024-06-13 23:29:36",revision=701]]
firstTimeMenu=true
menuGUI = create_gui()
function bootMenu()
	tacoEye={x=95,y=10}
	local tacoTalks = menuGUI:attach{x=7,y=19,width=113,height=22,cursor="pointer",
							draw=function(self) 
								if currentPage=="menu" then drawFunctions.tacoTalks() end
							end,
							tap=function(self) 
							if currentPage=="menu" then updateTacoMsg() end
							end
	}
							
	--MAIN MENU
	local mainMenu = menuGUI:attach{x=7,y=41,width=113,height=113}
	startMenuX = 5
	startMenuY = 4
	
	local cPanel = mainMenu:attach{ x = startMenuX, y = startMenuY,width=32,height=32,
							cursor="pointer",clicked=false,
							draw=function(self)
									if self.clicked==false then spr(15,0,0)
									else spr(23,0,0) end
							end,
							tap=function(self)
							loadUserdata()
								lastPage=currentPage currentPage="cPanel"
								
							end,
							click=function(self) 
								self.clicked=true 
							end,
							release=function(self) self.clicked=false end
	}
		
	local colorsApp = mainMenu:attach{ x = startMenuX+32+3, y = startMenuY,width=32,height=32,
							cursor="pointer",clicked=false,
							draw=function(self)
									if self.clicked==false then spr(8,0,0)
									else spr(16,0,0) end
							end,
							tap=function(self)
								lastPage=currentPage currentPage="colors"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	
	local charsApp = mainMenu:attach{ x = startMenuX+64+6, y = startMenuY,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(9,0,0)
									else spr(17,0,0) end
							end,
							tap=function(self)
								lastPage=currentPage currentPage="specialChar"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	
	local midiApp = mainMenu:attach{ x = startMenuX, y = startMenuY+32+3,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(10,0,0)
									else spr(18,0,0) end
							end,
							tap=function(self)
								lastPage=currentPage currentPage="midi2pico"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
		
	local calculatorApp = mainMenu:attach{ x = startMenuX+32+3, y = startMenuY+32+3,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(11,0,0)
									else spr(19,0,0) end
							end,
							tap=function(self)
								lastPage=currentPage currentPage="calculator"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	
	local chatApp = mainMenu:attach{ x = startMenuX+64+6, y = startMenuY+32+3,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(14,0,0)
									else spr(22,0,0) end
							end,
							tap=function(self)
								lastPage=currentPage currentPage="chat"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	--[[
				--to change name of this miniapp slot
		local settingsApp = mainMenu:attach{ x = startMenuX, y = startMenuY+64+6,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(12,0,0)
									else spr(20,0,0) end
							end,
							tap=function(self)
								--lastPage=currentPage currentPage="settings"
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	
	local addApp = mainMenu:attach{ x = startMenuX+32+3, y = startMenuY+64+6,width=32,height=32,
							clicked=false,cursor="pointer",
							draw=function(self)
									if self.clicked==false then spr(13,0,0)
									else spr(21,0,0) end
							end,
							tap=function(self)
									
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
	--]]
	
--MARKET SLIDE AT BOTTOM
		
	local marketSlide = menuGUI:attach{x=7,y=155,width=113,height=23,
							cursor="pointer",clicked=false,yAnim=0,
							draw=function(self) 
								drawFunctions.marketSlide(self,self.yAnim) 
							end,
							update=function(self)
								if (self.clicked==true) then  
									if self.y>15 then
										self.y-=20
										self.height+=20
									else 
										lastPage=currentPage currentPage="market"
										self.y=155 self.height=23 self.clicked=false
									end
								end
							end,
							tap=function(self) self.clicked=true end
							
	}
 end