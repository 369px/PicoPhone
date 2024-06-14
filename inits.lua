--[[pod_format="raw",created="2024-04-09 13:44:42",modified="2024-06-14 01:14:59",revision=21878]]
include "graphics.lua"
include "click.lua"
include "OS/OS.lua"
include "OS/phone.lua"
include "OS/menu.lua"
include "OS/settings.lua"
include "utils/drop.lua"
include "miniapps/kawaiiculator.lua"
include "miniapps/miditron/mainMiditron.lua"
include "miniapps/cpanel/cpanel.lua"
include "miniapps/picochat/mainChat.lua"
include "miniapps/minimarket/minimarket.lua"
include "miniapps/minimarket/bbscarts.lua"
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
	updatePhone.boot()
				
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
timeSleepNow=600 --timeOfSleeping (600 = 20 seconds)
phoneDisplay = {x1=7,y1=7,x2=119,y2=177} --width=112 // height=170

tacoFace= --[[pod_type="gfx"]]unpod("b64:bHo0AGwAAACPAAAA8QBweHUAQyAQEAQfEQ8TAWAGABgADAAQPwYALSA-DABRTxEfE18KAGAPESo_Kh4KABAOCQAQDQgAMQ4XDgoAkE4XXg0BAC5XPhYAQTcfDjcfACE3HAgA8AR3ATcGDxYANzFHBgsglwZAlwYg")

--CHECK LAST PAGE
currentPage="sleep"
lastPage="menu"
closedPage="menu"--var for sleep, so we save which page has been closed

--powerState="OFF"

--DUMB INITS

--[[
menu={} --MINIAPPS
menu[1]={label="Colors",sprite=8,x=startMenuX,y=startMenuY,pressed=false,cursor="pointer"}--btn colors
menu[2]={label="\146\141\135\130",sprite=9,x=startMenuX+35,y=startMenuY,pressed=false,cursor="pointer"}--btn special chars
menu[3]={label="Midi2Pico",sprite=10,x=startMenuX+70,y=startMenuY,pressed=false,cursor="pointer"}

menu[4]={label="Calculator",sprite=11, x=startMenuX , y=startMenuY+37 , pressed=false,cursor="pointer"}
menu[5]={label="addMiniApp",sprite=13,x=startMenuX+35, y=startMenuY+37, pressed=false,cursor="pointer"}
menu[6]={label="settings",sprite=12,x=startMenuX+70, y=startMenuY+37, pressed=false,cursor="pointer"}
--]]

-- MASCOTTE
--tacoBtn={x1=99,y1=22,x2=117,y2=41}
tacoTalk={"Hey, Picotroner!","My name is Taco","What r u \148 2?","A phone inside a...","I'm hungry...","Do you love me?","Love urself, ok?","This is fun","Picotron is easy!","Errors are good","Deleted terminal","BBS>Social Media","Stop touching me!","Are you happy?","You're a legend!","You == Zep","You can do it!","I'm proud of you","Great idea!\135","Picotron>>>>","The BBS needs u","You're a genius!","Is this a feature","Vote TACO","Check the cpu ;)","\130\130\130\130\130","\130>\137"}
showedMessage=tacoTalk[1]

-- User save data
function loadUserdata()
	if fstat("/appdata/369/phone_userdata.pod") then --if the pod file exists
		phone_userdata = fetch("/appdata/369/phone_userdata.pod") --fetch it inside phone_userdata
	else phone_userdata = {} end
end

loadUserdata()