--[[pod_format="raw",created="2024-04-08 15:21:14",modified="2024-05-01 19:27:15",revision=15870]]
--PICOPHONE 0.4.27
--Author: 369px
include "inits.lua"

appVersion = "0.4.27"
if appToUpdate() then currentPage="installer" end 

function _draw()
  	cls(1)  
	
	drawFunctions.phone()
	drawFunctions.display()
	
	drawOS() --in utils	
	

	--usage info	   
--	print(mx..","..my,50,9,15)
--	print(debugz,6,178,7)
--	print("CPU:"..string.format("%.2f",stat(1)*100).."%",6,190,phoneColor==0 and 7 or 0)
end

function _update()

	if currentPage!="sleep" and currentPage!="installer"  then
			gui:update_all()
			if currentPage=="menu" then menuGUI:update_all() end
			if currentPage=="settings" then settingsGUI:update_all() end
			if currentPage=="specialChar" then checkClick() end
			if currentPage=="calculator" then updateCalc() end
			if currentPage=="chat" then updateChat() end
			if currentPage=="market" then marketGUI:update_all() end
			if currentPage=="marketTool" then marketToolGUI:update_all() end
	else --if phone sleeping do manual click checking (way less cpu use)
		checkClick()
	end
end