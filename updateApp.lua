--[[pod_format="raw",created="2024-04-11 20:07:11",modified="2024-05-01 23:51:09",revision=8626]]
function appToUpdate()	

	if fstat(fullpath("/appdata/369/picophone.p64.png")) then --if app already exists in 369 folder

		picoExists="\nPhone cart exists!"

		if fstat(fullpath("/appdata/369/picophone.p64.png/utils/settings.txt")) then --if settings file exists (to see app version)
		
			setExists="\nSettings.txt exists!"
		
			local userVersion = fetch("/appdata/369/picophone.p64.png/utils/settings.txt")--put in string
			
			if userVersion != appVersion 
			then sameSettings="\nApp version is not\nthe same!"
				return true
			else sameSettings="\nApp version is same!\nDon't need to install"
			--	return true
			end --if not same version, update
		
		else
		
		return true 
		end --if no settings file, update
	
	else
		
		removeOldVersions() --if they exist, else picotron doesn't care
		
		if (not fstat(fullpath("/appdata/369/"))) then --if 369 folder don't exist
			folder369exists="\n369 folder doesn't\nexist, created!"
			mkdir("/appdata/369/") --create 369 folder
		end
		
		return true --app doesn't exist, return true
	end
end

function removeOldVersions()
	rm("/appdata/local/tools/picophone.p64.png") --remove 0.1 version if present
	rm("/appdata/local/picophone.p64.png")
	rm("/appdata/picophone.p64.png") --remove older 0.2 if present
end