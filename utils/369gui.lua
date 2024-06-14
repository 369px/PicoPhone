--[[pod_format="raw",created="2024-05-03 23:30:30",modified="2024-06-13 23:29:36",revision=5646]]
g369 = {}

--Utils!
function g369.fillBG(el,col) --fills a background with a rectangle, input: element & color
	rectfill(0,0,el.width,el.height,col)
end

function g369.BGbord(el,col)--makes a border for the element
	rect(0,0,el.width-1,el.height-1,col)
end

function g369.topLine(el,col) --makes a line at the top of an element
	line(0,0,el.width-1,0,col)
end

function g369.bottomLine(el,col) --makes a line at the bottom of an element
	line(2,el.height-1,el.width-3,el.height-1,col)
end

--"Vector" Icons!
function g369.emptySlot(x,y,slotID,col) --24x24 icon displaying an empty slot
	rectfill(x,y,x+24,y+24,7)
	print("SLOT\n #"..slotID,x+3,y+3,col)
end