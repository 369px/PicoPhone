--[[pod_format="raw",created="2024-04-08 13:32:14",modified="2024-04-10 17:53:48",revision=330]]
function pp_tbl(tbl,brkline)
 local str = "{ "
 if (brkline) str=str.."\n"
 for k,v in pairs(tbl) do
  if (type(v)=="table") v=pp_tbl(v,false)
  str=str..tostring(k).." = "..tostring(v)..", "
  if (brkline) str=str.."\n"
 end
 return str.."}"
end

function printy(...)
	res=""
	for arg in all({...}) do 
		res..=tostr(arg)
		for i=1,5-#tostring(arg) do res..=" " end
	end
	print(res)
end

function hex(v) 
  local s,l,r=tostr(v,true),3,11
  while(ord(s,l)==48) l+=1
  while(ord(s,r)==48) r-=1
  res = sub(s,l<r and l or 6,r>7 and r or 6)
  return #res>0 and res or "00"
end

function printySections(sections)
	for i=1,#sections do
		local t1 = sections[i].startTrackerPosition
		local t2 = sections[i].endTrackerPosition
		for j=1,8 do
			if (#sections[i][j]>0) printy("section "..i..", channel "..j," "..t1.."-"..t2,":\n",pp_tbl(sections[i][j],true))
		end
	end
end

--[[
hexmap = ""
for i=0,327 do hexmap..=hex(@(0x050000 + i)).." " end

--local res = LuaMidi.get_MIDI_tracks("/desktop/projects/1stargazing.mid")
--print(#res[1].events)
--evmap=""
--for i=1,#res[2].events do evmap..=pp_tbl(res[1].events[i]).."\n" end
--store("events_midi.txt",evmap)
--store("/desktop/projects/full_midi.txt",pp_tbl(res[1].events,true))

--[[
local res2 = LuaMidi.get_MIDI_tracks("/desktop/projects/midis/test1.mid")
print(#res2)
evmap=""
for i=1,#res2[1].events do evmap..=pp_tbl(res2[1].events[i]).."\n" end
print(evmap)
]]--

--printy("sfx 0 data:\n", meta[0]:get())
--printy("sfx 3 data:\n", meta[3]:get())
--printy("sfx 32 data:\n", meta[32]:get())
--local sfx0 = userdata("u8",328) for i=0,327 do sfx0[i] = peek(0x50000+i) end
--printy("sfx 0 memory:\n", sfx0:get())
--printy("sfx 1:\n", meta[1]:get())

--printy(tracks:get())
--?hexmap
--[[
print(pp_tbl(tracks[1], true))
print(pp_tbl(tracks[2], true))
print(pp_tbl(tracks[3], true))
print(pp_tbl(tracks[4], true))]]--