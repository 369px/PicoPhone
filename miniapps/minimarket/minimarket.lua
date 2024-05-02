--[[pod_format="raw",created="2024-04-18 17:11:45",modified="2024-05-01 23:51:41",revision=4941]]
firstTimeMarket=true
marketPage="tools"
marketCurrentCartID=1
marketGUI = create_gui()
function bootMarket()
	
	local title = marketGUI:attach{x=7,y=12,width=113,height=37,
			draw = function(self)
				line(0,self.height-1,129,self.height-1,28)
				print("\22                   \23",4,20,17)
				if marketPage=="tools" then print("\^w\^t".."Tools",32,15,7) end
			end}
	
	local scrollView = marketGUI:attach{x = 7, y = 49, width = 113, height = 129,
			draw=function(self) end }

	local scrollable = scrollView:attach{x=0,y=0,width=113,height=450}
	
	for i=1,#bbsCarts.tools do
		scrollable:attach{x=0,y=(i-1)*45,width=113,height=45,clicked=false,
			draw = function(self)
				if self.clicked==false then
					rectfill(0,0,self.width,self.height,7)
					print(bbsCarts.tools[i].label.."\n"..bbsCarts.tools[i].description,
					3,7,32)			
					print("\23",95,33,17)
					line(0,self.height-1,self.width,self.height-1,28)
				else
					rectfill(0,0,self.width,self.height,19)
					print(bbsCarts.tools[i].label.."\n"..bbsCarts.tools[i].description,
					3,7,7)			
					print("\23",95,33,17)
					line(0,self.height-1,self.width,self.height-1,28)
				end
			end,
			tap = function(self)
				lastPage=currentPage currentPage="marketTool" 
				marketCurrentCartID = i
			end,
			click=function(self) self.clicked=true end,
			release=function(self) self.clicked=false end
			
		}
	end

	scrollView:attach_scrollbars{autohide=true}

end

firstTimeToolMarket=true
marketToolGUI = create_gui()
function bootMarketTool()
		local title = marketToolGUI:attach{x=7,y=12,width=113,height=37,
			draw = function(self)
				line(0,self.height-1,129,self.height-1,28)
				--print("\22                   \23",10,30,19)
				print("\^w\^t"..bbsCarts.tools[marketCurrentCartID].code,5,15,0)
			end}
			
		local description = marketToolGUI:attach{x=7,y=49,width=113,height=89,
			draw = function(self)
				print(bbsCarts.tools[marketCurrentCartID].longDescr,3,3,0)
			end}
			
		local load = marketToolGUI:attach{x=10,y=142,width=107,height=15,
			draw = function(self)
				rectfill(0,0,self.width,self.height,17)
				print("load "..bbsCarts.tools[marketCurrentCartID].code.." (ctrl-r)",5,4,19)
			end,
			tap = function(self)
				run_terminal_command("load "..bbsCarts.tools[marketCurrentCartID].code)
				create_process(fullpath("/ram/bbs_cart.p64.png"))
				--click_on_file(fullpath("/ram/bbs_cart.p64.png"))
			end
			}
			
		--click_on_file(filename, action, argv)
			
		local install = marketToolGUI:attach{x=10,y=160,width=107,height=15,
			draw = function(self)
				rectfill(0,0,self.width,self.height,19)
				print("INSTALL NOW",5,4,7)
			end,
			tap = function(self)
				installFolder()
				local toolPath = "/appdata/tools/"..
									string.sub(bbsCarts.tools[marketCurrentCartID].code, 2)..
									".p64.png"
				
				run_terminal_command("load "..bbsCarts.tools[marketCurrentCartID].code)
				cp("/ram/cart", toolPath)
			end
}
				
end

function installFolder()
	if (not fstat(fullpath("/appdata/tools/"))) then --if tools folder don't exist
			mkdir("/appdata/tools/") --create tools folder
	end
end