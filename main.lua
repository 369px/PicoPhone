--[[pod_format="raw",created="2024-04-08 15:21:14",modified="2024-06-14 16:42:03",revision=24073]]
--PICOPHONE 0.5.3
--Thread: https://www.lexaloffle.com/bbs/?pid=146124
--GitHub: https://github.com/369px/PicoPhone
--Let's make Picotron huge!

include "inits.lua"
appVersion = "0.5.34"
phone_userdata.bbsCurrentVersion = 23
phone_userdata.miniOSversion = appVersion
bbsURL="https://www.lexaloffle.com/bbs/cart_info.php?cid=phone"

function _draw()
  	cls(1)
	
	drawFunctions.phone() --graphics.lua
	drawFunctions.display() --graphics.lua
	drawOS() --os.lua
		
	-- usage info
	--showMouseXY(50,9,15)
	--showUsageCPU()
end

function _update()
	if currentPage!="sleep" and currentPage!="installer" then
		
		mx,my,mb = mouse()
			
		gui:update_all()
		
		if currentPage=="menu" then menuGUI:update_all()end
		if currentPage=="settings" then settingsGUI:update_all()end
		if currentPage=="specialChar" then checkClick() end
		if currentPage=="cPanel" then cPanelGUI:update_all()end
		if currentPage=="calculator" then updateCalc() end
		if currentPage=="chat" then updateChat() end
		if currentPage=="market" then marketGUI:update_all() end
		if currentPage=="marketTool" then marketToolGUI:update_all() end
		if currentPage=="installComplete" then installCompleteEvents() end
			
		if timeToSleep==timeSleepNow then --each 20 seconds phone sleeps (if nothing is done)
			closedPage=currentPage
			currentPage="sleep"
			timeToSleep=0
		end	
		timeToSleep+=1
	
	else --if phone sleeping do manual click checking (way less cpu use)
		checkClick()
	end
end