--[[pod_format="raw",created="2024-04-09 13:47:44",modified="2024-06-08 22:43:07",revision=19193]]
drawFunctions = {}

function drawFunctions.splashScreen()
	drawFunctions.phone()
	rectfill(7,7,phoneDisplay.x2, phoneDisplay.y2,32) --display for bootscreen
	drawFunctions.introPicophone()	
end

function drawFunctions.introPicophone()
	for i=-1,1 do
		for j=-1,1 do
  			print("\014\^w\^t".."PICOPHONE",28+i,93+j,28)
  		end
  	end
  	print("\014\^w\^t".."PICOPHONE",28,93,19)
end

function drawFunctions.sleep(displayeHeight)
	local centerDisplay = displayeHeight/2
	print("Low CPU mode\nTap to unlock",30,centerDisplay,5)
end

function drawFunctions.market()
	rectfill(7,20,119,45,17)
	line(7,45,119,45,28)
	print("\22                   \23",10,30,19)

	print("\^w\^t".."Tools",20,26,7)

		for i=1,#bbsCarts.tools do
		print(bbsCarts.tools[i].label.."\n"..bbsCarts.tools[i].description,
				10,55+(i-1)*40,7)
		end
end

function drawFunctions.tacoTalks()
	print(showedMessage,7,7,0)--msg Taco
	rectfill(92,2,110,22,6) --taco background
	spr(tacoFace,94,4) --taco
	
	drawFunctions.tacoEyes()
end

function drawFunctions.marketSlide(self,yAnim)

 	rectfill(0,yAnim,self.width,3,28)
 	rectfill(0,yAnim+3,self.width,13,17)
 	rectfill(0,yAnim+13,self.width,self.height,19)
--[[
	for i=-1,1 do
		for j=-1,1 do
  			print("\^w\^t".."^MARKET^",16+i,4+j,28)
  		end
  	end--]]
  	print("\^w\^t".."^MARKET^",16,6,7)
end

function drawFunctions.tacoEyes()	
	rectfill(tacoEye.x,tacoEye.y,tacoEye.x+1,tacoEye.y+1,32)
	rectfill(tacoEye.x+7,tacoEye.y,tacoEye.x+7+1,tacoEye.y+1,32)
end

function drawFunctions.mainMenu() 
	
	--draw btns
	for i=1,#menu do
	spr(menu[i].sprite,menu[i].x,menu[i].y)
	end
	--	rect(menu[7].x1+1,menu[7].y1+1,menu[7].x2+1,menu[7].y2+1,17)	
		--rectfill(menu[7].x1,menu[7].y1,menu[7].x2,menu[7].y2,menu[7].col)	
 	-- printLabels()
 	

 	rectfill(azureRect.x1,azureRect.y1,azureRect.x2,azureRect.y2,28)
 	rectfill(greenAquaRect.x1,greenAquaRect.y1,greenAquaRect.x2,greenAquaRect.y2,17)
 	rectfill(darkGreenRect.x1,darkGreenRect.y1,darkGreenRect.x2,darkGreenRect.y2,19)
 	
	for i=-1,1 do
		for j=-1,1 do
  			print("\^w\^t".."^MARKET^",22+i,159+j,28)
  		end
  	end
  	print("\^w\^t".."^MARKET^",22,159,19)
  
end

function printLabels()
	local startTextX=21
	local startTextY=51
	-- btn labels
	print(menu[1].label,startTextX,startTextY,menu[1].col==19 and 7 or 0)
	print(menu[2].label,startTextX+51,startTextY,menu[2].col==19 and 7 or 0)
	print(menu[3].label,startTextX-6,startTextY+25,menu[3].col==19 and 7 or 0)
   print(menu[4].label,startTextX+47,startTextY+25,menu[4].col==19 and 7 or 0)
   print(menu[5].label,startTextX-6,startTextY+50,menu[5].col==19 and 7 or 0)
   
   print("Market",startTextX+27,menu[7].y1+7,menu[7].col==19 and 7 or 0)
	print("\148",startTextX+38,menu[7].y1+14,menu[7].col==19 and 7 or 0) 
end

function drawFunctions.phone()
	 circfill(7,7,7,phoneColor) circ(7,7,7,phoneColor==0 and 6 or 0) -- curve top left with border
	 circfill(119,7,7,phoneColor) circ(119,7,7,phoneColor==0 and 6 or 0) --curve top right
	 circfill(119,196,7,phoneColor) circ(119,196,7,phoneColor==0 and 6 or 0) --curve bottom right
	 circfill(7,196,7,phoneColor) circ(7,196,7,phoneColor==0 and 6 or 0) --curve bottom left
 	 rectfill(7,0,119,7,phoneColor) line(7,0,119,0,phoneColor==0 and 6 or 0) --top
 	 rectfill(0,7,7,196,phoneColor) line(0,7,0,196,phoneColor==0 and 6 or 0) --left
 	 rectfill(119,7,126,196,phoneColor) line(126,7,126,196,phoneColor==0 and 6 or 0) --right
 	 rectfill(7,178,119,204,phoneColor) line(7,204,119,204,phoneColor==0 and 6 or 0) --bottom
 	 
 	if phoneColor!=0 then 	rect(6,6,120,178,6) end

 	 circ(62,191,9,phoneColor==0 and 7 or 0) --home button
end

function drawFunctions.display(self) --display
--[[	if currentPage=="menu" then
		spr(63,7,7)
	else--]]
	 	rectfill(7,7,phoneDisplay.x2, phoneDisplay.y2,drawFunctions.getBGColor())
--	end
end

function drawFunctions.getBGColor()
	if currentPage=="sleep" or currentPage=="chat" then return 32
--	elseif currentPage=="menu" then return 7
	elseif currentPage=="calculator" then return 17
	elseif currentPage=="market" then return 19
	elseif currentPage=="installer" or currentPage=="installComplete" then return 29
	else return 7 --main background color that picochat text gets
	end
end

function drawFunctions.statusBar(self)
	rectfill(0,0,self.width - 1, self.height - 1,19)
	line(0,self.height-1,self.width - 1, self.height - 1,17)
end

function drawFunctions.backBtn(self,col)
	rectfill(0,0,self.width - 1, self.height - 1,col)
	if drawFunctions.toDrawBackBtn()	 then print("\014\22 back",2,3,7) end
	
	if currentPage=="menu"then 
		--print("\014\141fm\141",3,3,7) 
		spr(0,3,2) 
	end
end

function drawFunctions.toDrawBackBtn()	
	if  currentPage!="menu" and currentPage!="installer" and currentPage!="installComplete" then
		return true
	end
end

function drawFunctions.sleepBtn(self,col)
	rectfill(0,0,self.width -1, self.height-1,col)
	line(0,self.height-1,self.width-1,self.height-1,8)
	print("zzZ",3,2,7)
end


function drawSettings()
	print("This page is currently\nin development...\ncheck later",10,70,6)
	
	print("miniOS:",10,25,0)
	print(appVersion,90,25,19)
	line(7,37,119,37,17)
--	menu:attach_scrollbars()
end

charSelect = { txt="\146", id=146}
local charCopied=false
charGridSIZE=14--size of each color box
local charsTable = {
    ["\148"] = 148, ["\131"] = 131, ["\139"] = 139, ["\145"] = 145, ["\142"] = 142,
    ["\151"] = 151, ["\34"] = 34, ["\92"] = 92, ["\132"] = 132, ["\129"] = 129,
    ["\128"] = 128, ["\16"] = 16, ["\17"] = 17, ["\18"] = 18, ["\22"] = 22,
    ["\23"] = 23, ["\138"] = 138, ["\140"] = 140, ["\137"] = 137, ["\130"] = 130,
    ["\133"] = 133, ["\146"] = 146, ["\135"] = 135, ["\141"] = 141, ["\134"] = 134,
    ["\147"] = 147, ["\136"] = 136, ["\143"] = 143, ["\152"] = 152, ["\153"] = 153,
    ["\150"] = 150, ["\149"] = 149, ["\40"] = 40, ["\41"] = 41, ["\91"] = 91,
    ["\93"] = 93, ["\123"] = 123, ["\125"] = 125, ["\124"] = 124, ["\33"] = 33,
    ["\127"] = 127, ["\29"] = 29, ["\31"] = 31, ["\46"] = 46, ["\43"] = 43,
    ["\45"] = 45, ["\42"] = 42, ["\47"] = 47, ["\94"] = 94, ["\95"] = 95,
    ["\37"] = 37, ["\35"] = 35, ["\36"] = 36, ["\32"] = 32, ["\27"] = 27,
    ["\44"] = 44, ["\144"] = 144, ["\39"] = 39, ["\96"] = 96, ["\38"] = 38
}

getCharacter={}
local iChar=1
for v,i in pairs(charsTable) do
	--local str= sub(charsTable[i],2)
	getCharacter[iChar] = { code = i, txt = v}
	iChar+=1
end


function drawFunctions.specialChars()
	rectfill(9,36,117,47,1)
	print("To draw a "..charSelect.txt.." just do:",11,25,0)
	if charSelect.id != nil then
		print("print(\34\92"..charSelect.id.."\34,x,y,col)",12,38,7)
		charCopied=true
	end
	print(charCopied==false and "press a char to copy:" or charSelect.txt.." copied to clipboard",11,52,22)	
	
    	rectfill(9,100,119,180,0)
    	
	--iChar=1
	for i=1, #getCharacter do
        local x = ((i-1)%8)*charGridSIZE+7
        local y = ((i-1)//8)*charGridSIZE+65
        rectfill(x,y,x+charGridSIZE,y+charGridSIZE,charSelect.txt==getCharacter[i].txt and 7 or 0)
        print(getCharacter[i].txt,x+3,y+4,charSelect.txt==getCharacter[i].txt and 0 or 7)
        --iChar+=1
    end
    
	print("\014by 369px",81,170,22)
end

--draw palette of colors with IDs (thanks to @fletchmakes on Discord)
local paletteGridSIZE=14--size of each color box
--now we declare the 2 palettes
local palette={0,20,4,31,15,8,24,2,21,5,22,6,7,23,14,30,1,16,17,12,28,29,13,18,19,3,27,11,26,10,9,25}
for i = 1, 31 do palette[i+32] = i + 31 end	
	
function drawFunctions.colors()
--draw first 32 colors
	for i=1,#palette do
        local x = ((i-1)%8)*paletteGridSIZE+7
        local y = ((i-1)//8)*paletteGridSIZE+36
        rectfill(x,y,x+paletteGridSIZE,y+paletteGridSIZE,palette[i])
        print(palette[i],x+3,y+3,7)
        if palette[i] == 7 then print(palette[i],x+3,y+3,0) end
    end
    
   print("COLOR IDs:",15,24,0)
   print("\014by fletchmakes",60,170,22)
end