--[[pod_format="raw",created="2024-04-08 13:29:39",modified="2024-04-10 17:53:48",revision=284]]
function qsort(tbl, cmp, i, j)
 local t = tbl
 i = i or 1
 j = j or #t
 if i < j then
  local p = i
  for k = i, j - 1 do
   if cmp(t[k], t[j]) then
    t[p], t[k] = t[k], t[p]
    p = p + 1
   end
  end
  t[p], t[j] = t[j], t[p]
  t=qsort(t, cmp, i, p - 1)
  t=qsort(t, cmp, p + 1, j)  
 end
 return t
end

function tableFilter(tbl, filter)
	resTbl = {}
	for item in all(tbl) do if (filter(item)) add(resTbl, item) end
	return resTbl
end

function round(n) return ((n-flr(n))>0.5) and ceil(n) or flr(n) end

function bpmToSpd(bpm,depth) return 7229.5 \ (bpm*depth) end

function insideSquare(px,py,cx1,cy1,cx2,cy2)
	return (cx1 < px and px < cx2 and cy1 < py and py < cy2)
end