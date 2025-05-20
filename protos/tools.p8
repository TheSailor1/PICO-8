pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	poke(0x5f2d, 1)
	
	ship={}
	ship.x=64
	ship.y=64
	ship.r=4
	ship.c=13
	
	gun={}
	gun.x=64
	gun.y=64
	gun.r=1
	gun.c=8
	
	angle=0
	radius=10
	
	starty=0 
	endy=64
	
	t=0
	
	col=7
	mouse={x=0,y=0}
	center={x=64,y=64}
	r=0
end

function _update60()
	if t>=1 then
		t=1
	else
		t+=0.2
	end
	
	mouse={x=stat(32),y=stat(33)}
	
	if btn(➡️) then
		angle+=0.01
		if angle>1 then angle=0 end
	end
	if btn(⬅️) then
		angle-=0.01
		if angle>1 then angle=0 end
	end
	
	x=gun.x+radius*cos(angle)
	y=gun.y+radius*sin(angle)
end


function _draw()
	cls()
	circ(ship.x,lazylerp(5,64,0),ship.r,ship.c)
	circ(x,y,gun.r,gun.c)
	
	
	if btnp(🅾️) then
		r=rndrange(-10,10)
	end
	?r,2,2,8
	
	local d=dist(mouse,center)
	if d<10 then
		col=8
	else
		col=7
	end
	circfill(mouse.x,mouse.y,1,col)
end
-->8
--tools


-- takes a value that sits in
-- a number range and then
-- converts that to a value
-- from 0 - 1 (0.22, 0.67)
-- minimum [a] - max [b]
function norm(val,a,b)
	return (val-a)/(b-a)
end

-- returns a value in a range
-- that the norm val points to
function lerp(norm,a,b)
	return (b-a)*norm+a
end

function lazylerp(n,a,b)
	return a+(b-a)/n
end

-- distance between 2 points
-- params uses tables
function pythag(a,b)
	return sqrt(a^2+b^2)
end

function dist(a,b)
	return sqrt((a.x-b.x)^2+(a.y-b.y)^2)
end

-- returns a random number within
-- a given range(a,b)
function rndrange(a,b)
	return a+rnd()*(b-a)
end

-- returns a random integer
function rndint(a,b)
	return flr(a+rnd()*(b-a+1))
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
