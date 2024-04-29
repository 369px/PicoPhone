--[[pod_format="raw",created="2024-03-29 09:34:20",modified="2024-03-29 21:02:50",revision=95]]
function get_pid(path)
    -- accumulator
    local result = {}    

    -- loop through processes.pod
    local data = fetch("/ram/system/processes.pod")
    foreach(data, function(p)
        if p.pwd == path then
            add(result,p.id)
        end
    end)
    
    -- result
    return result
end

function puse()
	local pid = get_pid(pwd())
	local p = fetch"/ram/system/processes.pod"
	
	for i=1,#p do
		--print(string.format("%4d %-20s %0.3f", p[i].id, p[i].name, p[i].cpu))
		if p[i].id == pid then
			return p[i].cpu
		end
	end
	return 0
end