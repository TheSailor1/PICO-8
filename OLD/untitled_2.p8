pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--minesweep--
--
-- gamestates=menu,game,win,lose


function _init()
	--globals
	t=0
	
	gstate="menu"
end


function _update()
	if (gstate=="menu") then
		upd_menu()
	elseif (gstate=="game") then
		upd_game()
	elseif (gstate=="gameover") then
		upd_gameover()
	end
end


function _draw()
	if (gstate=="menu") then
		drw_menu()
	elseif (gstate=="game") then
		drw_game()
	elseif (gstate=="gameover") then
		drw_gameover()
	end
end
-->8
--screens--

function drw_menu()
	cls()
	local logo="minesweeper"
	print(logo,65-(#logo*2),20,8)
end

function upd_menu()
	t+=1
	
	if (btnp(🅾️)) then
		ini_game()
	end
end

function ini_game()
	--globals
	cols=8
	rows=8
	size_w=flr(100/cols)
	size_h=flr(100/rows)
	cells={}
	select_x=0
	select_y=0
	select_s=1
	for i=0,cols-1 do
		for j=0,rows-1 do
			local c={
				index_x=i*size_w,
				index_y=j*size_h,
				revealed=false,
				hasmine=false,
				warn=0
			}
			add(cells,c)
		end--for j
	end--for i
	
	--add mines
	mines=10
	local m=false
	while mines>0 do
		local r=flr(rnd(#cells))+1
		if (cells[r].hasmine==false) then
			cells[r].hasmine=true
			mines-=1
		end--if
	end--for
	
	gstate="game"
end

function drw_game()
	cls()
	
	--playfield
	rectfill(0,0,cols*size_w,rows*size_h,5)
	
	for i=1,#cells do
		if (cells[i].revealed) then
			if (cells[i].hasmine) then
			rectfill(
				cells[i].index_x+1,
				cells[i].index_y+1,
				cells[i].index_x+size_w-1,
				cells[i].index_y+size_h-1,
				8)
			else
			rectfill(
				cells[i].index_x+1,
				cells[i].index_y+1,
				cells[i].index_x+size_w-1,
				cells[i].index_y+size_h-1,
				13)
			end
		end--revealed
		
		rect(
			cells[i].index_x,
			cells[i].index_y,
			cells[i].index_x+size_w,
			cells[i].index_y+size_h,
			1)
	end--for
	
	--mine hints
	local c
	for c=1,#cells do
		if (cells[c].warn>0) then
			print(
				cells[c].warn,
				cells[c].index_x+5,
				cells[c].index_y+4,
				7)
			end--if
	end--for
	
	--cursor
	local select_s=1
	local oy=0
	if (btn(🅾️)) then
		select_s=3
		oy=4
	end
	pal(9,1)
	pal(10,1)
	spr(
		select_s,
		select_x*size_w+5,
		select_y*size_h+10-oy,
		2,2)
	pal()
	spr(
		select_s,
		select_x*size_w+3,
		select_y*size_h+8-oy,
		2,2)
		
end--drw_game

function upd_game()
	t+=1
	
	if (btnp(➡️)) then
		sfx(0)
		if (select_x<cols-1) then
			select_x+=1
		else
			select_x=0
		end
	end
	if (btnp(⬅️)) then
		sfx(0)
		if (select_x>0) then
			select_x-=1
		else
			select_x=cols-1
		end
	end
	
	if (btnp(⬇️)) then
		sfx(0)
		if (select_y<rows-1) then
			select_y+=1
		else
			select_y=0
		end
	end
	
	if (btnp(⬆️)) then
		sfx(0)
		if (select_y>0) then
			select_y-=1
		else
			select_y=rows-1
		end
	end
	
	--select square
	if (btnp(🅾️)) then
		sfx(1)
		local i
		id_x=select_x*size_w
		id_y=select_y*size_h
		
		for i=#cells,1,-1 do
			--check under cursor
			if (cells[i].index_x==id_x
			and cells[i].index_y==id_y
			and cells[i].revealed==false) then
				cells[i].revealed=true
				if (cells[i].hasmine) then
					sfx(2)
					_draw()
					gstate="gameover"
				else
					checkaround(cells[i],id_x,id_y)
				end--if
			end--check under cursor
		end--for
	end--btnp
end--upd_game

function checkaround(_cell,_x,_y)
			local _c
			for _c=1,#cells do
		--check left of cursor
		if (cells[_c].index_x==_x-size_w
		and cells[_c].index_y==_y
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if left cursor
		
		--check right of cursor
		if (cells[_c].index_x==_x+size_w
		and cells[_c].index_y==_y
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if right cursor
		
		--check above of cursor
		if (cells[_c].index_x==_x
		and cells[_c].index_y==_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if above cursor
		
		--check below of cursor
		if (cells[_c].index_x==_x
		and cells[_c].index_y==_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if below cursor
		
		--check top/l of cursor
		if (cells[_c].index_x==_x-size_w
		and cells[_c].index_y==_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if top/l cursor
		
		--check top/r of cursor
		if (cells[_c].index_x==_x+size_w
		and cells[_c].index_y==_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if top/r cursor
		
		--check btm/l of cursor
		if (cells[_c].index_x==_x-size_w
		and cells[_c].index_y==_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if above cursor
		
		--check btm/r of cursor
		if (cells[_c].index_x==_x+size_w
		and cells[_c].index_y==_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==false) then
				cells[_c].revealed=true
				checkmines(cells[_c])
			else
				_cell.warn+=1
			end--if
		end--if btm/r cursor

	end--for
end--checkaround()

function checkmines(cell)
	local _c
	for _c=1,#cells do
		--check btm/r of cursor
		if (cells[_c].index_x==cell.index_x+size_w
		and cells[_c].index_y==cell.index_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if btm/r cursor
		
		--check btm/l of cursor
		if (cells[_c].index_x==cell.index_x-size_w
		and cells[_c].index_y==cell.index_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if btm/l cursor
		
		--check btm of cursor
		if (cells[_c].index_x==cell.index_x
		and cells[_c].index_y==cell.index_y+size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if btm cursor
		
		--check left of cursor
		if (cells[_c].index_x==cell.index_x-size_w
		and cells[_c].index_y==cell.index_y
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if left cursor
		
		--check right of cursor
		if (cells[_c].index_x==cell.index_x+size_w
		and cells[_c].index_y==cell.index_y
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if right cursor
		
		--check top/l of cursor
		if (cells[_c].index_x==cell.index_x-size_w
		and cells[_c].index_y==cell.index_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if top/l cursor
		
		--check top/r of cursor
		if (cells[_c].index_x==cell.index_x+size_w
		and cells[_c].index_y==cell.index_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if top/r cursor
		
		--check top of cursor
		if (cells[_c].index_x==cell.index_x
		and cells[_c].index_y==cell.index_y-size_h
		and cells[_c].revealed==false) then
			if (cells[_c].hasmine==true) then
				cell.warn+=1
			end--if
		end--if top cursor

	end--for
end--checkmines()

function upd_gameover()
	if (btnp(🅾️)) then
		_init()
	end
end

function drw_gameover()
	print(
		"\^t\^wgame over!",
		10,
		30,
		8)
end
__gfx__
00000000000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000009aaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000009aaa90000000000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000009aaa9999999900009aaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000009a999aaa9aaa90009aaa9999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000009aaa9aaa9aaa90009aaa9aa9aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000999aaaaaaaaaaa90009aaa9aa9aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009999aaaaaaaaaaa90099aaaaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009999aaa99a99aaa90999aaaaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009999aaaaaaaaaaa90999aaaaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa9aaaaaaaaaaa90999aaaaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aaaaaaaaaaaaaa9099aaaaaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaaaaaaaaaa99099aaaaaaaaa99000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000999999aaaa999000999999aa9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999aaaaaaa900000999aaa99900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000009999999900000000999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
910100001e510165310b530205371c5001b5000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
190300003213028431001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
01050000386502e6503a0233d023226231f6101d61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
