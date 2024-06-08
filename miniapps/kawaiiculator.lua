--[[pod_format="raw",created="2024-03-19 18:34:47",modified="2024-05-03 20:46:36",revision=5204]]
function initCalc()
	display = ""
	instructions = {}
	number = ""
	decimal = false
	operator_behind = false
	turn_negative = false
	can_click = true
	face = 49
	face_timer = 0
	calc_timer = 0
	face_timer = 0
	mouth_timer = 0
	divided_by_zero = false
	result_given = false
	
local start_x = 28
local start_y = 78
local button_spacing_x = 23
local button_spacing_y = 21

calcButtons = {
    {label = "9", x = start_x, y = start_y + button_spacing_y * 0, draw_top = true},
    {label = "8", x = start_x + button_spacing_x, y = start_y + button_spacing_y * 0, draw_top = true},
    {label = "7", x = start_x + 2 * button_spacing_x, y = start_y + button_spacing_y * 0, draw_top = true},
    {label = "/", x = start_x + 3 * button_spacing_x, y = start_y + button_spacing_y * 0, draw_top = true},
    {label = "6", x = start_x, y = start_y + button_spacing_y * 1, draw_top = true},
    {label = "5", x = start_x + button_spacing_x, y = start_y + button_spacing_y * 1, draw_top = true},
    {label = "4", x = start_x + 2 * button_spacing_x, y = start_y + button_spacing_y * 1, draw_top = true},
    {label = "*", x = start_x + 3 * button_spacing_x, y = start_y + button_spacing_y * 1, draw_top = true},
    {label = "3", x = start_x, y = start_y + button_spacing_y * 2, draw_top = true},
    {label = "2", x = start_x + button_spacing_x, y = start_y + button_spacing_y * 2, draw_top = true},
    {label = "1", x = start_x + 2 * button_spacing_x, y = start_y + button_spacing_y * 2, draw_top = true},
    {label = "-", x = start_x + 3 * button_spacing_x, y = start_y + button_spacing_y * 2, draw_top = true},
    {label = "0", x = start_x, y = start_y + button_spacing_y * 3, draw_top = true},
    {label = ".", x = start_x + button_spacing_x, y = start_y + button_spacing_y * 3, draw_top = true},
    {label = "=", x = start_x + 2 * button_spacing_x, y = start_y + button_spacing_y * 3, draw_top = true},
    {label = "+", x = start_x + 3 * button_spacing_x, y = start_y + button_spacing_y * 3, draw_top = true},
    {label = "c", x = start_x, y = start_y + button_spacing_y * 4, draw_top = true},
}
end

function distance(x1, y1, x2, y2)
	return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function check_key()
	local mx, my, mb = mouse()
	local active_key = nil
	if can_click then
		if mb == 1 then
			can_click = false
			for b in all(calcButtons) do
				if distance(mx, my, b.x, b.y) < 10 then
					b.draw_top = false
					active_key = b.label
				end
			end
		end
	elseif mb == 0 then
		can_click = true
	end
	return active_key
end

initCalc()

function updateCalc()
    if calc_timer > 0 then
        face_timer += 1
        if face_timer >= 4 then
            face += 1
            if face > 52 then face = 51 end
            face_timer = 0
        end
        calculate()

        return
    end
    if result_given then
        if #instructions > 0 then
            result_given = false
        end
    else
        if mouth_timer > 0 then
            mouth_timer -= 1
        else
            face = 49
            mouth_timer = 0
        end
    end
    if tostr(number) == "8008" or tostr(number) == "80081" or tostr(number) == "800813"or tostr(number) == "8008135" then face = 53 end
    if divided_by_zero then 
        if #instructions == 0 then
            face = 53 
        else
            divided_by_zero = false
        end
    end
    for b in all(calcButtons) do
        b.draw_top = true
    end
    local active_key = check_key()
    if keyp(87) 
        or keyp(86)
        or keyp(85)
        or keyp(84)
        or active_key == "+" or active_key == "-" 
        or active_key == "*" or active_key == "/" then
            if (number == "" and #instructions == 0) or operator_behind then
                if keyp(86) or active_key == "-" then 
                    turn_negative = true
                    decimal = false
                    display = display .. "-"
                    face = 50
                    mouth_timer = 3
                    return
                end
            else
                if keyp(87) or active_key == "+" then operator = "+" end
                if keyp(86) or active_key == "-" then operator = "-" end
                if keyp(85) or active_key == "*" then operator = "*" end
                if keyp(84) or active_key == "/" then operator = "/" end
                local sign = 1
                if turn_negative then sign = -1 end
                add(instructions, tonum(number) * sign)
                number = ""
                add(instructions, operator)
                operator_behind = true
                display = display .. operator
                decimal = false
                turn_negative = false
                face = 50
                mouth_timer = 3
                return
            end
    end
    for n = 0, 9 do
        local number_on_keypad = false
        if n == 0 then if keyp(98) then number_on_keypad = true end end
        if n == 1 then if keyp(89) then number_on_keypad = true end end
        if n == 2 then if keyp(90) then number_on_keypad = true end end
        if n == 3 then if keyp(91) then number_on_keypad = true end end
        if n == 4 then if keyp(92) then number_on_keypad = true end end
        if n == 5 then if keyp(93) then number_on_keypad = true end end
        if n == 6 then if keyp(94) then number_on_keypad = true end end
        if n == 7 then if keyp(95) then number_on_keypad = true end end
        if n == 8 then if keyp(96) then number_on_keypad = true end end
        if n == 9 then if keyp(97) then number_on_keypad = true end end
        if keyp(tostr(n)) or number_on_keypad or active_key == tostr(n) then
            number = number .. n
            display = display .. n
            operator_behind = false
            face = 50
            mouth_timer = 3
            return
        end
    end
    if keyp(99) or active_key == "." 
        and not decimal and not operator_behind and number != "" then
            decimal = true
            number = number .. "."
            display = display .. "."
            operator_behind = false
            face = 50
            mouth_timer = 3
            return
    end
    if keyp("backspace") or active_key == "c" then
        face = 50
        mouth_timer = 3
        divided_by_zero = false
        result_given = false
        clear()
    end
    if keyp("enter") or keyp(88) or active_key == "=" then
        if number != "" and #instructions >= 2 and not operator_behind then
            local sign = 1
            if turn_negative then sign = -1 end
            add(instructions, tonum(number) * sign)
            number = ""
            operator_behind = true
            decimal = false
            turn_negative = false
            face = 50
            mouth_timer = 3
            calc_timer = #instructions * 15
            calculate()
        end
        return
    end
end

function clear()
	display = ""
	instructions = {}
	number = ""
	decimal = false
	operator_behind = false
	turn_negative = false
	return
end

function calculate()
	calc_timer -= 1
	if calc_timer > 0 then
		return
	end
	for i = #instructions, 1, -1 do
		local char = instructions[i]
		if char == "*" then
			local result = instructions[i - 1] * instructions[i + 1]
			add(instructions, result, i - 1)
			deli(instructions, i)
			deli(instructions, i)
			deli(instructions, i)
		end
		if char == "/" then
			if instructions[i + 1] == 0 then divided_by_zero = true end
			local result = instructions[i - 1] / instructions[i + 1]
			add(instructions, result, i - 1)
			deli(instructions, i)
			deli(instructions, i)
			deli(instructions, i)
		end
	end
	for i = #instructions, 1, -1 do
		local char = instructions[i]
		if char == "+" then
			local result = instructions[i - 1] + instructions[i + 1]
			add(instructions, result, i - 1)
			deli(instructions, i)
			deli(instructions, i)
			deli(instructions, i)
		end
		if char == "-" then
			local result = instructions[i - 1] - instructions[i + 1]
			add(instructions, result, i - 1)
			deli(instructions, i)
			deli(instructions, i)
			deli(instructions, i)
		end
	end
	local final_result = instructions
	clear()
	display = final_result[1]
	number = final_result[1]
	local faces = {55, 56, 57, 58}
	face = rnd(faces)
	result_given = true
end

function drawCalc()
	rectfill(7,7,119,50,15)
	spr(face, 48, 17)
	rectfill(7, 50, 119, 65, 19)--result bar
	local print_x = 0
	if #instructions > 0 and #tostr(display) > 12 then
		print_x = -(#tostr(display) - 12) * 5
	end
	
	print(display, 16 + print_x+1, 56, 19)--result
	print(display, 16 + print_x, 55, 7)--result
	for b in all(calcButtons) do
		-- bottom button
		circfill(b.x - 1, b.y + 2, 7, 19)
		circfill(b.x + 1, b.y + 2, 7, 19)
		--print(b.label, b.x - 2, b.y - 2, 7)
		if b.draw_top then
			-- top button
			
			circ(b.x - 1, b.y, 7, 28)
			circ(b.x + 1, b.y, 7, 28)
			circfill(b.x - 1, b.y, 6, 17)
			circfill(b.x + 1, b.y, 6, 17)
			print(b.label, b.x - 2, b.y - 3, 7)
		end
	end
	
	print("\014by patonildo",69,170,6)
end