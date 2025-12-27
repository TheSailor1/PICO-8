pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	floor=127
	grav=0.25
	tmr=0
	
	plr={
		w=15,
		h=15,
		x=64,
		y=64,
		delx=0,
		dely=0,
		acc=1,
		fric=0.7,
		jumph=4,
		grounded=false
	}
	
	ini_nuts()
	
	_upd=upd_game
	_drw=drw_game
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	?#nuts,2,2,7
	
	if #stack>0 then
		?stack[#stack].y,2,8,7
	end
end
-->8
--draws
function drw_game()
	cls(1)
	
	drw_plr()
	drw_stack()
	drw_nuts()
end

function drw_plr()
	--plr
	rectfill(plr.x,plr.y,
	plr.x+plr.w,plr.y+plr.h,8)
end

function drw_nuts()
	for n in all(nuts) do
		n:drw()
	end
end
-->8
--updates
function upd_game()
	if tmr>100 then
		mak_nut()
		tmr=0
	else
		tmr+=1
	end
	
	if #stack>0 then
		for i=1,#stack do
			stack[i].x=plr.x+2
		end
	end
	
	--grav
	upd_plrmove()
	upd_nuts()
end

function upd_plrmove()
		if plr.y+plr.h<floor then
		plr.dely+=grav
		plr.fric=0.54
	else
		plr.dely=0 
		plr.fric=0.7
		plr.y=floor-plr.h 
		plr.grounded=true
	end
	if plr.x+plr.w>127 then
		plr.delx=0
		plr.x=126-plr.w
	elseif plr.x<0 then
		plr.delx=0
		plr.x=1
	end
	
	
	--inputs
	if btn(⬅️) then
		plr.delx-=plr.acc
	end
	if btn(➡️) then
		plr.delx+=plr.acc
	end
	if btnp(❎) then
		plr.dely-=plr.jumph
		plr.grounded=false
	end
	
	--friction
	plr.delx*=plr.fric
	
	--update pos
	plr.x+=plr.delx
	plr.y+=plr.dely
end

function upd_nuts()
	if #nuts>0 then
	for i=#nuts,1,-1 do
		nuts[i].dely+=nuts[i].fallspd
		
		if nuts[i].y+nuts[i].h>plr.y and
					nuts[i].y<plr.y+plr.h and
					nuts[i].x+nuts[i].w>plr.x and
					nuts[i].x<plr.x+plr.w then
						del(nuts,nuts[i])
					end
					
		if nuts[i].y>=floor then
			del(nuts,nuts[i])
		end
		
		nuts[i].y+=nuts[i].dely
	end
	end
end
-->8
--nuts
function ini_nuts()
	nuts={}
	stack={}
	mak_nut()
end

function mak_nut()
	add(nuts,{
		w=7,
		h=7,
		x=1+rnd(126),
		y=0,
		dely=0,
		fallspd=0.01, --smaller than grav
		caught=false,
		
		drw=function(self)
			rectfill(self.x,self.y,
				self.x+self.w,
				self.y+self.h,
				4)
		end
	})
end

function drw_stack()
	if #stack>0 then
		for i=1,#stack do
			rectfill(
				stack[i].x,
				stack[i].y,
				stack[i].x+7,
				stack[i].y+7,
				5
			)
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
