--[[pod_format="raw",created="2024-04-18 00:41:05",modified="2024-06-13 23:29:36",revision=9264]]
function checkSlashInPath(str)
	--if first caratter is not / then add it at the beginning
    if string.sub(str, 1, 1) != "/" then str = "/" .. str end
    
    return str
end

function showUsageCPU()
	print("CPU:"..string.format("%.2f",stat(1)*100).."%",6,190,phoneColor==0 and 7 or 0)
end   	

function showMouseXY(x,y,col)
	print(mx..","..my,x,y,col)
end

function clickedZone(el,x1,y1,x2,y2) 
	if el.clicked and mx>x1 and mx<x2 and my>y1 and my<y2
	then return true end
end

--https://www.lexaloffle.com/bbs/cart_info.php?cid=phone
function webGetTitle(url)
	local html = fetch(url)
	local title = html:match("<title>(.-)</title>")
	return title
end

function getLastPhoneVersion()
	local html = fetch(bbsURL)
	local version = html:match("PicoPhone (.-)</title>")
	return version
end