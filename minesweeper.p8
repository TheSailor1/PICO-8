pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- crypts
-- by the sailor
--
--
-- storyline/theme
-- -------------------------
-- graverobbers/socery
-- you're a graverobber.
-- each tile is a "grave" which
-- could contain gold or a trap
-- trap warnings are shown by
-- bone symbols -- 
--  bone(1) // hand holding
--             up fingers?? 
--  skull(2)
--  ribs(3+)
-- flags could be curses or
-- protection spells
-- --------------------------
-- shop or unlock different
-- crypt opening tools
-- - allows different animations
--
--
-- goals
-- ------------
-- [] save highscore
-- [] write a highscore file
-- [] add a score for each
--    tile revealed
--    opening a large section
--    gives lots of points
--    (chain multiplier)
-- [] win screen shows current
--    score points
-- [] be able to plant flags
-- [] extra points for successful
--    flags planted on mines
-- [] replace number warnings
--    with sprites
-- [] particle effect when opening
--    a tile / crypt

function _init()
	cheat=true
	
	--globals
	t=0
	hiscore=0
	
	gstate="menu"
end


function _update()
	if (gstate=="menu") then
		upd_menu()
	elseif (gstate=="game") then
		upd_game()
	elseif (gstate=="gameover") then
		upd_gameover()
	elseif (gstate=="win") then
		upd_gamewin()
	end
end


function _draw()
	if (gstate=="menu") then
		drw_menu()
	elseif (gstate=="game") then
		drw_game()
	elseif (gstate=="gameover") then
		drw_gameover()
	elseif (gstate=="win") then
		drw_gamewin()
	end
end
-->8
--screens--

function drw_menu()
	cls()
	local logo="minesweeper"
	print(logo,65-(#logo*2),20,8)
	local t="press 🅾️ to start"
	print(t,65-(#t*2),90,13)
end

function upd_menu()
	t+=1
	
	if (btnp(🅾️)) then
		ini_game()
	end
end

function ini_game()
	
	debug={}
	
	--globals
	gamet=0
	gamesec=0
	score=0
	screentmr=false
	screencnt=0
	hitmine=false
	winscore=0
	points_n=10
	points_l=50
	shake=0
	camx=0
	camy=0
	
	maxloot=10
	treasures={43,44,45}
	graves={5,9,11,13}
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
			local loot
			if (rnd()<0.09 
			and maxloot>0) then
				loot=rnd(treasures)
				maxloot-=1
			else
				loot=0
			end
			local c={
				index_x=i*size_w,
				index_y=j*size_h,
				revealed=false,
				hasmine=false,
				warn=0,
				sp=rnd(graves),
				prz=loot,
				prz_x=i*size_w,
				prz_y=i*size_h
			}
			add(cells,c)
		end--for j
	end--for i
	
	--add mines
	totmines=10
	mines=totmines
	local m=false
	while mines>0 do
		local r=flr(rnd(#cells))+1
		if (cells[r].hasmine==false) then
			cells[r].hasmine=true
			mines-=1
		end--if
	end--for
	
	ini_parts()
	
	gstate="game"
end

function drw_game()
	cls(0)
	
	if shake>0 then
		camx=-1*rnd(2)
		camy=-1*rnd(2)
	else
		camx=0
		camy=0
	end
	
	camera(0+camx,0+camy)
	
	--playfield
	for i=1,#cells do
		if (cells[i].revealed) then
			if (cells[i].hasmine) then
			rectfill(
				cells[i].index_x+4,
				cells[i].index_y+4,
				cells[i].index_x+size_w,
				cells[i].index_y+size_h,
				8)
			else
			spr(7,
			    cells[i].index_x+1,
			    cells[i].index_y+1,
			    2,2)
			end
		else
			palt(10,true)
			spr(cells[i].sp,
			   cells[i].index_x+2,
			   cells[i].index_y+2,
			   2,2)
			palt()
		end--revealed
	end--for
	
	--mine hints
	local c
	local off=3
	for c=1,#cells do
		if (cells[c].warn>0) then
			if (cells[c].warn==1) then
				spr(16,
				cells[c].index_x+off,
				cells[c].index_y+off)
			elseif (cells[c].warn==2) then
				spr(32,
				cells[c].index_x+off,
				cells[c].index_y+off)
			else
				spr(48,
				cells[c].index_x+off,
				cells[c].index_y+off)
			end--if
		end--if
	end--for
	
	--board
	rect(0,0,100,100,5)
	
	camera()
	
	
	-- inventory
	local j=0
	for c=1,#cells do
		if (cells[c].revealed
		and cells[c].prz~=0) then
			spr(
				cells[c].prz,
				cells[c].prz_x,
				cells[c].prz_y
				)
			
			cells[c].prz_x+=(112-cells[c].prz_x)*0.2
			cells[c].prz_y+=(5+(j*12)-cells[c].prz_y)*0.2
			if (112-cells[c].prz_x)<0.5 then
				cells[c].prz_x=112
			end
			if (5+(j*12)-cells[c].prz_y)<0.5 then
				cells[c].prz_y+=sin(t*0.03)*0.05
			end
			j+=1
		end
	end--for c
	rect(102,0,127,127,5)
	
	--cursor
	drw_cursor()
	
	
	print("hiscore",1,104,12)
	print(hiscore,34,104,12)
	
	print("time",1,112,2)
	print(gamesec,24,112,14)
	
	print("score",1,120,2)
	print(score,24,120,14)
	
	
	if (cheat) drw_hiddenmines()
	for _d=1,#debug do
		print(debug[_d],110,100+(_d*6),7)
	end
	
	drw_parts()
	
end--drw_game

function upd_game()
	
	if screentmr then
		screencnt+=1
	end
	
	if screencnt>60 then
		if hitmine then
			gstate="gameover"
		else
			gstate="win"
		end
	end
	
	upd_parts()
	
	if shake>0 then
		shake-=1
	else
		shake=0
	end
	
	t+=1
	gamet+=1
	if (gamet>60) then
		gamet=0
		gamesec+=1
	end
	
	checkwin()
	
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
				--particles
				shake=4
				addpart(id_x+8,id_y+8,0,4,5)
				cells[i].revealed=true
				
				if (cells[i].hasmine) then
					sfx(2)
					_draw()
					screentmr=true
					hitmine=true
				end
				
				if (cells[i].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
				checkaround(cells[i],id_x,id_y)
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
				if (cells[_c].prz>0) then
					addscore(50)
					addpart(id_x+8,id_y+8,0,5,7)
					sfx(2)
				else
					addscore(10)
				end
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
	local oy=0
	local ny=120
	print(
		"\^t\^wgame over!",
		10,
		oy,
		8)
	oy+=(ny-oy)*8
end

function checkwin()
	local i
	wincount=0
	for i=1,#cells do
		if (cells[i].revealed) then
			wincount+=1
		end
	end--for
	
	if (wincount==#cells-totmines) then
		screentmr=true
	end
end

function drw_gamewin()
	cls()
	local m="stage clear"
	print(m,64-(#m*2),20,11)
	m="score"
	print(m,64-(#m*2),40,13)
	m=tostr(score)
	print(m,64-(#m*2),48,8)
	m="time: "..gamesec
	print(m,64-(#m*2),64,13)
	
	local bonusmax=100
	local bonus=bonusmax-gamesec
	if (bonus<=0) then
		bonus=0
	end
	m="time bonus: "..bonus
	print(m,64-(#m*2),70,8)
	m="total score"
	print(m,64-(#m*2),76,7)
	winscore=score+bonus
	if (winscore>=hiscore) then
		hiscore=winscore
	end
	m=tostr(winscore)
	print(m,64-(#m*2),82,7)
end

function upd_gamewin()
	if (btnp(🅾️)) then
		gstate="menu"
	end
end

function drw_cursor()
	local select_s=1
	local select_c=10
	local oy=0
	local p
	local mov1=0.06
	local mov2=0.8
	
	if (btn(🅾️)) then
		select_s=2
		select_c=9
		oy=2
	else
		rect(
		select_x*size_w+2,
		select_y*size_h+2,
		select_x*size_w+size_w+2,
		select_y*size_h+size_h+2,
		9)
	end
	--shadow cursor
	for p=0,15 do
		pal(p,2)
	end
	spr(
		select_s,
		select_x*size_w+8,
		select_y*size_h+12-oy+cos(t*mov1)*mov2)
	pal()
	
	--highlight cursor
	for p=0,15 do
		pal(p,select_c)
	end
	spr(
		select_s,
		select_x*size_w+5,
		select_y*size_h+10-oy+cos(t*mov1)*mov2)
	spr(
		select_s,
		select_x*size_w+7,
		select_y*size_h+10-oy+cos(t*mov1)*mov2)
	spr(
		select_s,
		select_x*size_w+6,
		select_y*size_h+11-oy+cos(t*mov1)*mov2)
	spr(
		select_s,
		select_x*size_w+6,
		select_y*size_h+9-oy+cos(t*mov1)*mov2)
	pal()

	--regular cursor
	spr(
		select_s,
		select_x*size_w+6,
		select_y*size_h+10-oy+cos(t*mov1)*mov2)
	
end--drw_cursor

function addscore(p)
	score+=p
end--addscore

function drw_hiddenmines()
	for m in all(cells) do
		if (m.hasmine) then
			circfill(m.index_x+8,
												m.index_y+8,
												3,8)
		elseif (m.prz>0) then
			circfill(m.index_x+8,
												m.index_y+8,
												3,10)
		end
	end
end
-->8
--particles

function ini_parts()
	parts={}
end

function upd_parts()
	local p
	for p in all(parts) do
		if p.mage>0 then
			p.mage-=1
		else
			del(parts,p)
		end
		
		--shrink
		if p.t==0 then
			p.s-=1
		end
		
		--update movement
		p.x+=p.dx
		p.y+=p.dy
		
	end
end

function drw_parts()
	local p
	for p in all(parts) do
		circfill(p.x,p.y,p.s,p.c)
	end
end

function addpart(_x,_y,_t,_s,_c)
	local amt,spdx,spdy,age
	
	if _t==0 then
		amt=20
		age=20
	end
	
	for i=1,amt do
		if _t==0 then
			spdx=(sin(t*0.8))*rnd(8)
			spdy=-1*rnd(4)
		end
		
		local p={
			x=_x,
			y=_y,
			t=_t,
			s=_s+rnd(5),
			c=_c,
			mage=age+rnd(15),
			dx=spdx,
			dy=spdy
		}
		add(parts,p)
	end
end
__gfx__
00000000090000000200000000000000000000000000000000000000555555555555500000000000000000000000000000000000000000000000000000000000
000000002a900000292000000000222000000000000ddddddd0000005515511551111000000ddddddd000000000ddddddd000000000ddddddd00000000000000
007007002aa90000299200000002eee22222200005d6666666d50000501110011100100005d6666666d5000005d6666666d5000005dd666666d5000000000000
0007700029aa9000299920000002eee2ee2ee200d5d6666666d5d0005000000000001000d5d666666dd5d000d5d666d666d5d000d5d6d6d666d5d00000000000
000770002999a900299992000002eee2ee2ee2006566666666656000000000000000000065666666ddd5600065666ddd66d56000656d6d4d66d5600000000000
007007002992920029aaa2000022eeeeeeeee2006566666666656000000000000000000065666666dd656000656666166665600065666d2d6dd5600000000000
00000000292222002a2222000222eeeeeeeee200716666666661600000000000000000007166666dd67160007166661666716000716666d6ddd1600000000000
0000000002200000022000000222eeefffeee2007166666666616000000000000000000071666ddd6671600071666dd1667160007166666dddd1600000000000
00000000000000000000000002e2efffffffe2007611ddddd116700000000000000000007611ddddd11670007611ddd1111670007611dd111116700000000000
00000000000000000000000002eeeffffffee200d76611111667d0000000000000000000d76611111667d000d76611111667d000d76611111667d00000000000
000f0000000000000000000002eee2222222e2005ddddddddddd500000000110000000005ddddddddddd50005ddddddddddd50005ddddddddddd500000000000
00ff0000000000000000000000222eefffff22001555555555551000100111010011100015555555555510001555555555551000155555555555100000000000
0500f00000000000000000000002ee22222ef2000111111111110000000000000000000001111111111100000111111111110000011111111111000000000000
00000ff000000000000000000002e2222222e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000f0000000000000000000002ee22222ee2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000002222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
055500f0000ddddddd000000000ddddddd000000000ddddddd000000000ddddddd000000000ddddddd0000000090000000000000001144000000000000000000
505000ff05d666666dd5000005d666666dd5000005d666666dd5000005d666666dd5000005d666666dd5000009090000000a80000511a4000000000000000000
00000f00d5d666666dd5d000d5d666666dd5d000d5d666666dd5d000d5d666666dd5d000d5d666666dd5d000a000900000882200591a14400000000000000000
000ff000656666666dd56000656666966dd56000656666666dd56000656666666dd56000656666666dd56000a00040000002200051aa9a420000000000000000
0000f00065666666ddd560006566d999ddd5600065666666ddd5600065666666ddd5600065666666ddd560000a0040000006d000519914620000000000000000
0f0000f06166666ddd6160006166dddddd6160006166666ddd6160006166666ddd6160006166666ddd61600000acca0000600d00054446220000000000000000
00ffff00616666ddd6616000616666ddd6616000616666ddd6616000616666ddd6616000616666ddd6616000009d7d0000600d00006662600000000000000000
0f0000f0617766d667716000617766d667716000617766d667716000617766d667716000617766d6677160000009440000066000900422060000000000000000
000000006611ddddd11660006611ddddd11660006611ddddd11660006611ddddd11660006611ddddd11660000000000000000000000000000000000000000000
00000000d66611111666d000d66611111666d000d66611111666d000d66611111666d000d66611111666d0000000000000000000000000000000000000000000
000ffff05ddddddddddd50005ddddddddddd50005ddddddddddd50005ddddddddddd50005ddddddddddd50000000000000000000000000000000000000000000
00f0ff0f55dd55555dd5500055dd55555dd5500055dd55555dd5500055dd55555dd5500055dd55555dd550000000000000000000000000000000000000000000
00f0ff0f055555555555000005555555555500000555555555550000055555555555000005555555555500000000000000000000000000000000000000000000
000f00f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
910100000204100521035400051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910200003214428415200470010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
01050000385202e5303a0133d053223661f3161d61600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
