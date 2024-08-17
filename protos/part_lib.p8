pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	ini_game()
	_upd=upd_game
	_drw=drw_game
end

function _update60()
	_upd()
end

function _draw()
	_drw()
end
-->8
-- screens

function ini_game()
	ini_parts()
	t=0
end

function upd_game()
	t+=1
	
	--smoke
	if btnp(🅾️) then
		mak_smoke(
			64,126,{6,13,5,1},3,50)
	end
	
	upd_smoke()
end

function drw_game()
	cls()
	drw_smoke()
	
	--★
	?#smoke,2,2,8
end
-->8
-- particles

function ini_parts()
	smoke={}
	mak_smoke(
			64,126,{6,13,5,1},3,50)
end


function mak_smoke(_x,_y,_ctbl,_r,_n)
	for i=1,_n do
		local _maxage=200
		local _minage=rnd(50)
		local _rndy=rnd(5)
		add(smoke,{
			x=_x,
			y=_y-_rndy,
			c=_ctbl,
			maxsiz=_r,
			r=rnd(_r),
			maxage=_minage+rnd(_maxage),
			age=0,
			vx=-0.1+(rnd(1)-0.4),
			vy=-0.4+rnd(0.2)
		})
	end
	
	--flash
	add(smoke,{
		x=_x,
		y=_y-6,
		c=_ctbl,
		maxsize=10,
		r=10,
		maxage=40,
		age=0,
		vx=0,
		vy=0
	})
end

function drw_smoke()
	local col=0
	for p in all(smoke) do
		if p.age>100 then
			col=4
		elseif p.age>80 then
			col=3
		elseif p.age>30 then
			col=2
		else
			col=1
		end
		circfill(p.x,p.y,p.r,p.c[col])
	end
end

function upd_smoke()
	for p in all(smoke) do
		if p.age<p.maxage then
			p.r-=0.02
			p.age+=5
			p.x+=p.vx
			p.y+=p.vy
		else
			del(smoke,p)
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
