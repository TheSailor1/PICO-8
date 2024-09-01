pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	t1,t2=0,0
end

function _update60()
	t1-=1/7500
	t2-=1/190
end

function _draw()
	cls(0)
	for i=-12,12 do
		for j=-12,12 do
			ang=atan2(i,j)
			dist=sqrt(i*i+j*j)
			r=1.5+1.5*sin(dist/12+t2)
			h=10*r
			
			circfill(
				64+8*dist*cos(ang+t1*.3),
				64+8*dist*sin(ang+t1*.3)-h,
				r,1
			)
		end
		
		print("\^t\^wget to the",24,40,9)
		print("\^t\^wrockaaatt",28,54,9)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
