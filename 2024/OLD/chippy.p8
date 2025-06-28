pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--main

function _init()
	_upd=upd_menu
	_drw=drw_menu
end

function _update60()
	_upd()
end

function _draw()
	_drw()
end
-->8
-- screens

function drw_menu()
	cls(12)
	cprint("chippy",54,7)
	cprint("press 🅾️",72,1)
end

function upd_menu()
	if btnp(🅾️) then
		ini_game()
		
		_upd=upd_game
		_drw=drw_game
	end
end

function ini_game()
	grav=0.26
	
	plr={
		x=64,
		y=128-16,
		w=16,
		h=16,
		xspd=0.25,
		yspd=5,
		onground=false,
		ofrc=1.1,
		frc=0,
		dx=0,
		dy=0
	}
end

function upd_game()
	plr.dy+=grav
	
	if btn(⬅️) then
		if plr.dx>0 then
			plr.dx=0
		end
		plr.dx-=plr.xspd
	end
	
	if btn(➡️) then
		if plr.dx<0 then
			plr.dx=0
		end
		plr.dx+=plr.xspd
	end
	
	--jumping
	if btnp(🅾️) 
	and plr.onground then
		plr.dy-=plr.yspd
		plr.onground=false
	end
	
	--friction
	if plr.onground==false then
		plr.frc=1.15
	else
		plr.frc=plr.ofrc
	end
	
	plr.dx/=plr.frc
	
	--update pos
	plr.x+=plr.dx
	plr.y+=plr.dy
	
	plr.x=mid(0,plr.x,127-16)
	
	if plr.y+plr.h>127 then
		plr.dy=0
		plr.y=127-plr.h
		plr.onground=true
	end
end

function drw_game()
	cls()
	
	rectfill(plr.x,plr.y,
										plr.x+plr.w,
										plr.y+plr.h,
										8)
end
-->8
-- tools

function cprint(_t,_y,_c)
	print(_t,64-(#_t*2),_y,_c)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
