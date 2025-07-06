pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- small loops collection
-- by packbats

-- track order for cart:
-- 1. scarf (sfx 10-15)
-- 2. downtown (sfx 16-23)
-- 3. don't stumble (sfx 24-31)
-- 4. forfeit (sfx 32-39)
-- 5. rank up (sfx 40-47)
-- 6. evening mess (sfx 48-55)
-- 7. gost (sfx 56-59)
-- 8. boating (sfx 60-63)
-- 0. sat 64 (sfx 00-09)

--  note on sat 64
-- sfx 00-03 are custom sfx
-- instruments and must be
-- copied separately

-->8
-- track data table

-- because it comes up more than once:
function playing_addr(channel)
	-- looks at stat() for currently playing sfx note and gives address in memory
	-- see https://pico-8.fandom.com/wiki/Memory#Sound_effects
	-- re: memory addresses
	return 0x3200 + 68 * stat(16+channel) + 2 * stat(20+channel)
	-- return 0x3200 + 68 * stat(46+channel) + 2 * stat(50+channel)--bugged????
--	local s,l=stat(46+channel),stat(50+channel)
--	printh(n..": "..s.."/"..l,"stat46debug.txt")
--	local a=0x3200 + 68 * s + 2 * l
--	return a
end

--note memory layout:
-- first byte: wwpppppp
-- second byte: ceeevvvw
--p=pitch, w=waveform, v=volume, e=effect, c=custom SFX instrument

function scale_degree(note)
	-- returns degree in C major, with +/- 0.5 for accidentals
	local n2 = note%12
	local degree = 7*flr(note/12) -- octave = 8 notes
		+ 0.5 * n2 -- as if there were a note between every scale degree
	if n2 > 4 then
		-- ..but there isn't between E and F so it goes up an extra half scale degree
		degree += 0.5
		-- octave thing handles the one that isn't between B and C
	end
	return degree
end

-- this might deserve to be a library function?
-- idk that's why we pulled it out and put it here
function frequency(note)
	return 110 -- frequency of A0
		* 2^((note-9)/12) -- semitones away from A0
end

-- gradients if we want them
-- h/t https://seansleblanc.itch.io/pico-8-fillp-tool
dithers={0x8000,0x8010,0x8014,0x8214,0x8a14,0x8a34,0x8a35,0xca35,
	0xca75,0xcb75,0xeb75,0xeb7d,0xeb7f,0xef7f,0xff7f}

--p01-style trifill
--see https://www.lexaloffle.com/bbs/?tid=31478
function trifill(x0,y0,x1,y1,x2,y2)
	--fill tri with current pen color
	--sort points so y0<y1<y2
	if y1<y0 then
		x0,y0,x1,y1=x1,y1,x0,y0
	end
	if y2<y0 then
		x0,y0,x2,y2=x2,y2,x0,y0
	end
	if y2<y1 then
		x1,y1,x2,y2=x2,y2,x1,y1
	end
	--split triangle at y1
	local xy1=x0+(y1-y0)/(y2-y0)*(x2-x0)
	trapefill(x0,x0,y0,x1,xy1,y1)
	trapefill(x1,xy1,y1,x2,x2,y2)
end
function trapefill(xa,xb,y0,dxa,dxb,y1)
	--fill trapezoid
	--dx# initially contain coords
	
	----when drawing 2d tline tris,
	----xa must be less than xb
	--if xa>xb then
		--xa,xb,dxa,dxb=xb,xa,dxb,dxa
	--end
	
	-- convert to deltas per line
	dxa,dxb=(dxa-xa)/(y1-y0),
		(dxb-xb)/(y1-y0)
	--draw scanlines
	for y0=y0,y1 do
		rectfill(xa,y0,xb,y0)
		xa+=dxa
		xb+=dxb
	end
end

track_data = {
	-- {#, name, first sfx, last sfx,
	-- animation coroutine fN}
	{1,"scarf",10,15,
	function ()
		-- emphasizing arps with circles
		-- distinguishing drops with squares
		-- wiggly line for melody
		local last_arp_addr = -1 -- for detecting new notes
		local last_mel_addr = -1
		local vibrato_offset = 0 -- for wigglying on vibrato
		local last_shapes = {} -- giving shapes persistence as they shrink away
		
		local last_points = {{124,130-3*26,4}} -- drawing line across screen
		-- initial values in last_points determine starting point of line
		local function drawshape(shape)
			local r,x = shape[1], shape[2]
			if shape[3] then
				-- drop effect; draw square
				rect(x-r, 72-r, x+r, 72+r, 4)
			else
				-- regular note; draw circle
				circ(x,72,r,3)
			end
		end
		repeat
			-- arp animation
			local shapes = {} -- accumulates shapes drawn
			for shape in all(last_shapes) do
				shape[1] -= .25 -- slowly shrink
				if shape[1] >= 0 then
					-- shape hasn't shrunk away;
					-- draw and add to shapes table
					drawshape(shape)
					add(shapes,shape)
				end
			end
			-- see https://pico-8.fandom.com/wiki/Memory#Sound_effects
			-- re: memory addresses
			local arp_addr = playing_addr(0)
			local arp_pitch = @arp_addr%64
			local arp_drop = @(arp_addr+1) < 64
			-- above is a bit of a hack: this particular track only uses
			-- notes with the fade-out effect (5) or notes with the drop
			-- effect (3), so whenever it's not the former it's the latter
			-- and if it's the former, the 64s bit (corresponding to effects 4-7)
			-- will be flipped in the byte
			
			-- also note that none of these notes have a custom sfx instrument
			-- that would add 128 to the value at arp_addr+1
			if arp_addr ~= last_arp_addr then
				-- new note
				local r = 12 -- it's a pleasant size
				local shape = {}
				if arp_drop then
					local x=6*arp_pitch - 38 -- puts drop notes to the left of regular notes
					shape = {r,x,true}
				else
					local x=6*arp_pitch - 19
					shape={r,x,false}
				end
				drawshape(shape)
				add(shapes,shape) -- it's a new shape, it goes in the table
			end
			last_arp_addr = arp_addr -- update for next frame
			last_shapes = shapes
			-- melody animation
			if stat(17) >= 0 then -- melody has kicked in
			-- if stat(47) >= 0 then -- melody has kicked in
				local points={}
				local mel_addr = playing_addr(1)
				local mel_pitch = @mel_addr%64
				local mel_vol = flr(@(mel_addr+1)/2)%8
				local mel_effect = flr(@(mel_addr+1)/16)
				-- would normally have to worry about custom sfx instrument bit
				-- but is zero for all sfx in this pattern
				if mel_addr ~= last_mel_addr then
					-- new pitch
					local mel_color = ({1,2,4,8,9,10,7})[mel_vol] -- volume gradient
					add(points,{124+8,130-3*mel_pitch,mel_color}) -- added offscreen to avoid pop-in
				elseif mel_effect == 2 then
					-- vibrato
					vibrato_offset = 1-vibrato_offset -- alternates between 0 and 1
					local mel_color = ({1,2,4,8,9,10,7})[mel_vol]
					add(points,{124+8,130-3*mel_pitch+vibrato_offset,mel_color})
				else
					vibrato_offset = 0
				end
				last_mel_addr = mel_addr
				for point in all(last_points) do
					-- points are drawn from right edge of screen to left
					point[1]-=1
					if point[1] >= -24 then
						if #points > 0 then
							local point2 = points[#points] -- each point connects to the last
							
							line(point2[1],point2[2]-flr(point2[3]/4),
								point[1],point[2]-flr(point[3]/4),point2[3])
							line(point2[1],point2[2]+flr(point2[3]/4),
								point[1],point[2]+flr(point[3]/4),point2[3])
						end
						add(points,point) --...and is saved in the table for next point to connect to
					end
				end
				last_points = points
			end
			yield() -- draw each frame, repeat forever
		until false
	end},
	{2,"downtown",16,23,
	function ()
		-- musical staff with walking bassline and melody notes
		local foot = {{-10,-10},{-10,-10}} -- positions to draw feet; start offscreen
		local foot_i = 1 -- which foot gets drawn next
		local foot_prev = -1 -- to detect new pitch to draw
		local notes_prev = {} -- notes that are still on screen
		local note_prev = -1 -- likewise to detect new pitch to draw
		local measure = -1 -- position of measure bar
		repeat
			if lightscheme then
				pal(7,0)
				pal(6,5)
			end
--			-- draw staff
--			pal(7,0) -- black is not drawn by default so used white to represent black
			map(0,0,5,22,16,8)
--			pal() -- remember to unpal your pal changes!
			-- update table for walking bassline
			foot[1][1] -= 1
			foot[2][1] -= 1
			local foot_addr = playing_addr(1)
			local foot_pitch = @foot_addr%64
			if foot_pitch ~= foot_prev then
				-- new pitch in walking bassline; move foot
				foot[foot_i] = {97,foot_pitch} -- 97 is a magic number - looked good
				foot_i = 3-foot_i -- alternate between 1 and 2
			end
			foot_prev = foot_pitch
			-- draw walking bassline
			spr(16,foot[1][1],64+22-2.5*scale_degree(foot[1][2])) -- 64 is also a magic number
			spr(0,foot[2][1],64+22-2.5*scale_degree(foot[2][2])) -- puts the low A and high G in the right place
			-- 2.5 corresponds to spacing of 5 between ledger lines and faking accidentals shamelessly
			-- update table for and draw old notes
			local notes = {}
			for note in all(notes_prev) do
				note[1] -= 1
				if note[1] > 28 then
					-- note still visible; draw it
					
					-- but first: determine if dissolving away
					-- hat tip to https://seansleblanc.itch.io/pico-8-fillp-tool
					-- for tool to turn dither fill patterns into hex codes
					-- these specific dithers are ours and made in it
					if note[1] < 30 then
						fillp(0xefbf.8) -- 0x0.8 = 0b0.1 = 0.5 = transparency bit
					elseif note[1] < 34 then
						fillp(0xafad.8) -- these do a gradient from mostly-transparent
					elseif note[1] < 38 then
						fillp(0xa5a5.8) -- through half-opaque
					elseif note[1] < 42 then
						fillp(0xa0a1.8) -- and mostly-opaque
					elseif note[1] < 46 then
						fillp(0x8020.8)
					end -- to full color if far from staff
					local h = 29+22 - 2.5*scale_degree(note[2]-24) -- 29 is a magic number; puts low F in right place
					ovalfill(note[1], h, note[1]+5, h+3,7)
					fillp() -- remember to clear your fill patterns!
					add(notes, note) -- remember visible notes for next frame
				end
			end
			local note_addr = playing_addr(2)
			local note_pitch = @note_addr%64
			if note_pitch ~= note_prev then
				-- new note
				local h = 29+22 - 2.5*scale_degree(note_pitch-24)
				ovalfill(97, h, 97+5, h+3,0)
				add(notes, {97,note_pitch})
				note_prev = note_pitch
			end
			notes_prev = notes
			yield()
		until false
	end},
	{3,"don't stumble",24,31,
	function ()
		-- animating fundamental and harmonic frequencies of sawtooth waves
		
		-- plot parameters
		local freq_multiple = 12 -- each pixel is this many Hz
		-- still shows contour of song while fitting in lots of harmonics
		local freq_delta = flr(82.4/freq_multiple)-7 -- puts low E near left edge of frame
		local freq_max = 120*freq_multiple -- stops calculation at right edge of frame
		
		local graph_zero = 74 -- balance the chart height on-screen
		local he = 0.6 -- exponent on volume -> height;
		-- makes the bars shrink a little more slowly from full length, so animation is less frenetic
		local h0 = 7.5 -- scales to fit on screen
		local dh = 1 -- cut off bottom of length to make bars shrink closer to 0 by the end of their playing
		
		local reflect = -0.35
		
		-- animation parameters
		local lead_vol, bass_vol = 0,0
		local lead_pitch, bass_pitch = 24,24
		local lead_dvol, bass_dvol = 0,0
		local lead_dpitch = function() return 0 end
		-- lead_dpitch is a function to allow for oscillation in the case of vibrato
		-- which looked terrible so we took it out
		local last_addr = -1
		local frames = 10 -- alternates between 10 and 11, because SPD = 21
		local bass_mvol, lead_mvol = 0,0
		repeat
			if lightscheme then
				rectfill(0,graph_zero-1,128,128,12)
				pal(1,5)
				pal(12,1)
			end
			local bass_addr = playing_addr(0)
			if bass_addr ~= last_addr then
				local lead_addr = playing_addr(1)
				-- set up pitch and vol to a starting value
				-- set up a delta to move it to ending value
				-- at end of the note
				local bp = peek(bass_addr)%64
				local bv = flr(@(bass_addr+1)/2)%8
				local be = flr(@(bass_addr+1)/16)
				-- would normally have to worry about custom sfx instrument bit
				-- but is zero for all sfx in this pattern
				local lp = peek(lead_addr)%64
				local lv = flr(@(lead_addr+1)/2)%8
				local le = flr(@(lead_addr+1)/16)
				
				-- bass effects: 0 or 5
				bass_vol, bass_mvol, bass_pitch = bv,bv,bp
				if be == 5 then
					bass_dvol = -bass_vol/frames
				else
					bass_dvol = 0
				end
				
				-- lead effects: 0, 1, 2, 5
				if le == 1 then
					-- glide
					if stat(21) == 0 then
					-- if stat(51) == 0 then
						lead_pitch = 24
						lead_vol, lead_mvol = lv,lv
						local ldp = (lp-24)/frames
						lead_dpitch = function() return ldp end
						lead_dvol = 0
					else
						lead_pitch += lead_dpitch()
						lead_vol += lead_dvol
						lead_mvol = lead_vol
						local ldp = (lp-lead_pitch)/frames
						lead_dpitch = function() return ldp end
						lead_dvol = (lv-lead_vol)/frames
					end
				elseif le == 5 then
					lead_pitch, lead_vol, lead_mvol = lp,lv,lv
					lead_dpitch = function() return 0 end
					lead_dvol = -lv/frames
				else
					lead_pitch, lead_vol, lead_mvol = lp,lv,lv
					lead_dpitch = function() return 0 end
					lead_dvol = 0
				end
				
				-- update frames
				frames = 21-frames -- alternates between 10 and 11
				last_addr = bass_addr
			else
				lead_pitch += lead_dpitch()
				lead_vol += lead_dvol
				if lead_mvol < lead_vol then
					lead_mvol = lead_vol
				end
				bass_vol += bass_dvol
			end
			
			local bass_freq = frequency(bass_pitch)
			local lead_freq = frequency(lead_pitch)
			-- if lead_vol > 0 then
			if lead_mvol > 0 then
				for f=lead_freq, freq_max, lead_freq do
					local c1,c2, c3,c4 = 12,13, 1, 1
					local x = flr(f/freq_multiple) - freq_delta
					
					local hm = 2*h0*(lead_mvol^he)*lead_freq/f-dh
					
					local h = 2*h0*(lead_vol^he)*lead_freq/f-dh
					rectfill(x,graph_zero-1-3*h/4,x,graph_zero-hm,c1)
					rectfill(x,graph_zero,x,graph_zero-h/2,c1)
					rectfill(x-1,graph_zero-3*h/4,x-1,graph_zero-1-h/2,c2)
					rectfill(x+1,graph_zero-3*h/4,x+1,graph_zero-1-h/2,c2)
					h *= reflect
					hm *= reflect
					rectfill(x,graph_zero+2-3*h/4,x,graph_zero+1-hm,c3)
					rectfill(x,graph_zero+1,x,graph_zero+1-hm/2,c3)
					rectfill(x-1,graph_zero+1-3*h/4,x-1,graph_zero+2-h/2,c4)
					rectfill(x+1,graph_zero+1-3*h/4,x+1,graph_zero+2-h/2,c4)
				end
			end
			if bass_mvol > 0 then
				for f=bass_freq, freq_max, bass_freq do
					local c1,c2,c3 = 8,2,1
					local x = flr(f/freq_multiple) - freq_delta
					
					local hm = 3*h0*(bass_mvol^he)*bass_freq/f-dh
					rectfill(x,graph_zero,x,graph_zero-hm,c3)
					pset(x,graph_zero-hm, c2)
					
					local h = 3*h0*(bass_vol^he)*bass_freq/f-dh
					rectfill(x,graph_zero,x,graph_zero-h,c1)
					h *= reflect
					rectfill(x,graph_zero+1,x,graph_zero+1-h,c2)
				end
			end
			yield()
		until false
	end},
	{4,"forfeit",32,39,
	function ()
		-- visualizer notes:
		
		-- - new note in a channel when:
		--   	a. new pitch, or
		--   	b. volume goes up without a slide (1) effect
		-- - want to emphasize the arps in channel 0
		--   	each group of 8 notes in that channel are a distinct idea
		-- - melody in channel 1 uses exactly 5 notes: white keys D2 through A2
		
		-- skipping rocks idea for channel 0 arps
		-- - line bouncing across a surface
		-- - an oval ripple spreading out from each point it lands
		
		-- color idea for channel 1 notes:
		-- A2 (33) : 11 (green)
		-- G2 (31) : 12 (blue)
		-- F2 (29) : 13 (indigo)
		-- E2 (28) :  2 (dark purple)
		-- D2 (26) :  1 (dark blue)
		local lpc_prev,i_dissolve=11,17
		--dissolve on odd gradients for ease-in, ease-out
		local rp_prev,ripples=-1,{}
		--detect new notes and create ripples
		repeat
			-- oval draw
			local lead_pitch_color = ({1,2,13,12,11})[(@(playing_addr(1))%64-23)\2]
			-- 33 -> 10 -> 5;
			-- 31 ->  8 -> 4;
			-- 29 ->  6 -> 3;
			-- 28 ->  5 -> 2;
			-- 26 ->  3 -> 1
			
			--!!rewrite dissolve to predict upcoming change and start transition ahead of it!!
			if lead_pitch_color ~= lpc_prev then
				if i_dissolve > 0 then
					--currently dissolving
					i_dissolve-=2
					lead_pitch_color += 16*lpc_prev
					fillp(dithers[i_dissolve])
				else
					i_dissolve=17
					lpc_prev = lead_pitch_color
				end--i_dissolve
			end--lead pitch color changed
			
			ovalfill(-4,20,136,80,lead_pitch_color)
			fillp()
			
			-- ripple animation
			local rhythm_pitch = @(playing_addr(0))%64
			--falls in 16-31 range
			if rhythm_pitch ~= rp_prev then
				add(ripples,{rhythm_pitch,3})
				rp_prev = rhythm_pitch
			end
			for ripple in all(ripples) do
				if ripple[2]>13 then
					del(ripples,ripple)
				else
					local p,a =ripple[1],ripple[2]
					local x,y = 2.5*p+6,74-p
					if a>8 then
						fillp(dithers[flr(3*a-23)])
					end
					oval(x-2*a,y-a,x+2*a,y+a,7+16*lpc_prev)
					fillp()
					ripple[2]+=1/3
				end
			end
			
			yield()
		until false
	end},
	{5,"rank up",40,47,
	function ()
		-- visualizer notes:
		
		-- SPD = 20
		-- in channel 0, the notes with effect 0 instead of 5 stand out
		--  range C0 to C2
		-- in channel 1, the notes with instrument 6 stand out
		-- swoopies in and general contour of channel 2 seem worth emphasizing
		--  swoops are up from C2 to F2, range is from C2 to A#2 (actually Bflat2)
		--  choppies seem worth expressing too
		
		-- for octave jumps in channel 0, maybe use a 12-segment spiral to put them adjacent?
		
		local const_dr=1
		local function spiral(note,fill)
			--offset note
			note+=12
			--find unit vectors for sides of spiral segment
			local x_u,y_u=const_dr*cos(note/12),const_dr*sin(note/12)
			local x_up,y_up=const_dr*cos((note+1)/12),const_dr*sin((note+1)/12)
			--find vertices
			local x0,y0=note*x_u,note*y_u
			local x1,y1=(note+12)*x_u,(note+12)*y_u
			local x2,y2=(note+13)*x_up,(note+13)*y_up
			local x3,y3=(note+1)*x_up,(note+1)*y_up
			if fill then
				--fill segment with current pen color
				trifill(x0,y0,x1,y1,x2,y2)
				trifill(x0,y0,x2,y2,x3,y3)
			else
				--outline segment with current pen color
				line(x0,y0,x1,y1)
				line(x2,y2)
				line(x3,y3)
				line(x0,y0)
			end
			--output angle, radius of center of note
			return (note+.5)/12, (note+6.5)*const_dr
		end
		
		local bass_addr_prev,bass_note_prev,bass_effect_prev=-1,-1 
--		local xprev,yprev=
		
		repeat--draw loop
			--center: x=64, y=53
			camera(-64,-53)
			
			--bass line: spiral
			local bass_addr=playing_addr(0)
			local bass_note=@bass_addr%0b01000000
			local bass_effect=@(bass_addr+1)\0b00010000--assumes no custom sfx instrument
			
			color(lightscheme and 0 or 7)
			spiral(bass_note,bass_effect==0)
			--reset at end of bass calculations
			fillp()
			bass_addr_prev,bass_note_prev,bass_effect_prev=bass_addr,bass_note,bass_effect
			
			
			camera()
			yield()
		until false--draw loop end
		
	end},
	{6,"evening mess",48,55,
	function ()
	end},
	{7,"gost",56,59,
	function ()
		-- visualizer notes:
		
		-- SPD = 80 (40 for percussion)
		-- have to acknowledge percussion somehow, but it's kind of unobtrusive?
		-- maybe something with big areas of color, and their fill patterns go staticky when percussion hits?
		-- (possibly use a bitmask to do the staticking?)
		-- (probably easier to just use fill patterns)
	end},
	{8,"boating",60,63,
	function ()
	end},
	{0,"sat 64",0,9,
	function ()
	end}
	}

-->8
-- track play/animation fNs
function init_track()
	-- load track data, start music, start animation
	if n >= 1 and n <= #track_data then
		td = track_data[n]
		music(td[3])
		anim = cocreate(td[5])
	else
		-- have run off end of list;
		-- go back to title
		music(-1)
		init_title()
	end
end

function update_track()
	if btnp(0) then
		-- previous track
		n -= 1
		init_track()
	elseif btnp(1) then
		-- next track
		n += 1
		init_track()
	end
	if t_lightscheme < 40 and (btnp(2) or btnp(3)) then
		lightscheme = not lightscheme
		-- wcag 2.1 guideline is no more than 3 flashes per second
		-- constraining palette change to no more than 3/second
		t_lightscheme += 20
	end
	t_lightscheme = max(t_lightscheme-1,0)
	if btnp(4) or btnp(5) then
		animate = not animate
	end
end

function draw_track()
	if animate or frame ~= n then
		-- clear screen and draw visualizer and track name
		if lightscheme then
			cls(7)
		else
			cls(0)
		end
		clip(4,5,120,96) -- restricting animation to top of screen
		if costatus(anim) == "suspended" then
			-- coroutine exists and is running; run it
			assert(coresume(anim))
		end
		clip()
		pal()
		frame = n
		
		if lightscheme then
			pal(13,5)
			pal(7,0)
		end
		rectfill(12,104,116,105,13) -- horizontal rule
		print("track "..td[1]..": "..td[2],8,110,7)
		print("in sfx & patterns "..td[3].." - "..td[4],22,119,7)
		pal()
	end
end

-->8
-- title screen fNs
function _init()
	animate = true
	lightscheme = true
	t_lightscheme = 0
	init_title()
end

function init_title()
	_update60 = update_title
	_draw = draw_title
	n, frame = 0, 0
end

function update_title()
	-- if btnp(1) then
		-- n = 1
		-- init_track()
		-- _update60 = update_track
		-- _draw = draw_track
	-- elseif btnp(0) then
		-- n = #track_data
		-- init_track()
		-- _update60 = update_track
		-- _draw = draw_track
	-- end
	-- if btnp(4) or btnp(5) then
		-- animate = not animate
	-- end
	
	-- deduplication rewrite
	-- same controls on title screen and visualization screens
	if btnp(1) or btnp(0) then
		_update60,_draw = update_track, draw_track
	end
	if btnp(0) then
		-- this is hacky but
		n = #track_data+1
		-- puts the thingy in the right place
	end
	update_track()
end

function draw_title()
	-- placeholder title screen
	if lightscheme then
		cls(7)
	else
		cls(0)
	end
	rectfill(4,4,123,99,13)
	print("small loops collection",21,39,0)
	print("small loops collection",20,38,7)
	
	print("by packbats",31,60,0)
	print("by packbats",30,59,7)
	
	if lightscheme then
		pal(7,0)
	end
--	print("⬅️ select track ➡️",28,112,7)
	-- print("⬅️ select track ➡️",28,107,7)
	print("⬅️ select track ➡️",28,103,7)
	print("⬇️ toggle color scheme ⬆️",14,111,7)
	if animate then
		-- print("❎/🅾️ toggle anim (curr. on)",8,116,7)
		print("❎/🅾️ toggle anim (curr. on)",8,119,7)
	else
		-- print("❎/🅾️ toggle anim (curr. off)",6,116,7)
		print("❎/🅾️ toggle anim (curr. off)",6,119,7)
	end
	pal()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddd0000000000000000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd0000000000000770770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd2000000000007000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000000007000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddddd20000666666667666667666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
000dddd0000660600007000007000000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600000700077000000007000700077000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600000700770000000070000770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ddd0000000660600000707700000000070770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd0000666666666777666666666677776677666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd2000660600000770000000000007770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000660600007770000000000000000070077000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd2000660600077070000000000000000770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dddd0000660600077070000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666666776676666666666666667766666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600770077770000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600700077777000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600700777007700000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600700707000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666666766767766766666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600700700700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600070070700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600007000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660600000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666666666666676666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777ddddddddddddddddd77d777d777d7ddd7ddddddd7dddd77dd77d777dd77dddddd77dd77d7ddd7ddd777dd77d777d777dd77d77dddddddddddddddddd7777
7777dddddddddddddddd7d007770707070dd70dddddd70dd7d707d7070707d00dddd7d007d7070dd70dd70007d00d700d7007d70707ddddddddddddddddd7777
7777dddddddddddddddd777d7070777070dd70dddddd70dd707070707770777ddddd70dd707070dd70dd77dd70ddd70dd70d70707070dddddddddddddddd7777
7777ddddddddddddddddd0707070707070dd70dddddd70dd707070707000d070dddd70dd707070dd70dd700d70ddd70dd70d70707070dddddddddddddddd7777
7777dddddddddddddddd77d070707070777d777ddddd777d77d077d070dd77d0ddddd77d77d0777d777d777dd77dd70d777d77d07070dddddddddddddddd7777
7777ddddddddddddddddd00dd0d0d0d0d000d000ddddd000d00dd00dd0ddd00ddddddd00d00dd000d000d000dd00dd0dd000d00dd0d0dddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddd777d7d7ddddd777d777dd77d7d7d777d777d777dd77ddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddd70707070dddd707070707d00707070707070d7007d00dddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddd77d07770dddd7770777070dd77d077d07770d70d777ddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddd707dd070dddd7000707070dd707d707d7070d70dd070dddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddd77707770dddd70dd7070d77d707077707070d70d77d0dddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777ddddddddddddddddddddddddddd000d000ddddd0ddd0d0dd00d0d0d000d0d0dd0dd00ddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
7777dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd7777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777000007777777007000707770007700700077777000700070007700707077777700000777777777777777777777777777777
77777777777777777777777777770007700777770777077707770777077770777777707707070707077707077777007700077777777777777777777777777777
77777777777777777777777777770077700777770007007707770077077770777777707700770007077700777777007770077777777777777777777777777777
77777777777777777777777777770007700777777707077707770777077770777777707707070707077707077777007700077777777777777777777777777777
77777777777777777777777777777000007777770077000700070007700770777777707707070707700707077777700000777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777700000777777000770077007700707770007777770077007077770070007777770077007070700070007000777777000007777777777777777
77777777777777007770077777707707070777077707770777777707770707077707070707777707770777070707770007077777770007000777777777777777
77777777777777007770077777707707070777077707770077777707770707077707070077777700070777000700770707007777770077700777777777777777
77777777777777000700077777707707070707070707770777777707770707077707070707777777070777070707770707077777770077700777777777777777
77777777777777700000777777707700770007000700070007777770070077000700770707777700777007070700070707000777777000007777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777700000777707700000777777000770077007700707770007777700070077000700077777707770070707000700077777777770070077707777777777
77777777007070077077007770077777707707070777077707770777777707070707707700077777077707770707070707077777777707070707770777777777
77777777000700077077007070077777707707070777077707770077777700070707707707077777077707770707007700777777777707070707770777777777
77777777007070077077007770077777707707070707070707770777777707070707707707077777077707770707070707077777777707070707770777777777
77777777700000770777700000777777707700770007000700070007777707070707000707077777707770077007070707077077777700770707707777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__map__
0102030606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112131616161616161616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2122232626262626262626262626262600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132333636363636363636363636363600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104050606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1114151616161616161616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2124252626262626262626262626262600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3134353636363636363636363636363600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00011e20232701947014470104700e4700b3600936008360073600636005350050500505004050030400304003040030400304002040020400204002040020400203002030020300203002030020300202002020
0001000033670306602e6602c6502b6502b6502b6402b6402b6402b6302b6302c6302d6302f62033620386203c610000000000000000000000000000000000000000000000000000000000000000000000000000
00011c2028670216711d6711a67117671146711266111661106610e6610d6610d6510c6510b6510b6410a64109641086310863107631076310663105621056210562104621046210462104621046210462104621
0001000c33670306602e6602c6502b6502b6502b6402b6402b6402b6302b6302c6302d6302f62033620386203c610000000000000000000000000000000000000000000000000000000000000000000000000000
01180000188501885018a5018a5018a4118a3118a5318a50188501885018a5018a5018a4118a3118a5318a50188501885318a5018a5018a4118a3118a5318a50188501885018a5018a5018a4118a3118a5318a53
011800002491024900249100000024910000002491000000249100000024910000002491018910249100000024910000002491000000249100000024910000002491000917249100000024910009172491000917
01180000249100c3032491000000249101891024910000002491000917249100000024910189102491000000249100000024b1024b10249100000024910000002491000917249100000024910009172491000917
010c00202355523555235550050000500005000050000500005000050000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00202355523555235550050000500005000050023555245502455500500005002455024555005000050000500005000050000500005000050000500005000000000000000000000000000000000000000000
010c00202355523555235550050000500005000050023555245502455500500005002455024555005000050026550265412653126535265352654526555265552655526555265552655526550265502655500000
05180000110750c05509045110350c07509055110450c03509075110550c04509035110750c0550904509053110750e05509045110350e07509055110450e03509075110550e04509035110750e0550904509053
05180000110750e0550a045110350e0750a055110450e0350a075110550e0450a035110750e0550a0450a053130750e0550a045130350e0750a055130450e035150750e0550a045150350e0750a0551504513055
011800001f1512115121141211312114121151211412113121141211512114121151221512215122141221311f15021151211412113121141211512114121131211412115121141211511f1511f1511f1411f131
05180000110750e0550a045110350e0750a055110450e0350a075110550e0450a035110750e0550a0450a053130750e0550a045130350e0750a055130450e0350e0750a055090450e0350a075090550e04513055
011800001f151211511f1412113121142211522114121131211412115121141211512215021150221402113024150261512614126131241402415124141241312414124151221402215121150211512114121131
011800001c1511d1511d1411d1311f1411f1511f1511f1521f1521f1521f1511f1411f1311d1411d1311d131211512215122151221511f1511f1511f1411f1412115121151211512115121141211312112121111
011018001124300400004000f44300400004001044300400004000e44300400004001144300400004000f44300400004001044300400004000e44300400004000040000000000000000000000000000000000000
191018000506005031050210706007031070210906009031090210a0600a0310a0210906009031090210706007031070210506005031050210606006031060210000000000000000000000000000000000000000
011018001d3401d340223402434024340283402434024340263402434024340253402634026340243402634026340243402234022340233402434024340203400000000000000000000000000000000000000000
191018000706007031070210a0600a0310a0210e0600e0310e0211306013031130210c0600c0310c0210906009031090210706007031070210606006031060210000000000000000000000000000000000000000
011018001f3401f340243402634026340293402634026340283402634026340273402834028340283402434025340263402734027340273402134022340233400000000000000000000000000000000000000000
011018002434024340223401d34022340263402434024340263402434024340253402634026340243402634026340243402234022340233402434024340203400000000000000000000000000000000000000000
011018001f3401f3402434026340263402934026340263402834026340263402734028340283402834028340283402634024340243402434024340243401f3400000000000000000000000000000000000000000
011018001f3401f340243402634026340293402634026340283402634026340273402834028340283402834028340293402b3402b3402b3402b3402b3402b3400000000000000000000000000000000000000000
091500000426504255042550425504255042550425504265072600726504265092600926504265072600625504265042550425504255042550425504255042650726507255072550926009265042650b26009255
011500001726117252172551725517265172501725517255192501825017265152501526515250132501525017261172521725517255172651725017255172551325113255132551525015265152501325515250
0115000017261172521725517255172651725017255172551925018250172651925019265192501a250192501a2611a2521a2551a2551a2651a2501a2551c2551d2501d2551d2651c2501c2651c2501a26519250
0115000017261172521725517255172651725017255172551925018250172651925019265192501a250192501a2611a2521a2551a2551a2651a2501a2551c2551d2601d2521d2501d2411d2311d2211d2111c201
09150000042650425504255042550425504255042550426507260072650426509260092650426507260092550b2650b2550b2550b2550b2550b2550b2550b2650926509255092550b2600b265092650726006255
01150000000000000000000000000000000000000000000013240132450000015240152450000013240152451a2611a2521a2551a2551a2651a2501a2551c2551d2601d2521d2501d2411d2311d2211d2111c201
011500000000000000000000000000000000000000000000132501325500000152501525500000132501225510250102311022110211000000000000000000001326513265132651526015241152311522115211
011500000000000000000000000000000000000000000000132501325500000152501525500000132501225510250102311022110211000000000000000000001726517265172651926019241192311922119211
011000001005015050180501804118031180211801118001100501505017050170411703117021170111700110050150501a0501a0411a0311a0211a0111a0011005015050170501704117031170211701117001
1910000021550215502154121540215422154221540215401f5501f5501f5411f5401f5401f5401f5401f5401d5501d5501d5411d5401d5421d5421d5401d5401a5501a5501a5411a5401a5401a5401a5401a540
01100000100501505018050180411803118021180111800110050150501705017041170311702117011170010e050100501305013041130311302113011130010e05010050150501504115031150211501115001
191000001d5501d5501d5411d5401d5421d5421d5401d5401f5501f5501f5401f5401f5401f5401f5401f5211f5501f5501f5411f5401f5401f5401d5501d5501c5501c5501c5411c5401c5401c5401c5311c530
0110000015050180501d0501d0411d0311d0211d0111d00115050180501c0501c0411c0311c0211c0111c00115050180501d0501d0411d0311d0211d0111d00115050180501f0501f0411f0311f0211f0111f001
191000001d5501d5501d5501d5501d5501d5501d5501d5501d5521d5521d5501d5501d5501d5501d5501d5501f5511f5501f5501f5501f5521f5521f5501f5501f5521f5521f5521f5311f5521f5521f5521f552
01100000100501505018050180411a0501a0411a0311a021100501505018050180411c0501c0411c0311c02110050150501805018041170501704117031170211005015050180501804113050130410e0500e041
191000001c5501c5501c5411c5401c5401c5511d5501d5501c5501c5501c5411c5401c5401c5511d5501d5501c5501c5501c5411c5401c5401c5511d5501d5501a5521a5521a5411a5401a5401a5401a5311a530
05140000053550534505345113450534505345153401334505355053450534511345053450534515340163450535505345053451134505345053451534016345183400c3450c345183450c3450c3451634015345
011400000c143001000c1330c143000000c133266531a6530c143000000c1330c143000000c133266531a6530c1430c1330c1330c143000000c133266531a6530c143266531a6530c1430c1330c133266531a653
0514000005355053450534511345053450534515340133450535505345053451134505345053450e340103450035500345003450c34500345003450c3400e3450435504345043451034504345043450e34010345
011400001d5611d5511c5501d5501d5411c5501a5501c5501d560000001d5501f5621f5521f5411f531180001d5711d5511c5501d5501d5411c550185501a5501c5651c5551c5551c5521c5411a5501855018550
011400001d5611d5511c5501d5501d5411c5501a5501c5501d560000001d5501f5621f5521f5411f531180001d5711d5511c5501d5501d5411f55022550215501f5651f5551f5551f5521f5411d5501f5501f541
0514000005355053450534511340113211132515340133450535505345053451134011321113250e340103450035500345003450c3400c3400c3450c3400e3450435504345043451034004345043450e34010345
011400000c143001000c1030c103000000c103266031a6030c143000000c1330c143000000c103266031a6030c1430c1030c1030c103000000c133266531a6530c143266031a6030c1430c1330c133266531a653
011400001d5611d5511c5501d5501d5411c5501a5501c5501d550000001d5501f5621f5521f5411f531180001d5711d5111d5501f5621f5521f5411f531180001d5711d5111d55022562215501f5501f5411f531
0911000011154151541615417154151541715415154151501115415154161541715418154131541515415150101541515416154171540e1541515416154171540c15415154161541515413154151541615416150
611100000524005240052420524205240052400523105211052400524005240052400524005240052310521104240042400423104211052400524005231052110724007240072420724207240072400723107211
191100000c343000002b64500000296450000028645186450c343000002b645000002664500000246450c3430c343246452b645000000c343246452b645000000c343000002b6451864530645000000000000000
09110000111541515416154171541515417154151541515018154151541615417154151541715415154151501315415154161541615011154151541615416150131541515416154171541a1541a1521a1411a121
611100000524005240052420524205240052400523105211042400424004240042400424004240042310421102240022400223102211042400424004231042110724007240072400724007231072210721107215
61110000052400524005242052420524005240052310521104240042400424004240042400424004231042110224002240022310221104240042400423104211072400724007242072420b2400b2400b2310b211
191100000c3430c3432b645000002f6450000000000000000c3430c3432b64500000296450000000000000000c34300000000002b6450c34300000000002b6451864500000000000000000000000000000000000
11110000111541515416154171541a15415154171541715017154181541a1541c1541d1541a1541c1541c1501d1541f1541d1541d1501c1541d1541c1541c1501d1541f1541c1541b1541a1541a1501a1411a121
6150000011024110411105111052110411103111021110221103111041110511105213041130311302113025110241104111051110520e0410e0310e0210e0220c0310c0410c0510c05210041110311102111025
ad500000000000000000000000000c0240c0410c0210c025000000000000000000000c0240c0410c0210c02500000000000000000000070240705107021070250000000000070540705500000000000c0540c055
012800200000500005000050000500005000050000500005000050000507655000050065500005000050000500005000050000500005000050000500005000050000500005000050000000000006550065500000
61500000110241104111051110520e0410e0310e0210e022110311104111051110520c0410c0310c0210c025110241104111051110520e0410e0310e0210e0221003110041100511005210041100311002110025
4d1100000727007241072310226002241022310426004241072600724107231022600224102231002600024107260072410723109260092410923104260042410423104232072600724109260092410923109232
011100000c4331a515000002156521515215150a233000000c4331c515215652151523565235150c233245150b4331f5150000024575245152451523565235152351500000245652451523565235152351524515
4d110000072600724107231092600924109231042600424104231042210726007241092600924102260022410726007241072310926009241092310426004241042310423209260092410b2600b2410b2310b221
011100000c433215150000024575245152451524565245150c2332151524565245152356523515235151f5150b433215150000024575245152451524565245150c2332151524565245152657526515265151f515
__music__
00 04054344
00 04064344
01 04050744
00 04060744
00 04050844
00 04060744
00 48050944
00 04060944
00 04050744
02 044a4b44
00 0a424344
00 0b424344
01 0a0c4344
00 0d0e4344
00 0a0c4344
02 0b0f4344
01 10111244
00 10131444
00 10111544
00 10131644
00 10111244
00 10131444
00 10111544
02 10131744
01 18194344
00 181a4344
00 18194344
00 181b4344
00 1c1d4344
00 1c1d4344
00 181e4344
02 181f4344
01 20214344
00 22234344
00 20214344
00 24254344
00 20214344
00 22234344
00 20214344
02 26274344
01 28294344
00 2a294344
00 28294344
00 2a294344
00 28292b44
00 2a292c44
00 28292b44
02 2d2e2f44
01 30313244
00 33343244
00 30313244
00 33353644
00 30313244
00 33343244
00 30313644
02 37354e44
01 38394a44
00 38393a44
00 38493a44
02 3b493a44
01 3c3d4344
00 3e3d4344
00 3c3d4344
02 3e3f4344

