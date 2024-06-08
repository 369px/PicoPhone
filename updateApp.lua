--[[pod_format="raw",created="2024-04-11 20:07:11",modified="2024-06-08 22:43:07",revision=10592]]
updatePhone = {}

--check if update is needed
function updatePhone.checkUpdate()	
	
	if updatePhone.pathExists("/appdata/369/picophone.p64.png") then --if existing user

		--if settings file exists (to see app version) (will change this soon)
		if updatePhone.pathExists("/appdata/369/picophone.p64.png/utils/settings.txt") then 
		
			local userVersion = fetch("/appdata/369/picophone.p64.png/utils/settings.txt")	
			if userVersion != appVersion then return true
			else return false end --if not same version, update
		
		else return true end --if no settings file, update (new versions have it)
	
	else --if app doesn't exist in right path, start installation
		
		updatePhone.removeOldVersions() --if they exist delete them
		
		if (not updatePhone.pathExists("/appdata/369/")) then --if 369 folder don't exist
			mkdir("/appdata/369/") --create it
		end
	
		return true --app doesn't exist, start installation
	end
end

function updatePhone.pathExists(cartPath)
	return fstat(fullpath(cartPath))
end

function updatePhone.removeOldVersions()
	rm("/appdata/local/tools/picophone.p64.png") --remove 0.1 version if present
	rm("/appdata/local/picophone.p64.png")
	rm("/appdata/picophone.p64.png") --remove older 0.2 if present
end

--Installer page draw functions

updatePhone.tacoAnim=0
updatePhone.tTaco=0

function updatePhone.tacoEatingPhone(x,y)
	if 	updatePhone.tTaco==10 then
		updatePhone.tacoAnim=rnd(4) 
		updatePhone.tTaco=0
	end
	updatePhone.tTaco+=1

	spr(40+updatePhone.tacoAnim,x,y)
end

function updatePhone.drawInstall()
	print("Taco is installing\nyour Phone...\n"..
			"Have you got space\nin your tooltray?",14,63,1)
	--rectfill(tacoBtn.x1,tacoBtn.y1,tacoBtn.x2,tacoBtn.y2,6) --taco background
	updatePhone.tacoEatingPhone(47,20)	

	--showUpdateMessage = folder369exists..picoExists..setExists..sameSettings

	--print(showUpdateMessage,14,45,7)
	--print("Where do you want\nto install Picophone?\n(in desktop2)",15,115,10)

	rectfill(11,115,43,150,18)
	print("Left",18,129,7)
	rectfill(47,115,79,150,1)
	print("Center",49,129,7)
	rectfill(83,115,115,150,18)
	print("Right",88,129,7)
	rectfill(11,154,115,170,18)
	print("Move it on desktop!",17,159,29)
end

function installComplete()
	store("/appdata/369/picophone.p64.png/utils/settings.txt",appVersion)
	if installedTooltray==true then
		print("Installation complete!\nReboot Picotron to see\n"..
				"PicoPhone in desktop2!\n\nHit 'R' to reboot now",
				10,63,1)
	else 
		print("PicoPhone is on the \ndesktop! Move it \nwherever you want!",14,80,1)
	end
end