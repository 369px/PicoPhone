--[[pod_format="raw",created="2024-04-16 01:42:16",modified="2024-06-06 16:38:17",revision=186]]
local function run_program_in_new_process(prog_name, argv)

	local proc_id = create_process(
		prog_name, 
		{
			print_to_proc_id = pid(),  -- tell new process where to print to               
			argv = argv,
			path = pwd(), -- used by commandline programs -- cd(env().path)
			window_attribs = {show_in_workspace = true}
		}
	)

end

local function try_multiple_extensions(prog_name)
--	printh(" - - - - trying multiple entensions for: "..tostr(prog_name))

	if (type(prog_name) ~= "string") return nil

	local res =
		--(fstat(prog_name) and prog_name and get_file_extension(prog_name)) or  --  needs extension because don't want regular folder to match
		(fstat(prog_name) and prog_name:ext() and prog_name) or  --  needs extension because don't want regular folder to match
		(fstat(prog_name..".lua") and prog_name..".lua") or
		(fstat(prog_name..".p64") and prog_name..".p64") or -- only .p64 carts can be run without specifying extension (would be overkill; reduce ambiguity)
		nil
	--printh(" - - - - - - - - -")
	return res

end

local function resolve_program_path(prog_name)

	local prog_name_0 = prog_name

	-- /appdata/system/util/ can be used to extend built-in apps (same pattern as other collections)
	-- update: not true, other collections (wallpapers) are replaced rather than extended by /appdata

	return
		try_multiple_extensions("/system/util/"..prog_name) or
		try_multiple_extensions("/system/apps/"..prog_name) or
		try_multiple_extensions("/appdata/system/util/"..prog_name) or
		try_multiple_extensions(prog_name) -- 0.1.0c: moved last 

end

function run_terminal_command(cmd)

	local prog_name = resolve_program_path(split(cmd," ",false)[1])

--	printh("run_terminal_command program: "..tostr(prog_name))

	local argv = split(cmd," ",false)

	-- 0-based so that 1 is first argument!
	for i=1,#argv+1 do
		argv[i-1] = argv[i]
	end

	-----
	
	if (argv[0] == "cd") then

		local result = cd(argv[1])
		if (result) then add_line(result) end -- result is an error message

	elseif (cmd == "exit") then

		exit(0)
		
	elseif (cmd == "cls") then

		set_draw_target(back_page)
		cls()
		set_draw_target()
		scroll_y = last_total_text_h

	elseif (cmd == "reset") then

		reset()

	elseif (cmd == "resume") then

		running_cproj = true
		send_message(3, {event="set_haltable_proc_id", haltable_proc_id = pid()})

	elseif (prog_name) then

		run_program_in_new_process(prog_name, argv) -- could do filename expansion etc. for arguments

	else
		-- last: try lua

		local f, err = load(cmd, nil, "t", _ENV)

		if (f) then
		
			-- run loaded lua as a coroutine
			local cor = cocreate(f)

			repeat
				set_draw_target(back_page)
				_is_terminal_command = true -- temporary hack so that print() goes to terminal. e.g. pset(100,100,8)?pget(100,100)

				res,err = coresume(cor)
				
				set_draw_target() 
				_is_terminal_command = false
				
				if (err) then
					add_line("\feRUNTIME ERROR")
					add_line(err)
					
				end
			until (costatus ~= "running")
		else

			-- try to differenciate between syntax error /command not found

			local near_msg = "syntax error near"
			if (near_msg == sub(err, 5, 5 + #near_msg - 1)) then
				-- caused by e.g.: "foo" or "foo -a" or "foo a.png" when foo doesn't resolve to a program
				add_line "command not found"
			else
				add_line(err)
			end

		end

	end

end