--[[pod_format="raw",created="2024-04-09 13:56:30",modified="2024-05-01 19:27:15",revision=12324]]
lastMouseBtn=0
function checkClick()	
	mx,my,mbtn = mouse()
	if mbtn>0 then cursor="pointer" end	

	if lastMouseBtn==1 and lastMouseBtn != mbtn then --if click then
		if currentPage=="sleep"  then currentPage=closedPage updateTacoMsg()
		else --if click when sleeping go back to last page, else check page
			if currentPage=="specialChar" then specialCharEvents() end
			if currentPage=="installer" then installerEvents() end
		--[[
			if currentPage=="menu" then menuPage() --if on menupage check where
			elseif currentPage=="specialChar" then specialCharEvents() --if on special char check which one
			elseif currentPage=="installer" then installerEvents()
			end
			
			if mx<38 and my<19 and currentPage!="installer" and currentPage!="installComplete" and currentPage!="home"
			then currentPage=lastPage updateTacoMsg() end --if clikc go back btn
			
			if mx>statusBar[3].x and my>statusBar[3].y and mx<statusBar[3].x2 and my<statusBar[3].y2 
			then lastPage=currentPage currentPage="sleep" end --click zzZ btn
			--]]
		end
		
		--btn home
		if  my>182 and mx>52 and mx<73 and currentPage!="installer" and currentPage!="installComplete" then 
			lastPage=currentPage
			currentPage="menu"
			updateTacoMsg()
		end
	
	end

	lastMouseBtn=mbtn
end

function installerEvents()
	if my>116 and my<151 then
		if mx>11 and mx<43 then --left btn
			installWidget("left")
		elseif mx>48 and mx<79 then--center btn
			installWidget("center")
		elseif mx>83 and mx<115 then--right btn
			installWidget("right")
		end
	elseif my>153 and my<171 then
		installWidget("desktop")
	end
end

installedTooltray=false
function installWidget(position)
	
	cp(pwd(), "/appdata/369/picophone.p64.png")

	if not fstat(fullpath("/appdata/system/startup.lua")) then
		store("/appdata/system/startup.lua","",{})
	end

	local file2string = fetch("/appdata/system/startup.lua")
--	newStr, replaced = string.gsub(ftostring, "create_process(\34/appdata/369/picophoneee.p64.png\34, {window_attribs = {workspace = \34tooltray\34, x=175, y=25, width=127, height=205}})", "\n")
--	newStr = newStr.."\ncreate_process(\34/appdata/369/picophone.p64.png\34, {window_attribs = {workspace = \34tooltray\34, x=175, y=25, width=127, height=205}})"
	
	newString = deleteOldApp(file2string)
		
	if position=="left" then
		installTxt="\n create_process(\34/appdata/369/picophone.p64.png\34, {window_attribs = {workspace = \34tooltray\34, x=5, y=25, width=127, height=205}})"
		installedTooltray=true	
		
	elseif position=="center" then
		installTxt="\n create_process(\34/appdata/369/picophone.p64.png\34, {window_attribs = {workspace = \34tooltray\34, x=180, y=25, width=127, height=205}})"
		installedTooltray=true
		
	elseif	position=="right" then
		installTxt="\n create_process(\34/appdata/369/picophone.p64.png\34, {window_attribs = {workspace = \34tooltray\34, x=350, y=25, width=127, height=205}})"	
		installedTooltray=true
	
	elseif position=="desktop" then
		installTxt="" 
		cp(pwd(), "/desktop/picophone.p64.png")
		installedTooltray=false
	end

		newString = newString .. installTxt	
		store("/appdata/system/startup.lua",newString)
	
	currentPage="installComplete"
end

function deleteOldApp(txt)
--remove strings of apps in different positions (remove all, you're going to add the ritght back in later	
	local strNew = string.gsub(txt,"create_process%(\34/appdata/369/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=5, y=25, width=127, height=205}}%)", "")
	strNew = string.gsub(strNew,"create_process%(\34/appdata/369/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=180, y=25, width=127, height=205}}%)", "")
	strNew = string.gsub(strNew,"create_process%(\34/appdata/369/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=350, y=25, width=127, height=205}}%)", "")
--remove strings of older version apps
	strNew = string.gsub(strNew,"create_process%(\34/appdata/local/tools/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=350, y=25, width=127, height=205}}%)", "")
	strNew = string.gsub(strNew,"create_process%(\34/appdata/local/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=350, y=25, width=127, height=205}}%)", "")
	strNew = string.gsub(strNew,"create_process%(\34/appdata/picophone%.p64%.png\34, {window_attribs = {workspace = \34tooltray\34, x=350, y=25, width=127, height=205}}%)", "")
	
	return strNew	
end

function updateTacoMsg()
	tacoEye={x=95,y=10}
	tacoEye.x+=flr(rnd(1.99))
	tacoEye.y-=flr(rnd(1.99))
	showedMessage=tacoTalk[flr(rnd(#tacoTalk))+1]
end

function menuPage()
--	if mx>tacoBtn.x1 and mx<tacoBtn.x2 and my>tacoBtn.y1 and my<tacoBtn.y2
--	then updateTacoMsg() end

	for i=1,#menu do --check which mini app has been clicked
		if mx>menu[i].x and mx<menu[i].x+32 and my>menu[i].y and my<menu[i].y+32
		then openMiniApp(i) lastPage="menu" end
	end
	
--	if mx>phoneDisplay.x1 and mx<phoneDisplay.x2 and my>155 and my<177
--	then currentPage="Market" lastPage="menu" end
end

function animateMarket()

end

function openMiniApp(appID)
	if appID==1 then currentPage="colors"
	elseif appID==2 then currentPage="specialChar"
	elseif appID==3 then currentPage="Midi2Pico"
	elseif appID==4 then currentPage="calculator"
	elseif appID==6 then currentPage="settings" end
end
	--	run_terminal_command("load #milkyway")
	
function specialCharEvents()
	for i=1,#getCharacter do
		local x = ((i-1)%8)*charGridSIZE+7
		local y = ((i-1)//8)*charGridSIZE+65
    	    	
    	if  mx>x and my>y and mx<x+charGridSIZE and my<y+charGridSIZE  then 
    		charSelect.id  = getCharacter[i].code 
    	   charSelect.txt = getCharacter[i].txt
    	   set_clipboard(charSelect.id)	
    	   charCopied=true
    	   rectfill(x,y,x+12,y+14,0)
    	end
	end
end