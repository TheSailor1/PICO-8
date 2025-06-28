pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- notes

-- ★
-- player can change direction
-- but not backwards?
-->8
-- main

function _init()
	--★★
	debug={}
	
	ini_game()
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	
	--★★
	if #debug>0 then
		for i=1,#debug do
			print(debug[i],2,2+(i*6),8)
		end
	end
end

function ini_game()
	ini_plr()
	_upd=upd_game
	_drw=drw_game
end
-->8
-- updates

function upd_menu()
	
end

function upd_game()
	upd_plr()
end
-->8
-- draws

function drw_menu()
	cls(2)
	cprint("hey there!",32,6)
end

function drw_game()
	cls(1)
	drw_plr()
end
-->8
-- tools

function cprint(_s,_y,_c)
	print(_s,64-(#_s*2),_y,_c)
end

function rect2(_fun,_x,_y,_w,_h,_c)
	_fun(_x,_y,_x+_w,_y+_h,_c)
end
-->8
-- player

function ini_plr()
	plr={
		x=32,
		y=32,
		w=8,
		h=8,
		spd=8,
		dx=0,
		dy=0
	}
	
	hitwall=false
end

function upd_plr()
	if plr.x+plr.w>=127 then
		wall_r=true
		wall_l=false
		plr.dx=0
	elseif plr.x<=0 then
		wall_r=false
		wall_l=true
		plr.dx=0
	end
	
	if plr.y+plr.h>=127 then
		wall_t=false
		wall_b=true
		plr.dy=0
	elseif plr.y<=0 then
		wall_t=true
		wall_b=false
		plr.dy=0
	end
	
	if plr.dx==0 then
		hitwall=true
	end
	debug[1]=tostr(wall_l)
	debug[2]=tostr(wall_r)
	
	if btnp(➡️) and 
	plr.dy==0 and
	not wall_r then
		plr.dx=1
		plr.dy=0
		wall_l=true
	end
	if btnp(⬅️) and 
	plr.dy==0 and 
	not wall_l then
		plr.dx=-1
		plr.dy=0
		wall_r=true
	end
	if btnp(⬆️) and 
	plr.dx==0 and
	not wall_t then
		plr.dx=0
		plr.dy=-1
	end
	if btnp(⬇️) and 
	plr.dx==0 and
	not wall_b then
		plr.dx=0
		plr.dy=1
	end
	
	
	plr.x+=(plr.dx*plr.spd)
	plr.y+=(plr.dy*plr.spd)
end

function drw_plr()
	rect2(rectfill,plr.x,plr.y,plr.w,plr.h,7)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
