pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--pomo pomo
--the sailor

function _init()
	states={"timer","break","done"}
	state_cnt=1
	state=states[state_cnt]
	tmrbegin=true
	ticks=0
	tsecs=55
	tmins=0
	settime=1
	chunks=0
end

function _update60()
	if state=="timer" then
		upd_timer()
	elseif state=="break" then
		upd_break()
	else
		upd_done()
	end
end

function _draw()
	if state=="timer" then
		drw_timer()
	elseif state=="break" then
		drw_break()
	else
		drw_done()
	end
end
-->8
--tools

function cprint(_s,_x,_y,_c)
	print(_s,_x/2-(#_s*2),_y,_c)
end
-->8
--updates

function upd_timer()
	if tmrbegin then
		if ticks>=59 then
			upd_secs()
			ticks=0
		else
			ticks+=1
		end
	end
end

function upd_secs()
	if tsecs>=59 then
		tsecs=0
		if tmins>=settime-1 then
			tsecs=0
			tmins=0
			chunks+=1
			tmrbegin=false
			state="break"
		else
			tmins+=1
		end
	else
		tsecs+=1
	end
end

function upd_break()
	
end

function upd_done()
	
end
-->8
--draws

function drw_logo(_x,_y)
	cprint("pomo pomo",_x,_y,13)
end

function drw_clock(_x,_y)
		local txt
	if tsecs<10 then
		txt="0"..tostr(tsecs)
	else
		txt=tostr(tsecs)
	end
	
	local txt2
	if tmins<10 then
		txt2="0"..tostr(tmins)
	else
		txt2=tostr(tmins)
	end
	
	cprint(txt2..":"..txt,_x,_y,1)
end

function drw_chunks(_x,_y)
	for i=1,4 do
		circ(_x+((i-1)*12),_y,3,13)
	end
	for i=1,chunks do
		circfill(_x+((i-1)*12),_y,1,1)
	end
end

function drw_timer()
	cls(6)
	
	drw_logo(128,32)
	drw_clock(128,44) 
	drw_chunks(44,64)
end

function drw_break()
	cls(6)
	
	drw_logo(128,32)
	drw_clock(128,44) 
	
end

function drw_done()
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
