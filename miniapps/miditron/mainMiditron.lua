--[[pod_format="raw",created="2024-04-02 16:25:34",modified="2024-06-06 16:38:17",revision=3848]]
-- ral's miditron
-- lua-midi library written by Possseidon
-- gui wrapper based on code from importpng by pancelor
-- inspiration and reference from Denote, conversion tool by bikibird

include "miniapps/miditron/Miditron.lua"
include "miniapps/miditron/midi.lua"
include "miniapps/miditron/helper.lua"
--include "debug_funcs.lua"

local parameters = {
	noteDepth         = 4,
	decayRate         = 0.80,
	ignoreTempoChange = false,
	stacatto          = false,
}

function initMidi()
	coro = nil
	state = rnd()<0.85 and "drop .mid or .midi here!" or rnd{"drop the dang midi file!", "drop midi file pls? owo","drop .mid file or\ni'll steal your SOCKS","drop the file already\ni wanna go home"}
	
	 itemDropped.check()
end


initMidi()

function updateMidi()
	if coro and costatus(coro)=="suspended" then
		assert(coresume(coro))
	end
end

local _last_state
local gui_selection = 1

function drawMidi()
	midiGui()
	
	line(7,88,119,88,28,3)	

	if state!=_last_state then
		_last_state = state
		cls()
		print("\#0"..state,8,144,6)
	end
end

function midiGui()
	rectfill(7,8,119,177,21) --backgrounds
--	rectfill(8,80,240,100,0)
	print("\014"..state.."\141",15,42,7)
	print("\148\131",10,78,7)--buttons up down
	print("\139\145",100,78,7)--buttons left right
	
	--color(28)
	if (gui_selection==1) rectfill(7,89,119,102,19)
	print("Track rows      ["..parameters.noteDepth.."]",10,92,gui_selection==1 and 28 or 7)
	if (gui_selection==2) rectfill(7,103,119,116,19)
	print("Note Decay      ["..parameters.decayRate.."]",10,106,gui_selection==2 and 28 or 7)
	if (gui_selection==3) rectfill(7,117,119,130,19)
	print("No BPM Change   ["..(parameters.ignoreTempoChange and "X" or " ").."]",10,120,gui_selection==3 and 28 or 7) --spr(parameters.ignoreTempoChange and 1 or 0, 120,32)
	print("\014(may fix some issues)",10,132,15)
	if (gui_selection==4) rectfill(7,141,119,154,19)
	print("Staccato        ["..(parameters.stacatto and "X" or " ").."]",10,144,gui_selection==4 and 28 or 7) --spr(parameters.stacatto and 1 or 0, 120,60)
	
	if (keyp("down")) gui_selection = min(4,gui_selection+1) not_used_yet = false
	if (keyp("up"))   gui_selection = max(1,gui_selection-1) not_used_yet = false
	
	if keyp("left") then
		if (gui_selection==1) parameters.noteDepth = max(1, parameters.noteDepth \ 2)
		if (gui_selection==2) parameters.decayRate = max(0, parameters.decayRate-0.05)
		if (gui_selection==3) parameters.ignoreTempoChange = not parameters.ignoreTempoChange
		if (gui_selection==4) parameters.stacatto = not parameters.stacatto
	elseif keyp("right") then
		if (gui_selection==1) parameters.noteDepth = min(parameters.noteDepth * 2, 32)
		if (gui_selection==2) parameters.decayRate = min(parameters.decayRate+0.05, 1)
		if (gui_selection==3) parameters.ignoreTempoChange = not parameters.ignoreTempoChange
		if (gui_selection==4) parameters.stacatto = not parameters.stacatto
	end
	
	print("\014navigate parameters\n  with arrow keys",26,69,6)
	print("\014by raul",81,170,15)
end
