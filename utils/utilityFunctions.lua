--[[pod_format="raw",created="2024-04-18 00:41:05",modified="2024-06-06 16:38:17",revision=9081]]
function checkSlashInPath(str)
	--if first caratter is not / then add it at the beginning
    if string.sub(str, 1, 1) != "/" then str = "/" .. str end
    
    return str
end