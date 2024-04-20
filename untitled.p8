pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	
	t=0
	
	choices={"bear","hunter","ninja"}
	cols={11,12,8}
	coltab={
		{11,3,1},
		{12,13,1},
		{8,2,1}
	}
	
	pos={
		{30,50,1},
		{50,30,4},
		{45,70,10}
	}
	
	sel=1
	curx=pos[sel][1]
	cury=pos[sel][2]
	curr=pos[sel][3]
	curx2=pos[sel+1][1]
	cury2=pos[sel+1][2]
	curr2=pos[sel+1][3]
	curx3=pos[sel+2][1]
	cury3=pos[sel+2][2]
	curr3=pos[sel+2][3]
end

function _update60()
	
	t+=1
	
	if btnp(⬅️) then
		if sel<3 then
			sel+=1
		else
			sel=1
		end
	end
	
	if btnp(➡️) then
		if sel>1 then
			sel-=1
		else
			sel=3
		end
	end
	
	if sel==1 then
		tx=pos[1][1]
		ty=pos[1][2]
		rd1=pos[1][3]
		tx2=pos[2][1]
		ty2=pos[2][2]
		rd2=pos[2][3]
		tx3=pos[3][1]
		ty3=pos[3][2]
		rd3=pos[3][3]
	elseif sel==2 then
		tx=pos[2][1]
		ty=pos[2][2]
		rd1=pos[2][3]
		tx2=pos[3][1]
		ty2=pos[3][2]
		rd2=pos[3][3]
		tx3=pos[1][1]
		ty3=pos[1][2]
		rd3=pos[1][3]
	else
		tx=pos[3][1]
		ty=pos[3][2]
		rd1=pos[3][3]
		tx2=pos[1][1]
		ty2=pos[1][2]
		rd2=pos[1][3]
		tx3=pos[2][1]
		ty3=pos[2][2]
		rd3=pos[2][3]
	end
	
	curx+=(tx-curx)/12
	cury+=(ty-cury)/12
	curr+=(rd1-curr)/12
	curx2+=(tx2-curx2)/12
	cury2+=(ty2-cury2)/12
	curr2+=(rd2-curr2)/12
	curx3+=(tx3-curx3)/12
	cury3+=(ty3-cury3)/12
	curr3+=(rd3-curr3)/12
end

function _draw()
	cls()
	
	local yoff,yoff2,yoff3=0,0,0
	
	if (pos[3][2]-cury)<10 
	and (pos[3][1]-curx)<0.5 then
		curx=pos[3][1]
		yoff=sin(t/60)
	elseif (pos[3][2]-cury2)<10
	and (pos[3][1]-curx2)<0.5 then
		curx2=pos[3][1]
		yoff2=sin(t/60)
	elseif (pos[3][2]-cury3)<10
	and (pos[3][1]-curx3)<0.5 then
		curx3=pos[3][1]
		yoff3=sin(t/60)
	end
	
	circfill(curx,cury+yoff,curr,8)
	circfill(curx2,cury2+yoff2,curr2,12)
	circfill(curx3,cury3+yoff3,curr3,11)
	
	circ(pos[3][1],pos[3][2],13,7)
	
	print(choices[sel],pos[3][1]+20,pos[3][2],cols[sel])
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
