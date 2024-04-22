pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- gem dredging
-- by the sailor

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

function upd_menu()
	if btnp(🅾️) then
		ini_board()
		_upd=upd_game
		_drw=drw_game
	end
end

function drw_menu()
	cls(12)
	local t="gem"
	print(t,64-(#t*2),32,7)
	t="dredging"
	print(t,64-(#t*2),38,7)
end

function upd_game()
	
end

function drw_game()
	cls(12)
	drw_board()
end
-->8
-- game play

function ini_board()
	tiles={}
	cols=8
	rows=8
	csize=12
	
	local i,j
	for i=0,cols-1 do
		for j=0,rows-1 do
			local c={
				id_x=i*csize,
				id_y=j*csize,
				revealed=false,
				hasmine=false,
				warn=0
			}
			add(tiles,c)
		end--for j
	end--for i
	
	
	--add mines
	mines=10
	
	while mines>0 do
		local r=flr(rnd(#tiles))+1
		if (tiles[r].hasmine==false) then
			tiles[r].hasmine=true
			mines-=1
		end--if
	end--for
end--ini_board()

function drw_board()
	local c
	for c=1,#tiles do
		rect(
			2+tiles[c].id_x,
			2+tiles[c].id_y,
			tiles[c].id_x+csize+2,
			tiles[c].id_y+csize+2,
			7)
	end--for
end--drw-board()
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
