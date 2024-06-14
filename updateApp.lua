--[[pod_format="raw",created="2024-04-11 20:07:11",modified="2024-06-14 16:42:03",revision=13039]]
updatePhone = {}

function updatePhone.boot()
	if updatePhone.checkUpdate() then currentPage="installer" --if running picophone is different than installed picophone, install it
	elseif not updatePhone.isLatestVersion() then 
--		phone_userdata.bbsCurrentVersion += 1
		currentPage="update" --if there's an update online, ask user
	end
end

--check if update is needed
function updatePhone.checkUpdate()	
	
	if updatePhone.pathExists("/appdata/369/picophone.p64.png") then --if existing user

		--if settings file exists (to see app version) (will change this soon)
--		if updatePhone.pathExists("/appdata/369/picophone.p64.png/utils/settings.txt") then 
			
		local userVersion = fetch("/appdata/369/phone_userdata.pod")	--save userdata in local var
			
		if not fstat("/appdata/369/phone_userdata.pod") --if no userdata file
		or not userVersion.miniOSversion --if obsolete version
		or userVersion.miniOSversion != phone_userdata.miniOSversion 
		then --or different version
				return true --update
			--else return false 
			end 
		
--		else updateApp()  return true end --if no settings file, update (new versions have it)
	
	else --if app doesn't exist in right path, start installation

		if (not updatePhone.pathExists("/appdata/369/")) then --if 369 folder don't exist
			mkdir("/appdata/369/") --create it
		end
		
	--	updateApp()
		return true --app doesn't exist, install widget
	end
	
--	if updatePhone.checkUpdateOnline() then return true end
end


function updatePhone.loadUpdate() --check online if there's a new version in the bbs
		updatePhone.backupUserCart()
		run_terminal_command("load #phone")
		
		for i=1,39 do 
			flip()
			notify("\130:  Loading new Picophone update "..i.."/39")
		end 
		
		phone_userdata.miniOSversion = fetch_metadata("/ram/bbs_cart.p64.png").version
	
		notify("\130:  Update loaded! Installing widget...")
		
		currentPage="installer"
end

updatePhone.lastVersion=""
function updatePhone.isLatestVersion()
	local newV = fetch("https://www.lexaloffle.com/bbs/cart_info.php?cid=phone-"..phone_userdata.bbsCurrentVersion+1)
	local strToFind = "missing cart_id"
	
	updatePhone.lastVersion=getLastPhoneVersion()
	
	--if next version's page (fecthed in newV) contains strTofind 
	--it means there is no new version! 
	if not newV then return true --if no page is fecthed... return true cause we don't need to update
	else 
		return string.find(newV, strToFind) ~= nil 
	end
end

function updatePhone.backupUserCart()
	run_terminal_command("cp /ram/cart /ram/compost/user_cart.p64")
end

function updatePhone.restoreUserCart()
	run_terminal_command("cp /ram/compost/user_cart.p64 /ram/cart")
	run_terminal_command("load /ram/compost/user_cart.p64")
end

function updatePhone.pathExists(cartPath)
	return fstat(fullpath(cartPath))
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

	if installedTooltray==true then
		print("Installation complete!\nReboot Picotron to see\n"..
				"PicoPhone in desktop2!\n\nHit 'R' to reboot now",
				10,63,1)
	else 
		currentPage="menu"
		print("PicoPhone is on the \ndesktop! Move it \nwherever you want!",14,80,1)
	end
end