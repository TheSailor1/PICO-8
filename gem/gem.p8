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
		print(debug[i],2,2+(i*6),7)
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
	for t in all(tiles) do
		if (btnp(❎)) then
			if (curx*size==t.id_x
			and cury*size==t.id_y 
			and not t.revealed) then
				t.revealed=true
			end
		end--if
	end
end--opentile

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
