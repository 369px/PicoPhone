--[[pod_format="raw",created="2024-04-18 00:41:05",modified="2024-04-28 21:12:23",revision=5545]]
function drawOS()
	if currentPage!="sleep" then --If phone is not in low usage mode 
	
		if powerState=="OFF" then --if phone just woke up and is not installer page
    		powerState="ON" 		--(we manage installation later)
    		if firstTimeEver==true and currentPage!="installer" and currentPage!="installerComplete" then
    			bootPhone() --turn phone ON (we only need to initialize vars one time here)
    			firstTimeEver=false
    		end	
    	end
    	
	    if currentPage=="menu" then -- Draw menu 
	    	menuGUI:draw_all()
	      if firstTimeMenu==true then
	   			bootMenu() --initialize menu
	   			firstTimeMenu=false
	    	end
	    	
	   elseif currentPage=="colors" then drawFunctions.colors()
   		elseif currentPage=="specialChar" then drawFunctions.specialChars() 
   		elseif currentPage=="midi2pico" then drawMidi()
   		elseif currentPage=="calculator" then drawCalc()
   		elseif currentPage=="chat" then drawChat() 
   		
   		elseif currentPage=="settings" then 
	    	settingsGUI:draw_all()
	      if firstTimeSettings==true then
	   			bootSettings()--turn that on
	   			firstTimeSettings=false
	    	end
	    
	   elseif currentPage=="market" then
	   		marketGUI:draw_all()
	   		if firstTimeMarket==true then
	   			bootMarket()
	   			firstTimeMarket=false
	   		end
	   		
	   	elseif currentPage=="marketTool" then
	   		marketToolGUI:draw_all()
	   	 	if firstTimeToolMarket == true then
	   	 		bootMarketTool()
	   	 		firstTimeToolMarket=false
	   	 	end
	   	end
	   	
   		
   		gui:draw_all()
	else
			drawFunctions.sleep(phoneDisplay.y2)
	end
 
	if  currentPage=="installer" then drawInstall()
  	elseif currentPage=="installComplete" then installComplete()  end	
end