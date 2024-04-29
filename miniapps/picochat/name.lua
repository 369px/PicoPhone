--[[pod_format="raw",created="2024-03-26 05:31:52",modified="2024-03-29 07:26:34",revision=487]]
window { width = 120, height = 60, title = "Change Username" }
pw = env().pw
name = env().data

gui = create_gui()
txtbar = gui:attach_text_editor({
	x = 10, 
	y = 20, 
	width = 100,
	height = 12,
	max_lines = 1,
	key_callback = { enter = (function() end) }
})
txtbar:set_keyboard_focus(true)

txtbar:set_text(name)

done = gui:attach_button({
	x = 44,
	y = 40,
	label = "Done",
	click = (function()
		send_message(pw, {event="name", data=txtbar:get_text()[1]})
		exit()
	end)
})

function _update()
	gui:update_all()
end

function _draw()
	cls(5)
	gui:draw_all()
end