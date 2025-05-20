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
--draws
function drw_menu()
	cls()
	cprint("ch1ppy",22,7)
	cprint("press 🅾️/z",34,1)
end

function drw_game()
	cls(2)
	
	rectfill(plr.x,plr.y,
										plr.x+plr.w,
										plr.y+plr.h,
										plr.c)
	
	print(plr.jbuf,2,2,8)
	
end
-->8
--updates
function upd_menu()
	if btnp(4) then
		mk_plr()
		_upd=upd_game
		_drw=drw_game
	end
end

function upd_game()
	upd_plr()
end

function upd_plr()
	if plr.x<0 then plr.x=0 end
	if plr.x+plr.w>127 then plr.x=127-plr.w end
	
	if plr.y+plr.h>=plr.floor then
		plr.yvel=0
		plr.y=plr.floor-plr.h
		if plr.jbuf==1 then
			plr.yvel=plr.jmp
			plr.jbuf=0
		end
	else
		plr.yvel+=plr.grav
	end
	
	if btn(0) and plr.x>0 then
		plr.xvel-=plr.spd
	elseif btn(1) and plr.x+plr.w<127 then
		plr.xvel+=plr.spd
	end
	
	if btnp(4) then
		if plr.yvel==0 then
			plr.yvel=plr.jmp
		else
			plr.jbuf=1
		end
	end 
	
	--friction
	if plr.yvel!=0 then
		plr.xvel*=0.55
	else
		plr.xvel*=0.7
	end
	
	plr.y+=plr.yvel
	plr.x+=plr.xvel
end


-->8
--tools
function cprint(str,ypos,col)
	local s=str
	print(s,64-(#s*2),ypos,col)
end

function mk_plr()
	plr={
		x=32,
		y=100,
		floor=120,
		w=12,
		h=15,
		c=7,
		spd=1,
		xvel=0,
		yvel=0,
		grav=0.25,
		jmp=-4,
		jbuf=0
	}
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
