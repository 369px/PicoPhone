--[[pod_format="raw",created="2024-04-02 18:54:07",modified="2024-04-13 03:49:17",revision=2198]]
include "miniapps/miditron/midi.lua"
include "miniapps/miditron/debug_funcs.lua"
include "miniapps/miditron/helper.lua"

-- Parameters:
-- Depth: (def: <4> tracker-notes per beat; 4 bars p/ sfx;  16th res.)
--             (<8> tracker-notes per beat; 2 bars p/ sfx;  32nd res.)
--             (<2> tracker-notes per beat; 8 bars p/ sfx;  8th res.)
-- 

-- basically
-- step 1: midi_data= 8 tables including note_on and note_off, sorted by minimal distance 
-- step 2: sfx_data= 8 userdata arrays representing full sequential 
--				tracker values (mem bytes) for each channel
-- step 3: modify sfx_data using the values provided by the user (dynamics, instrument, etc.)
-- step 4: transfer userdata to .sfx using metadata as parameter

function convertToPicotron(source_midi_file, output_sfx, parameters)
	
	parameters                    = parameters or {}
	parameters.noteDepth          = parameters.noteDepth or 4
	parameters.decayRate          = parameters.decayRate or 0.8
	parameters.ignoreTempoChange  = parameters.ignoreTempoChange or (false)
	parameters.stacatto           = parameters.stacatto or (false)
	
	metaChannel = {
		currentTick = 0,
		highestTick = 0,
	}
	rawNoteList = {}	
	
	-- this makes changes to metaChannel and rawNoteList
	-- processNote is a callback that is called on each 
	-- command in the .mid file
	midi.process(source_midi_file, processCommand)

	sortedNotes = qsort(rawNoteList, function(a,b) return a.position < b.position end)
	trackChannels = splitSimultaneousNotes(sortedNotes)
	
	
	trackChannels, metaChannel = translatePositionsAndTicks(
		trackChannels, metaChannel, parameters.noteDepth, parameters.stacatto
	)
	
	sections = formSFXSections(
		trackChannels, metaChannel, parameters.noteDepth, parameters.ignoreTempoChange
	)
	--printySections(sections)

	sfxMap, patternMap = buildSFXMap(sections, parameters)

	storeSfx(sfxMap, patternMap, output_sfx)
	state = "saved to:\n"..output_sfx
	
	loadSfxOntoMemory(output_sfx)
	music(0)
end


function processCommand(eventType, ...) 
	args = {...}	

	local lastMetaEvent = metaChannel[#metaChannel] or {endPosition=0}
	local lastEvent = rawNoteList[#rawNoteList]
	

	-- Waiting Time
	if eventType == "deltaTime" then
		local midiTicks = args[1]
		metaChannel.currentTick+=midiTicks	
	end

	-- Track Events
	if eventType == "noteOn" then
		local pitch    = args[2]
		local velocity = args[3]
		
		if velocity == 0 then
			eventType = "noteOff"
		else			
	
			add(rawNoteList, {	
				type="note",
				pitch=pitch,
				position=metaChannel.currentTick,
				midiTicks=0,
				velocity=velocity,  
				on=true,
				inst=1, --for the time being
			})
		end
	end	
	
	-- Turn off a currently playing note
	if eventType == "noteOff" then
		local pitch = args[2]
		
		-- loop reverse to find the last note with due pitch
		-- to turn off
		for i=0,#rawNoteList-1 do
			suspectEvent = rawNoteList[#rawNoteList-i]
			if suspectEvent.type=="note" then
				if suspectEvent.pitch == pitch then
					suspectEvent.on = false
					suspectEvent.midiTicks = metaChannel.currentTick-suspectEvent.position
					break
				end
			end
		end
	end
		
	
	-- Meta Events

	if eventType == "track" then
		metaChannel.currentTick = 0			
		-- only one track can provide metaEvents
		-- the rest will follow through the first track's metaEvents
		-- in changes in tempo, key sign, and time sign
		if (#metaChannel>0) metaChannel.locked = true
			
	end

	if eventType == "setTempo" and not metaChannel.locked then
		add(metaChannel, {
			type       = "setTempo",
			position   = metaChannel.currentTick,
			bpm        = args[1]
		}) end
		
	if eventType == "timeSignature" and not metaChannel.locked then
		add(metaChannel, {
			type       = "timeSignature",
			position   = metaChannel.currentTick,
			numerator  = args[1],
			denominator= args[2],
			metronome  = args[3],
			dotted     = args[4]
		})	end

	-- Nem precisa disso pra converter
	-- As propriedades de "event.pitch" ja possuem a informacao certa do pitch
	-- so e util pra gameplay talvez
	if eventType == "keySignature" and not metaChannel.locked then
		add(metaChannel, {
			type       = "keySignature",
			position   = metaChannel.currentTick,
			sharpCount = args[1],
			minor      = args[2]
		})	end

	if eventType == "header" then
		metaChannel.ppq = args[3]
	end
	
	metaChannel.highestTick = max(metaChannel.highestTick,metaChannel.currentTick)
		
end

function splitSimultaneousNotes(sortedNotes) 
	trackChannels =	{
		[1]={},
		[2]={},
		[3]={},
		[4]={},
		[5]={},
		[6]={},
		[7]={},
		[8]={}
	}
	for channel in all(trackChannels) do 
		channel[1]={type="trackStart", midiTicks=0, position=0, pitch=0}
	end

	for note in all(sortedNotes) do
		if note.type == "note" then
	
			local chosenChannel, lastEvent
			local smallestDeltaPitch = 999
			
			for channel in all(trackChannels) do
				lastEvent	= channel[#channel]
		
				local endPosition = lastEvent.position + lastEvent.midiTicks
				-- either rest or note that is not playing
				if note.position >= endPosition then
					local deltaPitch = abs(note.pitch - lastEvent.pitch)
					if deltaPitch < smallestDeltaPitch then 
						smallestDeltaPitch = deltaPitch
						chosenChannel = channel
					end
				end
			end	
			
			if (chosenChannel) add(chosenChannel, note) 
		end
	end
	
	return trackChannels
end


function translatePositionsAndTicks(trackChannels, metaChannel, noteDepth, stacatto)
	-- for each BPM or keySignature change
	-- calculate spd, midiTicksToSpdConversionRate, trackerNotesPerBeat (noteDepth)
	-- change BPM changes to spd changes
	-- calculate how many sfxs will be allocated for these ranges
	
	-- take the notes in between the start and end of these ranges
	-- for each note, add a trackerNotePosition, trackerNoteLength
		--note.trackerNoteLength = staccato and 1 or ()
	-- remove midiTicks
		
		 
	local midiTickPer64th = metaChannel.ppq \ 16

	for track in all(trackChannels) do 
		for event in all(track) do
			event.trackerPosition = (noteDepth / 16) * event.position / midiTickPer64th
			event.trackerLength   = (noteDepth / 16) * event.midiTicks / midiTickPer64th
			event.trackerPosition = round(event.trackerPosition)
			event.trackerLength   = stacatto and 1 or round(event.trackerLength)
		end 
	end

	for i=1,#metaChannel do
		local metaEvent = metaChannel[i]
		
		metaEvent.trackerPosition = (metaEvent.position / midiTickPer64th) * (noteDepth / 16)
		metaEvent.trackerPosition = round(metaEvent.trackerPosition)
	end
	
	-- translate the last recorded tick
	-- to know when to end the track
	metaChannel.lastTrackerPosition = (metaChannel.highestTick / midiTickPer64th) * (noteDepth / 16)
	metaChannel.lastTrackerPosition = ceil(metaChannel.lastTrackerPosition)
		
	return trackChannels, metaChannel
end


function formSFXSections(trackChannels, metaChannel, noteDepth, ignoreTempoChange)
		
	local currentTempo, currentTimeSignature
	local sections = {}	

	for metaEvent in all(metaChannel) do
	
		local prevSection = sections[#sections] or {}
		local startTrackerPosition = metaEvent.trackerPosition or 0 --prevSection.endTrackerPosition or 0	
		--[[
		startPosition *= spdTickPerMidiTick
		]]--
		if metaEvent.type == "timeSignature" then
		   local oldTimeSignature = currentTimeSignature
			currentTimeSignature = {metaEvent.numerator, metaEvent.denominator}
			
			-- failsafe against fake new sections
			if currentTempo and (
				oldTimeSignature[1]~=currentTimeSignature[1] or
				oldTimeSignature[2]~=currentTimeSignature[2]
				) then
				if (#sections~=0) prevSection.trackerLength = startTrackerPosition - prevSection.startTrackerPosition
				add(sections, {
					spd                  = bpmToSpd(currentTempo,noteDepth),
					timeSignature        = currentTimeSignature,
					startTrackerPosition = startTrackerPosition,
				})
			end
		end
		
		if metaEvent.type == "setTempo" then
			local oldTempo = currentTempo
			currentTempo = metaEvent.bpm
			
			if currentTimeSignature and oldTempo~=currentTempo and not ignoreTempoChange then
				if (#sections~=0) prevSection.trackerLength = startTrackerPosition - prevSection.startTrackerPosition
				add(sections, {
					spd                  = bpmToSpd(currentTempo,noteDepth),
					timeSignature        = currentTimeSignature,
					startTrackerPosition = startTrackerPosition,
				})
			end
		end
		
		prevSection.endTrackerPosition = startTrackerPosition - 1
	end
	
	-- for last section (metaChannel is holding currentTick as the last tick in the 
	local lastSection = sections[#sections]
	lastSection.endTrackerPosition = metaChannel.lastTrackerPosition
	
	--print(pp_tbl(sections))
	
	for section in all(sections) do
		section.trackerLength = section.endTrackerPosition - section.startTrackerPosition
		--section.totalBars = section.trackerLength / noteDepth * (section.timeSignature[1]/section.timeSignature[2])
		
		-- 48 is a three meter, 64 if a even meter (2 or 4)
		section.trackerSFXLength = section.timeSignature[1]==3 	and 48 or 64 
				
		--last one doesnt count
		--section.trackerSFXLength = section.trackerLength \ max(1, section.totalSFXUnits-1)
		
		for i=1,8 do 
			section[i] = tableFilter(trackChannels[i], function(note)
				--printy("tableFilter test "..i, section.startTrackerPosition, note.trackerPosition, section.endTrackerPosition) 
				if (note.type~="note") return false
				return (section.startTrackerPosition <= note.trackerPosition and
						  note.trackerPosition <= section.endTrackerPosition)
				end)
		end
		section.sfxUnitsPerChannel = ceil(section.trackerLength / section.trackerSFXLength)
	end
	
	-- remove all empty sections (lost setTempo and timeSignature events)
	sections=tableFilter(sections, function(section)
		for i=1,8 do 
			if (#section[i]>0) return true
		end
		return false
	end)

	return sections
end

function buildSFXMap(sections, parameters)
	-- sfx map is a n-item table, starting at 0
	-- populated by userdata("u8",328)
	-- DO NOT ITERATE IT WITH for sfx in all(sfxMap) CUS IT STARTS AT 0
	
	-- a sfx track: 328 bytes
	-- 8 bytes for the header: len (i16); spd; loop0; loop1; delay (i8); flags, null byte
	-- header[2] = spd
	-- header[3] = len or loop0
	-- header[4] = loop1
		
	-- 64 bytes for each column (one after another)
	-- 1. pitch
	-- 2. inst
	-- 3. vol
	-- 4. effect
	-- 5. effect_p

	-- patterns are 8-item tables showing what 
	-- sfx is active in each channel (int from 0-127)
	-- in memory, they're userdata("u8",20)
	
	--first, you need to know how notes are disposed in the sfx map

	sfxMap = {
	}
	patternMap = {}

	for s=1,#sections do
		section = sections[s]	

		--sfxMap[s] = {
		--	highestIndex=0
		--}		

		local spd, len
		spd, len = section.spd, section.trackerSFXLength	
		printy(spd,len)
		
		-- for channels with actual notes
		local activeChannels = tableFilter(section, function(channel) return (#channel>0) end)
		
		for i=0,section.sfxUnitsPerChannel-1 do
			for ch=0,#activeChannels-1 do
				--last sfx can have shorter lenght
				local lastLen
				if (i==section.sfxUnitsPerChannel-1) lastLen = section.trackerLength % section.trackerSFXLength
				
				local sfxHeader = userdata("u8",8)
				sfxHeader[0] = 0x40
				sfxHeader[2] = spd
				sfxHeader[3] = lastLen or len 
				
				local emptyColumnHex = "" 
				for j=0,63 do emptyColumnHex..="ff" end
				-- result: 64 times "ff"
				
				local pitchColumn    = userdata("u8",64, emptyColumnHex)
				local instColumn     = userdata("u8",64, emptyColumnHex)
				local volumeColumn   = userdata("u8",64, emptyColumnHex)
				local effectColumn   = userdata("u8",64) --these don't need ff values, 
				local effect_pColumn = userdata("u8",64) --00 is their default
				
				local lowerRange	= section.startTrackerPosition + i*len
		
				local isNoteInRange = function(note)
					return (lowerRange <= note.trackerPosition and
							 note.trackerPosition < lowerRange+len)
				end
				
				--processing	...
				--for note in all(tableFilter(section[ch+1], isNoteInRange)) do
				for note in all(tableFilter(activeChannels[ch+1], isNoteInRange)) do
					--start position of the note, INSIDE THE SFX TRACK (0-63)
					--using max in case of notes that start in another sfx track
					local start = max(0, note.trackerPosition % len) 
					--using min in case it ends after the sfx track ends
					local stop = min(len-1, start + note.trackerLength - 1)
						
			
					for n=start,stop do 
						pitchColumn[n]  = max(note.pitch - 12, 0)
						instColumn[n]   = note.inst
						volumeColumn[n] = flr(note.velocity * parameters.decayRate^(n-start)) --* 2 --range from 0-127 -> 0-255
						--effects arent implemented yet in picotron~
					end
				end
				
				local sfxTrack = userdata("u8",328)
				sfxTrack:set(0x000, sfxHeader:get())
				sfxTrack:set(0x008, pitchColumn:get())
				sfxTrack:set(0x048, instColumn:get())
				sfxTrack:set(0x088, volumeColumn:get())
				sfxTrack:set(0x0c8, effectColumn:get())
				sfxTrack:set(0x108, effect_pColumn:get())	
		
				function udEqual(u1,u2) 
					if (#u1~=#u2) return false
					for i=0,#u1-1 do if (u1[i]~=u2[i]) return false end return true 
				end

				printy("loop",i,"channel",ch,"sfx",i*8+ch,"isEmpty  ",udEqual(pitchColumn,userdata("u8",64, emptyColumnHex)))

				local nextIndex = #sfxMap + (sfxMap[0] and 1 or 0)
				sfxMap[nextIndex] = sfxTrack
		
				if (not patternMap[s])    patternMap[s]={}
				if (not patternMap[s][i]) patternMap[s][i]={}
				patternMap[s][i][ch] = nextIndex
			end
		end
	end	
		
	return sfxMap, patternMap
end

function storeSfx(sfxMap, patternMap, outputName)

	local saveFile = userdata("u8",0x30000)
	for i=0,0x1ffff do
		saveFile[i] = peek(0x30000+i)
	end
	
	--patterns
	local currentPattern = 0
	for section in all(patternMap) do
		print("section!")
		for p=0,63 do 
			if section[p] then
				local patternInfo = section[p]
				local patternAddr = 0x00100 + currentPattern*20
				printy("pattAdrr",p, pp_tbl(patternInfo),"",patternAddr)
				saveFile[patternAddr+9] = 0x00     --assumes all channels are muted
				for ch=0,7 do 			
					if patternInfo[ch] then
						saveFile[patternAddr+ch] = patternInfo[ch] --% 256 --trackIdx msByte
						saveFile[patternAddr+9] += 2^ch                    --trackMask
						--saveFile[patternAddr+ch*2]   = 0x00--patternInfo[ch] \ 0xff --trackIdx lsByte
					end
				end
				currentPattern+=1
			end
		end
	end

	-- tracks
	for i=0x20000,0x2ffff,328 do
		for j=0,7 do     saveFile[i+j] = peek(0x30000+i+j) end
		for j=8,199 do   saveFile[i+j] = 0xff              end
		for j=200,327 do saveFile[i+j] = 0x00              end
	end	

	for m=0,#sfxMap+1 do
		if (sfxMap[m]) saveFile:set(0x20000+328*m, sfxMap[m]:get())
	end

	store(outputName,saveFile)
end

function loadSfxOntoMemory(filename)
	local file = fetch(filename)
	for addr=0x00000,0x2ffff do
		poke(0x30000+addr,file[addr])
	end
end