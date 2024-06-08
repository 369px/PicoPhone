--[[pod_format="raw",created="2024-04-09 13:44:42",modified="2024-06-08 22:43:07",revision=19726]]
include "graphics.lua"
include "click.lua"
include "OS.lua"
include "utils/drop.lua"
include "miniapps/kawaiiculator.lua"
include "miniapps/miditron/mainMiditron.lua"
include "miniapps/cpanel/cpanel.lua"
include "miniapps/picochat/mainChat.lua"
include "miniapps/minimarket/minimarket.lua"
include "updateApp.lua"
include "utils/369gui.lua"
include "utils/icon.lua"
include "utils/terminal.lua"
include "utils/utilityFunctions.lua"
include "utils/finfo.lua"

window{--window settings
	width=127,
	height=205,
	title="PicoPhone\130",
	resizeable=false,
	workspace = "current"
}

function _init()
	drawFunctions.splashScreen()
		
	send()--send for PicoChat
	
--	initCalc()    
end

phone_userdata = {} --define table where we save userdata

--update debug
picoExists="\nPhone doesn't exist!\nCreating phone..."
setExists="\nSettings.txt doesn't\nexist! Creating it"
sameSettings = ""
folder369exists="\n369 folder exists!"
installedCorrectly="\n...Problem installing\nPicophone!"

--Phone Specs
phoneColor=0
timeToSleep=0 --var that counts frames to sleep
timeSleepNow=600 --timeOfSleeping (20 seconds)
phoneDisplay = {x1=7,y1=7,x2=119,y2=177} --width=112 // height=170

tacoFace= --[[pod_type="gfx"]]unpod("b64:bHo0AGwAAACPAAAA8QBweHUAQyAQEAQfEQ8TAWAGABgADAAQPwYALSA-DABRTxEfE18KAGAPESo_Kh4KABAOCQAQDQgAMQ4XDgoAkE4XXg0BAC5XPhYAQTcfDjcfACE3HAgA8AR3ATcGDxYANzFHBgsglwZAlwYg")

--CHECK LAST PAGE
currentPage="sleep"
lastPage="menu"
closedPage="menu"--var for sleep

powerState="OFF"

firstTimeEver=true
gui = create_gui()
function bootPhone()

	local display = gui:attach{x = 7, y = 7, width = 113, height = 171,
					click=function(self) timeToSleep=0 end}
	
	local homeBtn = gui:attach{x=53,y=182,width=18,height=18,clicked=false,cursor="pointer",
					draw=function(self) if self.clicked==true then circ(9,9,9,6) end end,
					tap=function(self) currentPage="menu" end,
					click=function(self) self.clicked = true  updateTacoMsg() end,
					release=function(self) self.clicked=false end
					}
	
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
							clicked=false,cursor="pointer",
							draw=function(self)
								if self.clicked==false then drawFunctions.backBtn(self,19)
								else drawFunctions.backBtn(self,17) end
							end,
							tap=function(self) 
								if currentPage!="menu" then
									currentPage=lastPage  updateTacoMsg() 
								else
									currentPage="settings"
								end
							end,
							click=function(self) self.clicked=true end,
							release=function(self) self.clicked=false end
	}
		
end

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
	
	local appVrs = scrollable:attach{x=0,y=0,width=113,height=15,
			draw = function(self)  
				--rectfill(0,0,self.width,self.height,17)
				print("miniOS:",4,4,0)
				print(appVersion,80,4,19)
				line(0,14,119,14,17)
			end}
			
	local phoneCol = scrollable:attach{x=0,y=appVrs.height,width=113,height=15,
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
			
	local reinstall = scrollable:attach{x=0,y=phoneCol.y+phoneCol.height,
											width=113,height=15,clicked=false,
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
				currentPage="installer"
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end}			
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

--DUMB INITS
--initMidi()

--[[
menu={} --MINIAPPS
menu[1]={label="Colors",sprite=8,x=startMenuX,y=startMenuY,pressed=false,cursor="pointer"}--btn colors
menu[2]={label="\146\141\135\130",sprite=9,x=startMenuX+35,y=startMenuY,pressed=false,cursor="pointer"}--btn special chars
menu[3]={label="Midi2Pico",sprite=10,x=startMenuX+70,y=startMenuY,pressed=false,cursor="pointer"}

menu[4]={label="Calculator",sprite=11, x=startMenuX , y=startMenuY+37 , pressed=false,cursor="pointer"}
menu[5]={label="addMiniApp",sprite=13,x=startMenuX+35, y=startMenuY+37, pressed=false,cursor="pointer"}
menu[6]={label="settings",sprite=12,x=startMenuX+70, y=startMenuY+37, pressed=false,cursor="pointer"}
--]]
-- BBS CARTS
bbsCarts={
	tools={},
	screensavers={},
	wallpapers={},
	games={},
	music={},
	libraries={},
	demos={}
}

bbsCarts.tools[1]={label="OKPAL palette editor",description="Use your own palette\nin Picotron!",
						longDescr="Okpal is a tool to\ncreate and edit color\npalettes. You can then\neasily use them in\nyour programs, and\neven directly in\nPicotron's sprite and\nmap editors.",code="#okpal"}
bbsCarts.tools[2]={label="Vector Gfx Editor",description="Draw vectors without\nwriting code!",
						longDescr="Veditor is a vector\ngraphics editor that\nlets you work on\nmultiple, layered\nvector sprites!\nJust include 'vgfx.lua'\nin your projects.",code="#veditor"}
bbsCarts.tools[3]={label="P8X8 Pico8->Picotron",description="Convert your pico8\ncarts to Picotron!",
						longDescr="A tool to convert\nPICO-8 cartridges into\nPicotron. It attempts\nto convert things well\nenough, and expects\nthe user to make some\ntweaks afterwards.",code="#p8x8"}
bbsCarts.tools[4]={label="Visitrack Sfx Editor",description="An alternative music\neditor version!",
						longDescr="VisiTrack is a music\ntracker, alternative\nto the SFX editor\nprovided with Picotron.\nThis is still a\nwork in progress!",code="#visitrack"}
bbsCarts.tools[5]={label="Picotron Wiki",description="A ton of knowledge\nin a single cart!",
						longDescr="A cart that aims to\nbe the biggest\nrepository of\nPicotron knowledge!\nYou can contribute and\nadd your own pages.",code="#picotron_wiki"}
bbsCarts.tools[6]={label="Paint",description="A Microsoft paint\nlookalike editor!",
						longDescr="A nostalgic image\neditor made to imitate\nthe look of old\nMicrosoft Paint!\nIt isn't meant to\nreplace the built-in\ngfx editor.",code="#paint"}
bbsCarts.tools[7]={label="EnView API Viewer",description="All APIs that are\nbeing used in PT!",
						longDescr="Look how APIs are\nbeing used in Pictron\nand what parameters\nthey need to perform\nas expected!",code="#enview"}
bbsCarts.tools[8]={label="Manual in terminal",description="Read the manual\nin the terminal!",
						longDescr="This installs the man\nterminal utility for\nreading documentation\nwithin picotron itself.\nIf something is not\ndocumented man will\nintelligently search\nthe Fandom Wiki! ",code="#man"}
bbsCarts.tools[9]={label="PicoNet explorer",description="Isolated version of\nthe internet!",
						longDescr="A little isolated\nversion of the WWW.\nCheck out the BBS\nto make your own\nPicoNet website!",code="#piconet_explorer"}
bbsCarts.tools[10]={label="Slate code editor",description="A floating window\ncode editor!",
						longDescr="Advanced Text Editor\nto write code in a\nfloating window!\nIt does everything the\nbuilt-in code editor\ncan do (and more!)",code="#slate"}
bbsCarts.tools[11]={label="SpritePaper",description="Use your sprites\nas wallpapers!",code="#spritepaper"}

bbsCarts.screensavers[1]={label="Pixel Earth",description="2D earth texture\nsphere imitation",code="#earth"}
bbsCarts.screensavers[2]={label="Circle Chase",description="Moving circles that\nfollow your mouse!",code="#circle_chase"}
bbsCarts.screensavers[3]={label="Matrix",description="A classic screensaver\ninspired by Matrix",code="#matrix_screensaver"}
bbsCarts.screensavers[4]={label="Pong Wars",description="Two sides locked in\nan eternal battle.",code="#pong_wars"}
bbsCarts.screensavers[5]={label="Tiny Rain",description="A simple rain effect\nanimation.",code="#tiny_rain"}
bbsCarts.screensavers[6]={label="Pixel Rain",description="Pixel rain that fill\nup your screen.",code="#pixel_rain"}
bbsCarts.screensavers[7]={label="Cross-Eye Waves",description="Cross your eyes to\nsee a 3d wave effect.",code="#crosseye_waves"}
bbsCarts.screensavers[8]={label="Flying Pictron",description="Flying Picotron logos\neverywhere!",code="#flying_picotron"}
bbsCarts.screensavers[9]={label="Universe",description="Is this how the\nuniverse started?",code="#universe"}
bbsCarts.screensavers[10]={label="Milky Way",description="The milky way is\nMASSIVE!",code="#milkyway"}

bbsCarts.wallpapers[1]={label="Orbital Clock",description="Time orbiting the\nclock as planets.",code="#orbital_clock_wp"}
bbsCarts.wallpapers[2]={label="Jongtelling",description="Fortune telling with\nmahjong tiles.",code="#jongtelling_wp"}
bbsCarts.wallpapers[3]={label="Blinking cat",description="A cat that blinks\nwhen you go near!",code="#hansecat"}
bbsCarts.wallpapers[4]={label="Reacting grid",description="A grid that reacts\nto mouse movement",code="#grid_wallpaper"}
bbsCarts.wallpapers[5]={label="Desktop Pet",description="Adopt some cute pets\nin your desktop!",code="#dekstop_pet"}
bbsCarts.wallpapers[6]={label="Cats meeting",description="Your desktop is now\na cat meeting place!",code="#catsmeeting"}
bbsCarts.wallpapers[7]={label="BSOD land",description="In the land of BSOD\nHD wallpaper!",code="#bsod_hd"}
bbsCarts.wallpapers[8]={label="Pocket Watch",description="Check the time\nwith style!",code="#pocket_watch_wallpaper"}
bbsCarts.wallpapers[9]={label="Wavepaper",description="Colorful waves on\nyour desktop!",code="#wavepaper"}
bbsCarts.wallpapers[10]={label="Frisbee in garden",description="A cool static\nwallpaper!",code="#frisbee_in_the_garden"}

bbsCarts.games[1]={label="Clownvaders", description="How many clown waves\ncan you survive?"}
bbsCarts.games[2]={label="Coinlife",description="Shoot enemies and\ncollect space coins!",code="#coinlife"}
bbsCarts.games[3]={label="Solitaire Suite",description="6 different solitaire\ngames in one!",code="#solitaire_suite"}
bbsCarts.games[4]={label="Solitron",description="Lightweight windows 95\nstyled solitaire!",code="#solitron"}
bbsCarts.games[5]={label="Pony 9000",description="Space pony shooting\nspace aliens!",code="#pony9k_2_2"}
bbsCarts.games[6]={label="Number Crunchers",description="Simple tile based\npuzzle game!",code="#numbercrunchers"}
bbsCarts.games[7]={label="Birdhead",description="Become the chicken\nking and  collect eggs!",code="#foraruyum"}

bbsCarts.music[1]={label="Packbat sounds", description="Collection of simple\ninstrument patches",code="#packbats_2node"}

bbsCarts.libraries[1]={label="Vector library", description="General purpose geometry/\nvector library.",code="#gavel_demos"}

bbsCarts.demos[1]={label="Smoke simulation",description="A smoke simulating\ntoy for Picotron!",code="#picotron_smoke"}
--[[
menu[5]={label="Download",x1=startMenuX,y1=startMenuY+50,x2=startMenuX+52,y2=startMenuY+70,pressed=false,col=19}
menu[6]={label="Settings",x1=startMenuX+56,y1=startMenuY+50,x2=startMenuX+108,y2=startMenuY+70,pressed=false,col=6}
--]]
--menu[7]={label="Market",x1=startMenuX,y1=startMenuY+109,x2=startMenuX+104,y2=startMenuY+125,pressed=false,col=19}

--STATUS BAR
--statusBar={} --statusBar element
--statusBar[1]={label="\22 back",x=9,y=9,col=7} --back btn
--statusBar[2]={x=10,y=188,col=7} --ram usage label
--statusBar[3]={label="zzZ",x=100,y=7,x2=119,y2=19}
	


-- MASCOTTE
--tacoBtn={x1=99,y1=22,x2=117,y2=41}
tacoTalk={"Hey, Picotroner!","My name is Taco","What r u \148 2?","A phone inside a...","I'm hungry...","Do you love me?","Love urself, ok?","This is fun","Picotron is easy!","Errors are good","Deleted terminal","BBS>Social Media","Stop touching me!","Are you happy?","You're a legend!","You == Zep","You can do it!","I'm proud of you","Great idea!\135","Picotron>>>>","The BBS needs u","You're a genius!","Is this a feature","Vote TACO","Check the cpu ;)","\130\130\130\130\130","\130>\137"}
showedMessage=tacoTalk[1]

function loadUserdata()
	if fstat("/appdata/369/phone_userdata.pod") then --if the pod file exists
		phone_userdata = fetch("/appdata/369/phone_userdata.pod") --fetch it inside phone_userdata
	else phone_userdata = {} end
end

loadUserdata()