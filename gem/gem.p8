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
	drw_board()
	drw_cursor()
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
	end
end--checkaround()

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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
