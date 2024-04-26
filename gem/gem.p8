pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- gem dredging
-- by the sailor

function _init()
	_upd=upd_menu
	_drw=drw_menu
	
	--★
	debug={}
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	
	--★
	local i
	for i=1,#debug do
		print(debug[i],2,102+(i*6),7)
	end
end
-->8
-- screens

function upd_menu()
	if btnp(🅾️) then
		ini_board()
		_upd=upd_game
		_drw=drw_game
	end
end

function drw_menu()
	cls(13)
	local t="gem"
	print(t,64-(#t*2),32,7)
	t="dredging"
	print(t,64-(#t*2),38,7)
end

function upd_game()
	upd_cursor()
end

function drw_game()
	cls(12)
	drw_bkg()
	drw_board()
	drw_cursor()
	drw_gemboard()
	drw_scoreboard()
end
-->8
-- game play

function ini_board()
	tiles={}
	cols=8
	rows=8
	size=12
	
	--cursor
	curx=0
	cury=0
	
	local i,j
	for i=0,cols-1 do
		for j=0,rows-1 do
			local c={
				id_x=i*size,
				id_y=j*size,
				revealed=false,
				hasmine=false,
				warn=0
			}
			add(tiles,c)
		end--for j
	end--for i
	
	--adding mines
	allmines=10
	
	while allmines>0 do
		local rtile=flr(1+rnd(#tiles-1))
		if not tiles[rtile].hasmine then
			tiles[rtile].hasmine=true
			allmines-=1
		end
	end
	
end--ini_board()

function drw_bkg()
	rectfill(0,117,127,127,1)
end

function drw_board()
	local t,c
	for t in all(tiles) do
		if not t.revealed then
			c=7
		end
		if t.revealed and t.hasmine then
			c=8
		elseif t.revealed then
			c=1
		end
		
		rectfill(
			2+t.id_x,
			2+t.id_y,
			t.id_x+size+2,
			t.id_y+size+2,
			c)
			
			
		rect(
			2+t.id_x,
			2+t.id_y,
			t.id_x+size+2,
			t.id_y+size+2,
			1)
			
			if t.revealed and
			not t.hasmine and
			t.warn>0 then
				print(t.warn,4+t.id_x,4+t.id_y,2)
			end
		
	end--for
end--drw_board()

function drw_cursor()
	rect(
		1+curx*size,
		1+cury*size,
		(curx*size)+size+3,
		(cury*size)+size+3,
		9)
end--drw_cursor()

function drw_gemboard()
	print("gems",106,3,13)
	rect(104,1,122,9,13)
	
	circfill(108,24,4,8)
	circfill(108,35,4,11)
	circfill(108,46,4,9)
	
	print(":3",114,22,7)
	print(":1",114,33,7)
	print(":0",114,44,7)
end

function drw_scoreboard()
	rrect(6,103,86,20,1)
	rrect(4,101,86,20,2)
	
	line(5,101,89,101,14)
	line(5,121,89,121,14)
	line(3,103,3,119,14)
	line(91,103,91,119,14)
	
	pset(4,102,14)
	pset(90,102,14)
	pset(90,120,14)
	pset(4,120,14)
	
	rectfill(5,103,7,105,14)
	pset(7,104,2)
	pset(7,105,2)
	pset(6,105,2)
	
	rectfill(5,117,7,119,14)
	pset(7,118,2)
	pset(7,117,2)
	pset(6,117,2)
	
	rectfill(87,117,89,119,14)
	pset(87,117,2)
	pset(88,117,2)
	pset(87,118,2)
	
	rectfill(87,103,89,105,14)
	pset(87,104,2)
	pset(87,105,2)
	pset(88,105,2)
	
	--score / points
	print("score 2345",7,108,1)
	print("score 2345",7,107,1)
	print("score 2345",7,106,10)
	pset(7,110,9)
	pset(12,110,9)
	pset(15,110,9)
	pset(19,110,9)
	pset(21,110,9)
	pset(23,110,9)
	
	--time
	spr(1,65,105)
	spr(1,65,104)
	print("42",74,108,1)
	print("42",74,107,1)
	print("42",74,106,7)
	
	--flags
	local f
	for f=1,10 do
		spr(2,13+(f*6),115)
	end
end

function upd_cursor()
	movecursor()
	opentile()
end--upd_cursor()

function opentile()
	local t
	for t=1,#tiles do
		if (btnp(❎)) then
			if (curx*size==tiles[t].id_x
			and cury*size==tiles[t].id_y 
			and not tiles[t].revealed) then
				tiles[t].revealed=true
				checkaround(t)
			end
			
		end--if
	end
end--opentile

function checkaround(_t)
	local u,d,l,r,tl,tr,bl,br
	
	--above _t
	if tiles[_t].id_y~=0 then
		u=_t-1
	else
		u=_t
	end
	if not tiles[u].revealed and
	not tiles[u].hasmine then
		tiles[u].revealed=true
		checkaround2(u)
	elseif tiles[u].hasmine then
		tiles[_t].warn+=1
	end
	
	--below _t
	if tiles[_t].id_y~=84 then
		d=_t+1
	else
		d=_t
	end
	if not tiles[d].revealed and
	not tiles[d].hasmine then
		tiles[d].revealed=true
		checkaround2(d)
	elseif tiles[d].hasmine then
		tiles[_t].warn+=1
	end
	
	--left of _t
	if tiles[_t].id_x~=0 then
		l=_t-8
	else
		l=_t
	end
	if not tiles[l].revealed and
	not tiles[l].hasmine then
		tiles[l].revealed=true
		checkaround2(l)
	elseif tiles[l].hasmine then
		tiles[_t].warn+=1
	end
	
	--right of _t
	if tiles[_t].id_x~=84 then
		r=_t+8
	else
		r=_t
	end
	if not tiles[r].revealed and
	not tiles[r].hasmine then
		tiles[r].revealed=true
		checkaround2(r)
	elseif tiles[r].hasmine then
		tiles[_t].warn+=1
	end
	
	
	--topleft of _t
	if tiles[_t].id_y~=0 and
	tiles[_t].id_x~=0 then
		tl=_t-9
	else
		tl=_t
	end
	if not tiles[tl].revealed and
	not tiles[tl].hasmine then
		tiles[tl].revealed=true
		checkaround2(tl)
	elseif tiles[tl].hasmine then
		tiles[_t].warn+=1
	end
	
	--topright of _t
	if tiles[_t].id_y~=0 and
	tiles[_t].id_x~=84 then
		tr=_t+7
	else
		tr=_t
	end
	if not tiles[tr].revealed and
	not tiles[tr].hasmine then
		tiles[tr].revealed=true
		checkaround2(tr)
	elseif tiles[tr].hasmine then
		tiles[_t].warn+=1
	end
	
	--btmleft of _t
	if tiles[_t].id_y~=84 and
	tiles[_t].id_x~=0 then
		bl=_t-7
	else
		bl=_t
	end
	if not tiles[bl].revealed and
	not tiles[bl].hasmine then
		tiles[bl].revealed=true
		checkaround2(bl)
	elseif tiles[bl].hasmine then
		tiles[_t].warn+=1
	end
	
	--btmright of _t
	if tiles[_t].id_y~=84 and
	tiles[_t].id_x~=84 then
		br=_t+9
	else
		br=_t
	end
	if not tiles[br].revealed and
	not tiles[br].hasmine then
		tiles[br].revealed=true
		checkaround2(br)
	elseif tiles[br].hasmine then
		tiles[_t].warn+=1
	end
end--checkaround()

function checkaround2(_t)
	local u,d,l,r,tl,tr,bl,br
	
	--above _t
	if tiles[_t].id_y~=0 then
		u=_t-1
	else
		u=_t
	end
	if tiles[u].hasmine then
		tiles[_t].warn+=1
	end
	
	--below _t
	if tiles[_t].id_y~=84 then
		d=_t+1
	else
		d=_t
	end
	if tiles[d].hasmine then
		tiles[_t].warn+=1
	end
	
	--left of _t
	if tiles[_t].id_x~=0 then
		l=_t-8
	else
		l=_t
	end
	if tiles[l].hasmine then
		tiles[_t].warn+=1
	end
	
	--right of _t
	if tiles[_t].id_x~=84 then
		r=_t+8
	else
		r=_t
	end
	if tiles[r].hasmine then
		tiles[_t].warn+=1
	end
	
	
	--topleft of _t
	if tiles[_t].id_y~=0 and
	tiles[_t].id_x~=0 then
		tl=_t-9
	else
		tl=_t
	end
	if tiles[tl].hasmine then
		tiles[_t].warn+=1
	end
	
	--topright of _t
	if tiles[_t].id_y~=0 and
	tiles[_t].id_x~=84 then
		tr=_t+7
	else
		tr=_t
	end
	if tiles[tr].hasmine then
		tiles[_t].warn+=1
	end
	
	--btmleft of _t
	if tiles[_t].id_y~=84 and
	tiles[_t].id_x~=0 then
		bl=_t-7
	else
		bl=_t
	end
	if tiles[bl].hasmine then
		tiles[_t].warn+=1
	end
	
	--btmright of _t
	if tiles[_t].id_y~=84 and
	tiles[_t].id_x~=84 then
		br=_t+9
	else
		br=_t
	end
	if tiles[br].hasmine then
		tiles[_t].warn+=1
	end
end--checkaround2()


function movecursor()
	if btnp(➡️) then
		if curx<cols-1 then
			curx+=1
		else
			curx=0
		end
	end
	if btnp(⬅️) then
		if curx>0 then
			curx-=1
		else
			curx=cols-1
		end
	end
	if btnp(⬆️) then
		if cury>0 then
			cury-=1
		else
			cury=rows-1
		end
	end
	if btnp(⬇️) then
		if cury<rows-1 then
			cury+=1
		else
			cury=0
		end
	end
end--movecursor()
-->8
-- tools

function rrect(_x,_y,_w,_h,_c)
	rectfill(_x-1,_y,_x+_w+1,_y+_h,_c)
	rectfill(_x,_y-1,_x+_w,_y+_h+1,_c)
	rectfill(_x-2,_y+1,_x+_w+2,_y+_h-1,_c)
end
__gfx__
0000000000760000c777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007776000c787000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070061111600c770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700061711600c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700060170700c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600107000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000167771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
