--[[pod_format="raw",created="2024-05-04 23:15:08",modified="2024-06-11 03:39:04",revision=2773]]
--I know, you can just gui:draw_all(), and I didn't knew it when I started learning the PT gui
--but believe it or not... all these crazy if statements help with the cpu usage! you're welcome to make it better!

function drawOS()
	if currentPage!="sleep" then --If phone is not in low usage mode, do stuff 
	
		
	--	if powerState=="OFF" then --if phone just woke up and is not installer page
    	--	powerState="ON" 
    		if firstTimeEver==true and currentPage!="installer" and currentPage!="installerComplete" then
    			bootPhone() --turn phone ON (we only need to initialize vars one time here)
    			firstTimeEver=false
    		end	
   -- 	end
    
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
   		
   		elseif currentPage=="cPanel" then 
	    	cPanelGUI:draw_all()
	      if cPanelGUI.firstTime==true then
	   			bootCPanel()--turn that on
	   			cPanelGUI.firstTime=false
	    	end
   		
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
 
	if  currentPage=="installer" then updatePhone.drawInstall()
  	elseif currentPage=="installComplete" then installComplete()  end	
end