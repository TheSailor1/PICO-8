pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- gem dredging
-- by the sailor


-- ★★
---------
-- todo

-- game must loop until ded

-- opening last tile doesnt wait
-- before win screen

-- enemy hits player when 
-- it dies

-- improve hp bars

-- button feedback when in battle

-- ded screen

-- tut screen



--★★
--------------
-- tokens 7113
-- tokens 7073 - 40
-- tokens 7028 - 45
-- tokens 6997 - 31
-- tokens 5994 - 1003

-- tokens 6346
-- tokens 6320 - 26


function _init()
	
	--butt swap
	bswap=false
	menuitem(1,"swap ❎/🅾️", butt_swap)
	
	fadetable={
    split"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0",
    split"1,1,1,1,1,1,1,0,0,0,0,0,0,0,0",
    split"2,2,2,2,2,2,1,1,1,0,0,0,0,0,0",
    split"3,3,3,3,3,3,1,1,1,0,0,0,0,0,0",
    split"4,4,4,2,2,2,2,2,1,1,0,0,0,0,0",
    split"5,5,5,5,5,1,1,1,1,1,0,0,0,0,0",
    split"6,6,13,13,13,13,5,5,5,5,1,1,1,0,0",
    split"7,6,6,6,6,13,13,13,5,5,5,1,1,0,0",
    split"8,8,8,8,2,2,2,2,2,2,0,0,0,0,0",
    split"9,9,9,4,4,4,4,4,4,5,5,0,0,0,0",
    split"10,10,9,9,9,4,4,4,5,5,5,5,0,0,0",
    split"11,11,11,3,3,3,3,3,3,3,0,0,0,0,0",
    split"12,12,12,12,12,3,3,1,1,1,1,1,1,0,0",
    split"13,13,13,5,5,5,5,1,1,1,1,1,0,0,0",
    split"14,14,14,13,4,4,2,2,2,2,2,1,1,0,0",
    split"15,15,6,13,13,13,5,5,5,5,5,1,1,0,0"
	}
	t=0
	trans=0
	wait=0
	shake=0
	develop=0
	devspeed=0
	
	hi=0
	music(0,6000)
	
	bubbs={}
	
	_upd=upd_splash
	_drw=drw_splash
	
	--★
	debug={}
	
	--★
	showmines=false
	showgems=false
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	
	--★
	for i=1,#debug do
		local s="\^#"..tostr(debug[i])
		print(s,1,1+(i*6),8)
	end
	
end


-->8
-- screens

function upd_splash()
	if t>500 then
		t=0
	else
		t+=1
	end
	
	fadeeff(1)
	
	if t>=120 or btnp(❎) or btnp(🅾️) then
		devspeed=0
		develop=0
		ly=-50
		sy=100
		float=true
		sf=true
		t=0
		co=0
		cx=0
		cpass=0
		gy=-70
		_upd=upd_menu
		_drw=drw_menu
	end
end

function drw_splash()
	cls()
	fadepal((100-develop)/100)
	
	rectfill(0,0,127,127,0)
	cprint("praeberi fari",100,1)
	?sp_logo,40,40
end

function upd_menu()
	if t>500 then
		t=0
	else
		t+=1
	end
	
	fadeeff(1)
	
	if t>=20 and sf then
		sy+=(22-sy)/20
	end
	
	if sy-22<=0.5 and sf then
		sf=false
	end
	
	local lyb=76
	local gyd=96
	if t>=50 and float then
		ly+=(lyb-ly)/20
		gy+=(gyd-gy)/15
	end
	
	
	if lyb-ly<=0.5 then
		float=false
		ly=lyb
	end
	
	if not float then
		ly+=sin(t*0.008)*0.4
	end
	
	if not bswap and 
		btnp(❎) and t>60 then
		startgame()
	end
	if bswap and 
		btnp(🅾️) and t>60 then
		startgame()
	end
	
	if wait>0 then
		wait-=1
		
		if wait<=0 then
			devspeed=0
			develop=0
			ini_board(0)
			t=0
			music(2,6000)
			_upd=upd_game
			_drw=drw_game
		end
	end
end

function startgame()
	sfx(58)
	music(-1,1000)
	wait=60
	hp=maxhp
end

function drw_menu()
	cls()
	
	fadepal((100-develop)/100)
	
	--bkg
	rectfill(0,0,127,127,12)
	
	--sun
	sspr(77,14,19,35,80,sy)
	sspr(77,14,19,35,96,sy,19,35,true,false)
	sspr(41,31,8,8,92,sy+15)
	
	--clouds
	co+=0.01
	if cpass==0 then
		if co>=50 then
			co=0
			cx=120
			cpass+=1
		end
	elseif cpass>0 then
		if co>180 then
			co=0
			cx=120
		end
	end
	
	circfill((20+cx)-co,22,6,7)
	circfill((25+cx)-co,15,6,7)
	circfill((32+cx)-co,20,8,7)
	circfill((45+cx)-co,20,6,7)
	
	
	circfill(5,60,6,7)
	circfill(14,60,8,7)
	circfill(25,60,4,7)
	circfill(65,60,4,7)
	circfill(75,60,8,7)
	circfill(83,60,6,7)
	circfill(90,60,6,7)
	circfill(98,60,4,7)
	circfill(102,60,4,7)
	circfill(110,60,8,7)
	circfill(120,60,8,7)
	
	rectfill(0,62,127,70,7)
	rectfill(0,70,127,127,13)
	rectfill(0,105,127,127,1)
	
	line(0,70,127,70,12)
	line(0,71,127,71,12)
	line(2,73,125,73,12)
	line(64,75,104,75,12)
	line(110,75,124,75,12)
	
	fillp(0x5f5f)
	rectfill(0,105,127,109,29)
	fillp()
	
	--birds
	sspr(49,31,3,3,55,32)
	sspr(52,31,5,3,65,22)
	sspr(57,31,5,3,75,32)
	
	--boat
	sspr(36,49,55,30,15,46+sin((t%650)*0.003))
	line(67,55+sin((t%650)*0.003),104,70,13)
	
	--bird on boat
	sspr(39,119,7,5,62,51+sin((t%650)*0.003))
	
	--logo
	sspr(0,81,116,28,5,ly)
	
	--gems
	sspr(41,39,10,9,46,gy+cos(t*0.01)*2.9)
	sspr(51,39,10,9,58,gy+cos((t-12)*0.01)*2.9)
	sspr(61,39,10,9,70,gy+cos((t-22)*0.01)*2.9)
	
	rect(0,0,127,127,7)
	
	if not float then
		local c1,c2,y1,y2=6,6,116,116
		
		local t1,t2
		if not bswap then
			t1="❎ play"
			t2="🅾️ tutorial"
		else
			t1="🅾️ play"
			t2="❎ tutorial"
		end
		
		if bswap then
			if btnp(🅾️) then
				y1+=2
			elseif btnp(❎) then
				y2+=2
			end
		elseif not bswap then
			if btnp(❎) then
				y1+=2
			elseif btnp(🅾️) then
				y2+=2
			end
		end
	
	print(t1,10,y1,c1)
	print(t2,70,y2,c2)
	
	end
	
	local s=tostr("hiscore "..hi)
	local wd=(#s*6)-14
	sspr(69,0,3,5,58,1)
	sspr(69,0,3,5,58+wd-8,1)
	rrect(55,7,wd,6,1)
	rrect(55,6,wd,6,2)
	sprint(s,60,8,9,1)
	
	clip(90,7,8,1)
	print(s,60,7,10)
	clip()
	
	pset(60,7,10)
	line(64,7,65,7,10)
	line(80,7,81,7,10)
	line(84,7,85,7,10)
	
end

function upd_game()
	if t>500 then
		t=0
	else
		t+=1
	end
	fadeeff(1)
	
	upd_board()
	upd_parts()
	upd_bubbs()
	
	
	checkwin()
	
	upd_cursor()
	upd_timer()
	
	if trans>0 then
		trans-=1
	else
		if krak or trigbat then
			devspeed=0
			develop=0
			_upd=upd_battleintro
			_drw=drw_battleintro
		end
	end
	
end

function drw_game()
	cls()
	
	fadepal((100-develop)/100)
	
	rectfill(0,0,127,127,6)
	
	rectfill(0,90,127,127,12)
	fillp(▒)
	circfill(117,117,50,12)
	circfill(120,50,10,12)
	circfill(104,60,4,12)
	circfill(104,40,2,12)
	fillp()
	circfill(117,117,31,1)
	fillp(░)
	circfill(117,117,40,1)
	circfill(103,80,5,1)
	circfill(120,74,1,1)
	circfill(116,76,2,1)
	fillp()
	
	drw_bkg()
	if shake>0 then
		doshake(1)
	end
	drw_board()
	drw_cursor()
	drw_flags()
	drw_wflags()
	if (not krak) camera()
	drw_gemboard()
	drw_scoreboard()
	drw_diver()
	drw_parts()
	
	if (krak) camera()
	
	
	rect(0,0,127,127,12)
	
	
	drw_bubbs()
	
end

function upd_gameover()
	
	if not bswap then
		if btnp(❎) then
			_upd=upd_menu
			_drw=drw_menu
		end
	else
		if btnp(🅾️) then
			_upd=upd_menu
			_drw=drw_menu
		end
	end
end

function drw_gameover()
	cls(8)
	cprint("ded",45,7)
end

function butt_swap()
	if not bswap then
		bswap=true
	else
		bswap=false
	end
	return
end

function upd_timer()
	if timer<999 then
		gtimer+=1
	end
		
	if (gtimer>=60) then
		gtimer=0
		timer+=1
	end
end

function drw_timer(_x,_y)
	sspr(60,0,6,9,_x,_y)
	print(timer,_x+9,_y+4,1)
	print(timer,_x+9,_y+3,1)
	print(timer,_x+9,_y+2,7)
end
-->8
-- game play

function ini_board(_s)
	
	score=_s
	opentiles=0
	tilepoints=10
	flagtiles=0
	battletiles=0
	gtimer=0
	timer=0
	
	tiles={}
	t1_1,t1_2,t1_3=0,0,0
	t2_1,t2_2,t2_3=0,0,0
	t3_1,t3_2,t3_3=0,0,0
	
	flags={}
	
	fly=0
	
	
	cols=8
	rows=8
	size=12
	
	--cursor
	curx=3+flr(rnd(2))
	cury=3+flr(rnd(2))
	
	shake=0
	camx=0
	camy=0
	
	local i,j
	for i=0,cols-1 do
		for j=0,rows-1 do
			local c={
				id_x=i*size,
				id_y=j*size,
				revealed=false,
				hasmine=false,
				warn=0,
				hasgem="n",
				flag=false,
				spx=rnd({0,0,0,0,0,0,0,0,12,24,36}),
				spy=0
			}
			add(tiles,c)
		end--for j
	end--for i
	ini_parts()
	
	--adding mines
	allmines=10
	totmines=allmines
	allflags=10
	plrflags=allflags
	krak=false
	fw=4
	
	while allmines>0 do
		local rtile=flr(1+rnd(#tiles-1))
		if not tiles[rtile].hasmine then
			tiles[rtile].hasmine=true
			allmines-=1
		end
	end
	
	gems_r=0
	gems_g=0
	gems_o=0
	
--	allgems=flr(rnd(11))
	--min of 3 gems
	allgems=3+flr(rnd(8))
	while allgems>0 do
		local pickedgem
		choices=rnd(1)
		if choices<0.2 then
			pickedgem="o"
		elseif choices<0.4 then
			pickedgem="g"
		else
			pickedgem="r"
		end
		rtile=3+flr(rnd(#tiles-3))
		if tiles[rtile].hasgem=="n" and
		not tiles[rtile].hasmine then
			tiles[rtile].hasgem=pickedgem
			allgems-=1
		end
	end
	
end--ini_board()

function drw_bkg()
	rectfill(0,90,127,127,1)
end

function upd_board()
	for tl=1,#tiles do
		if tiles[tl].revealed and tiles[tl].hasmine then
			tiles[tl].spx=11
			tiles[tl].spy=109
		elseif tiles[tl].revealed then
			tiles[tl].spx=48
		end
	end--for
end

function drw_board()
	for tl in all(tiles) do
		pal({1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1})
		sspr(10,0,2,12,
							tl.id_x+13,tl.id_y+4)
		
		--btm
		sspr(0,10,12,2,
							tl.id_x+3,tl.id_y+13)
		
		pal()
		
		if t<100 then
			fadepal((100-develop)/100)
		end
		sspr(tl.spx,tl.spy,12,12,2+tl.id_x,2+tl.id_y)
	
	local _c
		if tl.revealed and
		not tl.hasmine and
			tl.warn>0 then
			if tl.id_x==curx*size and
				tl.id_y==cury*size then
					_c=12
			else
					_c=9
			end
			if tl.warn>=4 then
				_c=14
			end
			print(tl.warn,6+tl.id_x,6+tl.id_y,_c)
		end
	end --for
	
	--★
	if showgems then
		local g,c
		for g in all(tiles) do
			if g.hasgem=="r" then
				c=15
			elseif g.hasgem=="g" then
				c=11
			elseif g.hasgem=="o" then
				c=9
			else
				c=0
			end
			
			circfill(g.id_x+4,g.id_y+4,2,c)
		end
	end
	if showmines then
		local m
		for m in all(tiles) do
			if m.hasmine then
				circfill(m.id_x+10,m.id_y+10,2,8)
			end
		end
	end
	--★
	
	
end--drw_board()

function drw_cursor()
	for tl in all(tiles) do
		if curx*size==tl.id_x and
					cury*size==tl.id_y then
					sspr(23,109,16,18,curx*size,cury*size)
		end
	end
end--drw_cursor()

function drw_gemboard()
	sspr(66,0,21,14,103,1)
	
	sspr(87,0,13,12,103,16)
	sspr(100,0,13,12,103,28)
	sspr(113,0,13,13,103,40)
	
	rectfill(116,19,122,27,1)
	rectfill(117,20,121,26,14)
	pset(121,20,15)
	pset(117,26,15)
	line(118,28,122,28,1)
	print(gems_r,118,21,2)
	
	rectfill(116,31,122,39,1)
	rectfill(117,32,121,38,11)
	pset(121,32,10)
	pset(117,38,10)
	line(118,40,122,40,1)
	print(gems_g,118,33,3)
	
	
	rectfill(116,43,122,51,1)
	rectfill(117,44,121,50,9)
	pset(121,44,10)
	pset(117,50,10)
	line(118,52,122,52,1)
	print(gems_o,118,45,4)
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
	sprint("score "..score,7,107,10,1)
	pset(7,110,9)
	pset(12,110,9)
	pset(15,110,9)
	pset(19,110,9)
	pset(21,110,9)
	pset(23,110,9)
	
	--time
	drw_timer(65,104)
	
	--flags
	if curt=="flag" then
		circfill(16,116,3,9)
		circfill(16,118,3,10)
		circfill(16,117,3,2)
		
		circfill(80,116,3,9)
		circfill(80,118,3,10)
		circfill(80,117,3,2)
		
		line(16,113,80,113,9)
		line(16,121,80,121,10)
		rectfill(16,114,80,120,2)
		
		drw_popup(
			"flag mode 🅾️",
			40,98,8,10,9)
	end
	
	local f
	for f=1,allflags do
		sspr(5,109,5,5,13+(f*6),115,5,5)
	end
	for f=1,plrflags do
		sspr(0,109,5,5,13+(f*6),115,5,5)
	end
end

function drw_diver()
	sspr(8,13,28,14,98,60+(sin(t*0.002)*1.2))
	sspr(0,29,37,50,91,79+(sin(t*0.005)*2))
end


function upd_cursor()
	if t>10 then
		movecursor()
		
		if bswap then
			if btnp(❎) then
				new_bubbs(86,100)
				flagtile()
			elseif btnp(🅾️) then
				opentile()
			end
		elseif not bswap then
			if btnp(❎) then
				opentile()
			elseif btnp(🅾️) then
				new_bubbs(86,100)
				flagtile()
			end
		end
		
	end
end--upd_cursor()

function checkgems(_t)
	local p,pc,ns=0,0,0
	
	if (tiles[_t].hasgem=="r") then
		sfx(59)
		gems_r+=1
		p+=1
		pc=8
		ns=41
	elseif (tiles[_t].hasgem=="g") then
		sfx(59)
		gems_g+=1
		p+=1
		pc=11
		ns=51
	elseif (tiles[_t].hasgem=="o") then
		sfx(59)
		gems_o+=1
		p+=1
		pc=9
		ns=61
	end
	
	if p>0 then
		local ox=curx*size+7
		local oy=cury*size+7
		local nx,ny=0,0
		local rtbl={}
		
		if curx<=2 then
			rtbl={5,10,20,25}
		elseif curx>=6 then
			rtbl={-5,-10,-20,-25}
		else
			rtbl={-5,-10,-15,5,10,15}
		end
		
		new_bubbs(86,100)
		
		for i=1,p do
			add(parts,{
			x=ox,
			y=oy,
			dx=ox+rnd(rtbl),
			dy=oy+rnd(20),
			yspd=-2+rnd({-1,-2,-3}),
			r=3,
			c=pc,
			sp=ns,
			age=0,
			mage=60+rnd(40)
		})
		end
		p=0
	end
end

function flagtile()
	local t
	for t=1,#tiles do
			if (curx*size==tiles[t].id_x
			and cury*size==tiles[t].id_y) then 
				if tiles[t].flag then
					sfx(60)
					shake=0.04
					tiles[t].flag=false
					plrflags+=1
					local f
					for f in all(flags) do
						if tiles[t].id_x==f.x and
						tiles[t].id_y==f.y then
							del(flags,f)
						end
					end
				elseif not tiles[t].revealed 
				and not tiles[t].flag and
				plrflags>0 then
					sfx(61)
					add(flags,{
						x=curx*size,
						y=cury*size-40,
						dy=cury*size
						})
					tiles[t].flag=true
					plrflags-=1
					shake=0.07
				end
			end
	end
end--flagtile

function drw_flags()
	for f in all(flags) do
		if f.y~=f.dy then
			f.y+=8
		end
		drw_flgsp(f.x,f.y,0)
	end
end--drw_flags()

function drw_wflags()
	for f in all(flags) do
		for t in all(tiles) do
			if t.flag and t.revealed 
			and t.id_x==f.x
			and t.id_y==f.y then
				drw_flgsp(f.x,f.y,1)
			end
		end
	end
end--drw_wflags()

function drw_flgsp(_x,_y,_t)
	local pos,posy
	if _t==0 then
		posx,posy=39,109
	else
		posx,posy=36,12
	end
	
	sspr(posx,posy,9,10,_x+3,_y+3)
	sspr(posx,posy,9,10,_x+5,_y+3)
	sspr(posx,posy,9,10,_x+4,_y+2)
	sspr(posx,posy,9,10,_x+4,_y+4)
	sspr(posx,posy,9,10,_x+4,_y+3)
end

function opentile()
	for tl=1,#tiles do
			if (curx*size==tiles[tl].id_x
			and cury*size==tiles[tl].id_y 
			and not tiles[tl].revealed
			and not tiles[tl].flag) then
				tiles[tl].revealed=true
				new_bubbs(curx*size,cury*size)
				if tiles[tl].hasmine then
					sfx(57)
					wait=100
					trans=100
					shake=10
					krak=true
					enhp=ens[1]
					battletiles+=1
				else
					sfx(62)
					shake=0.1
					score+=tilepoints
					checkgems(tl)
					checkaround(tl)
					opentiles+=1
				end
			end
	end
end--opentile

function checkaround(_t)
	local a,b=-1,1
	local fcount=0
	
	if (cury==0) a,b=0,1
	if (cury==7) a,b=-1,0
		for _x=a,b do
		for _y=-1,1 do
		 if not (_x==0 and _y==0) then
				local curtil=_t+_x+_y*8
				if tiles[curtil] then
					if not tiles[curtil].revealed 
					and not tiles[curtil].hasmine then
						tiles[curtil].revealed=true
						opentiles+=1
						score+=10
						checkgems(curtil)
						checkaround2(curtil)
					elseif tiles[curtil].hasmine then
						tiles[_t].warn+=1
						if tiles[curtil].flag then
							fcount+=1
						end
						if tiles[_t].warn>=fw then
							if fcount>=fw then
								--nothing
							else
								battle()
							end
						end
					end
			end
			end    
	end
	end
end

function checkaround2(_t)
	local fcount=0
	local a,b=-1,1
	if (_t%8==1) a,b=0,1
	if (_t%8==0) a,b=-1,0
		for _x=a,b do
		for _y=-1,1 do
			local curtil=_t+_x+_y*8
			if not (_x==0 and _y==0) then
				if tiles[curtil] then
					if tiles[curtil].hasmine then
						tiles[_t].warn+=1
						tiles[_t].hasb=false
					end
					
					if tiles[curtil].flag then
						fcount+=1
					end
					
					if tiles[_t].warn>=fw then
						if fcount>=fw then
								--nothing
							else
								battle()
							end
					end
					
				end
			end    
		end
	end
end

function battle()
	trigbat=true
	sfx(57)
	krak=true
	shake=10
	wait=100
	trans=100
	bsel=1
end

function movecursor()
	local dx = tonum(btnp(➡️)) - tonum(btnp(⬅️)) --tonum makes a bool into 0 or 1
	local dy = tonum(btnp(⬇️)) - tonum(btnp(⬆️)) --pressing both directions together is the same as pressing neither
	curx += dx
	cury += dy
	curx %= cols --modulo; curx repeats from 0 when reaching cols (and vice-versa)
	cury %= rows
	if (dx~=0 or dy~=0) sfx"63"
end

function upd_kraken()
	if t>500 then
		t=0
	else
		t+=1
	end
	fadeeff(5)
	upd_timer()
	upd_bubbs()
	upd_battle()
end--/

function closekrak()
	wait=0
	music(0,4000)
	_drw=drw_menu
	_upd=upd_menu
end

function drw_kraken()
	--new
	cls(1)
	fadepal((100-develop)/100)
	
	if t%50==0 then
		big_bubbs()
	end
	
	drw_bigbubbs()
	
	fillp(0x3c3c)
	rectfill(1,1,126,6,18)
	fillp(0x69f5)
	rectfill(1,7,126,9,18)
	fillp(0x6ff5)
	rectfill(1,10,126,15,18)
	fillp()
	
	fillp(░)
	circfill(20,65,14,5)
	circfill(63,68,12,5)
	circfill(93,58,10,5)
	circfill(113,68,9,5)
	fillp()
	
	rectfill(0,80,127,104,13)
	circfill(10,80,10,13)
	circfill(28,80,7,13)
	circfill(65,80,9,13)
	circfill(85,80,12,13)
	circfill(100,80,8,13)
	circfill(120,80,8,13)
	
	
	if shake>0 then
		doshake(1)
	end
	
	drw_target()
	
	local hpcol1,hpcol2=9,9
	if en_hit then
		if hitcnt>0 then
			hitcnt-=1
			eoff=rnd({-5,-3,3,5,})
			hpcol2=rnd({7,8,1,2})
		else
			en_hit=false
			hitcnt=0
		end
	else
		eoff=0
	end
	if plr_hit then
		if hitcnt>0 then
			hitcnt-=1
			poff=rnd({-5,-3,3,5,})
			hpcol1=rnd({7,8,1,2})
		else
			plr_hit=false
			hitcnt=0
		end
	else
		poff=0
	end
	
	if (en_ded) mov_en+=0.5
	?sp_krak,64+eoff,12+sin(t*0.008)*2.2-mov_en
	 
	if (plr_ded) mov_plr+=1
	?sp_dredge,10+poff,mov_plr+48+sin(t*0.005)*2
	
	if hitcnt>0 then
		if plr_turn then
			new_bubbs(30,90)
		else
			new_bubbs(60,30)
		end
	end
	
	drw_bubbs()
	camera()
	
	
	--hit msgs
	local mx,my
	if plr_turn then
		mx,my=60,60
	else
		mx,my=60,10
	end
	
	if hittim>0 then
		hittim-=1
		?"\^w\^t"..hitmsg,mx-1,my,2
		?"\^w\^t"..hitmsg,mx+1,my,2
		?"\^w\^t"..hitmsg,mx,my-1,2
		?"\^w\^t"..hitmsg,mx,my+1,2
		?"\^w\^t"..hitmsg,mx,my,8
	else 
		hittim=0
	end
	
	sprint("krak",44,31,7,5)
	rect(58,22,58-ens[en_cnt]-2,28,2)
	rectfill(57,23,57-en_hp,27,hpcol2)
	
	sprint("dredger",66,95,7,1)
	rect(83,86,83+maxhp+2,92,2)
	rectfill(84,87,84+hp,91,hpcol1)
	
	rectfill(0,105,127,127,2)
	
	line(2,104,125,104,2)
	rectfill(2,105,125,125,14)
	rectfill(3,106,124,124,2)
	pset(2,105,2)
	pset(2,125,2)
	pset(125,105,2)
	pset(125,125,2)
	
	--timer
	drw_timer(5,5)
	
	--gems
	local gems={41,51,61}
	local adj=18
	for i=1,#gems do
		sspr(gems[i],39,10,9,70+((i-1)*adj),108)
		line(69+((i-1)*adj),112,74+((i-1)*adj),117,1)
		line(69+((i-1)*adj),113,74+((i-1)*adj),118,1)
		line(80+((i-1)*adj),112,75+((i-1)*adj),117,1)
		line(80+((i-1)*adj),113,75+((i-1)*adj),118,1)
		
		rectfill(78+((i-1)*adj),116,82+((i-1)*adj),122,1)
	end
	
	local c1,c2,c3=7,7,7
	if (bsel==1) c1=14
	if (bsel==2) c2=11
	if (bsel==3) c3=9
	
	sprint("attack",8,109,c1,1)
	sprint("heal",8,118,c2,1)
	sprint("fright",34,118,c3,1)
	
	print(gems_r,79,117,14)
	print(gems_g,97,117,11)
	print(gems_o,115,117,9)
	
	sspr(120,102,6,7,bselpos[bsel][1]+sin(t*0.02)*0.3,bselpos[bsel][2])
	
	rect(0,0,127,127,8)
	
end

function checkwin()
	if opentiles==#tiles-totmines then
		for t in all(tiles) do
			if t.flag and t.hasmine then
				flagtiles+=1
			end
		end
		devspeed=0
		develop=0
		t=0
		en_cnt=1
		stoptime=timer
		_drw=drw_win
		_upd=upd_win
	end
end

function drw_win()
	
	if t<100 then
		fadepal((100-develop)/100)
	end
	
	rectfill(0,0,127,127,6)
	
	--top
	rectfill(0,14,127,35,9)
	line(0,14,127,14,10)
	
	rectfill(13,17,29,32,7)
	rectfill(6,17,11,32,7)
	rectfill(2,17,4,32,4)
	
	rectfill(98,17,114,32,7)
	rectfill(116,17,121,32,7)
	rectfill(123,17,125,32,4)
	
	rect(31,17,96,32,7)
	print("\^t\^wcleared!",34,20,7)
	
	line(0,35,127,35,4)
	
	--bonus
	rectfill(0,36,127,69,9)
	line(0,36,127,36,10)
	line(0,69,127,69,4)
	
	
	local i
	--orange shadow
	for i=0,15 do
		pal(i,4)
	end
	--flag
	sspr(39,109,9,10,12,52)
	--red
	sspr(41,39,10,9,43,53)
	--green
	sspr(51,39,10,9,73,53)
	--orange
	sspr(61,39,10,9,103,53)

	
	--blue outline
	pal({1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1})
	
	--red
	sspr(41,39,10,9,43,50)
	sspr(41,39,10,9,43,52)
	sspr(41,39,10,9,42,51)
	sspr(41,39,10,9,44,51)
	--green
	sspr(51,39,10,9,73,50)
	sspr(51,39,10,9,73,52)
	sspr(51,39,10,9,72,51)
	sspr(51,39,10,9,74,51)
	--orange
	sspr(61,39,10,9,103,50)
	sspr(61,39,10,9,103,52)
	sspr(61,39,10,9,102,51)
	sspr(61,39,10,9,104,51)
	
	pal()
	
	--flag
	sspr(39,109,9,10,12,51)
	--red
	sspr(41,39,10,9,43,51)
	--green
	sspr(51,39,10,9,73,51)
	--orange
	sspr(61,39,10,9,103,51)
	
	--text(points)
	sprint(flagtiles.."X",12,43,10,2)
	print("15",12,63,4)
	
	sprint(gems_r.."X",44,43,10,2)
	print("10",44,63,4)
	
	sprint(gems_g.."X",74,43,10,2)
	print("20",74,63,4)
	
	sprint(gems_o.."X",104,43,10,2)
	print("30",104,63,4)
	
	--divider
	drw_hazarddiv(11)
	drw_hazarddiv(34)
	drw_hazarddiv(70)
	
	--points
	rectfill(0,75,127,90,9)
	line(0,76,127,76,10)
	line(0,91,127,91,4)
	rectfill(0,92,127,94,13)
	
	local f_points=flagtiles*15
	local r_points=gems_r*10
	local g_points=gems_g*20
	local o_points=gems_o*30
	
	bonus=f_points+r_points+g_points+o_points
	newscore=score+bonus
	
	if hi<newscore then
		hi=newscore
	end
	
	cprint("round > "..tostr(opentiles*tilepoints).." + "..tostr(bonus).." (bonus)",82,1)
	sprint("time to clear >>> "..stoptime,14,104,1,6)
	sprint("total score   >>> "..newscore,14,112,1,6)
--	sprint(newscore,100,112,1,13)
	
	--frame
	rect(0,0,127,127,10)
	rect(1,1,126,126,9)
	
end

function upd_win()
	fadeeff(1)
	
	if not bswap then
		if btnp(❎) then
			ini_board(newscore)
			devspeed=0
			develop=0
			_upd=upd_game
			_drw=drw_game
		end
	else
		if btnp(🅾️) then
			devspeed=0
			develop=0
			ini_board(newscore)
			_upd=upd_game
			_drw=drw_game
		end
	end
end

function gotomenu()
	_init()
end

function drw_hazarddiv(y)
	rectfill(0,y,127,y+4,9)
	line(0,y+4,127,y+4,4)
	fillp(0xcc33)
	rectfill(0,y,127,y+3,148)
	fillp()
end


-->8
-- tools

function fadeeff(n)
	devspeed+=n
	develop+=devspeed
	develop=min(100,develop)
end

function lerp(a,b,spd)
	local res=a-b/spd
	return res
end


function sprint(s,x,y,fg,bg)
	print(s,x,y,bg)
	print(s,x,y+1,bg)
	print(s,x,y-1,fg)
end

function cprint(s,y,c)
	local x=64-(#s*2)
	print(s,x,y,c)
end

function rrect(_x,_y,_w,_h,_c)
	rectfill(_x-1,_y,_x+_w+1,_y+_h,_c)
	rectfill(_x,_y-1,_x+_w,_y+_h+1,_c)
	rectfill(_x-2,_y+1,_x+_w+2,_y+_h-1,_c)
end

function orrect(_x,_y,_w,_h,_c1,_c2)
	rectfill(_x-2,_y-1,_x+_w+2,_y+_h+1,_c1)
	rectfill(_x-3,_y-1,_x+_w+3,_y+_h+1,_c1)
	rectfill(_x-3,_y-2,_x+_w+3,_y+_h+2,_c1)
	
	rectfill(_x-1,_y,_x+_w+1,_y+_h,_c2)
	rectfill(_x,_y-1,_x+_w,_y+_h+1,_c2)
	rectfill(_x-2,_y+1,_x+_w+2,_y+_h-1,_c2)
	
	line(_x-3,_y+_h+3,_x+_w+3,_y+_h+3,1)
	line(_x-3,_y+_h+4,_x+_w+3,_y+_h+4,1)
end
-->8
--ui

function fadepal(_perc)
 -- this function sets the
 -- color palette so everything
 -- you draw afterwards will
 -- appear darker
 -- it accepts a number from
 -- 0 means normal
 -- 1 is completely black
 -- this function has been
 -- adapted from the jelpi.p8
 -- demo
 
 -- first we take our argument
 -- and turn it into a 
 -- percentage number (0-100)
 -- also making sure its not
 -- out of bounds  
 local p=flr(mid(0,_perc,1)*100)
 
 -- these are helper variables
 local kmax,col,dpal,j,k
 
 -- this is a table to do the
 -- palette shifiting. it tells
 -- what number changes into
 -- what when it gets darker
 -- so number 
 -- 15 becomes 14
 -- 14 becomes 13
 -- 13 becomes 1
 -- 12 becomes 3
 -- etc...
 dpal={0,1,1,2,1,13,
 						6,4,4,9,3,13,
 						1,13,14}
 
 -- now we go trough all colors
 for j=1,15 do
  --grab the current color
  col = j
  
  --now calculate how many
  --times we want to fade the
  --color.
  --this is a messy formula
  --and not exact science.
  --but basically when kmax
  --reaches 5 every color gets 
  --turns black.
  kmax=(p+(j*1.46))/22
  
  --now we send the color 
  --through our table kmax
  --times to derive the final
  --color
  for k=1,kmax do
   col=dpal[col]
  end
  
  --finally, we change the
  --palette
  pal(j,col)
 end
end


function doshake(a)
 -- this function does the
 -- shaking
 -- first we generate two
 -- random numbers between
 -- -16 and +16
 local shakex=a-rnd(a*2)
 local shakey=a-rnd(a*2)

 -- then we apply the shake
 -- strength
 shakex*=shake
 shakey*=shake
 
 -- then we move the camera
 -- this means that everything
 -- you draw on the screen
 -- afterwards will be shifted
 -- by that many pixels
 camera(shakex,shakey)
 
 -- finally, fade out the shake
 -- reset to 0 when very low
 shake = shake*0.95
 if (shake<0.05) shake=0
end

-->8
-- particles

function ini_parts()
	parts={}
end

function drw_parts()
	for p in all(parts) do
		if p.yspd==0 then
			pal({1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1})
			sspr(p.sp,39,10,9,p.x,p.y+3)
			pal()
		end
		sspr(p.sp,39,10,9,p.x,p.y)
	end
end

function upd_parts()
	for p in all(parts) do
		if p.age<p.mage then
			p.x+=(p.dx-p.x)/5
			p.y+=p.yspd
			if p.y>=p.dy then
				p.yspd=0
			else
				p.yspd+=0.5
			end
			p.age+=1
		else
			del(parts,p)
		end
	end
end

function new_bubbs(_x,_y)
	local amt=2+flr(rnd(6))
	for b=1,amt do
	add(bubbs,{
			x=_x+rnd(30),
			y=_y-rnd(20),
			yspd=-1,
			r=rnd({1,3}),
			c=12,
			typ=1
		})
	end
end

function big_bubbs()
	local amt=4+flr(rnd(4))
	for b=1,amt do
		add(bubbs,{
			x=rnd(127),
			y=75+rnd(20),
			yspd=rnd(0.3)*-1,
			r=flr(rnd(8)),
			c=rnd({5,13}),
			typ=2
		})
	end
end

function new_mov_bubbs(_y)
	local amt=20+flr(rnd(10))
	for b=1,amt do
		add(bubbs,{
			x=rnd(127),
			y=_y+rnd(10),
			yspd=rnd({10})*-1,
			r=rnd({10,12,14}),
			c=8,
			typ=3
		})
	end
end

function drw_bubbs()
	for b in all(bubbs) do
		if b.typ==1 then
			circ(b.x+sin(t*0.3)*0.9,b.y,b.r,b.c)
		elseif b.typ==3 then
			circfill(b.x+sin(t*0.3)*0.9,b.y,b.r,b.c)
		end
	end
end

function drw_bigbubbs()
	for b in all(bubbs) do
		if b.typ==2 then
			circ(b.x+sin(t*0.02)*1.2,b.y,b.r,b.c)
		end
	end
end


function upd_bubbs()
	for b in all(bubbs) do
		b.y+=b.yspd
		if b.typ==1 then
			if b.r>0 then
				b.r-=0.05
			else
				del(bubbs,b)
			end
		elseif b.typ==2 then
			if b.r>0 then
				b.r-=0.02
			else
				del(bubbs,b)
			end
		elseif b.typ==3 then
			if b.r>0 then
				b.r-=2
			else
				del(bubbs,b)
			end
		end
	end
end
-->8
--p8scii

sp_logo="⁶-b⁶x8⁶y8ᶜ8⁶.\0\0█ナp8「ᶜ⁶.<◝れ\0\0\0\0\0⁶.\0\0⁷ᶠᶜ\0<◝             \n⁶.ᵉ⁶¹³²³¹²⁶.ら ▮▮(DTT⁶.\0\0x●¹Mえ=⁶.³⁴⁴	キ★⬆️⬆️⁶.\0\0\0\0コTチT⁶.\0\0\0\0¹\0\0\0          \n⁶.\0\0⁴\0\0▮ \0⁶.D(▮0 ス⁴&⁶.}ョy●x\0れュ⁶.⬆️□\n✽Dエᶠオ⁶.ケ\0\0ツ⬆️えˇケ⁶.¹\0\0✽DDDツ⁶.\0\0\0。‖\r‖⁘         \n⁶.█ららナナ\0\0\0⁶.⁷ᶠ?○ン\0\0\0⁶.x\0🐱\0◝\0\0\0⁶.⁘pヲュト\0\0\0⁶.\0\0\0¹³\0\0\0           \n                \n                \n                \n                \n                \n                \n                \n                \n                \n                \n                \n                "

sp_krak="⁶-b⁶x8⁶y8 ⁶-#ᶜ2⁶.\0\0\0\0\0█`▮⁸⁶-#ᶜ7⁶.\0\0\0\0█`▮⁸⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0█ナ⁶-#ᶜ2⁶.\0\0\0\0◜¹\0\0⁸⁶-#ᶜ7⁶.\0\0\0◜¹\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0\0²▒ら⁸⁶-#ᶜe⁶.\0\0\0\0\0ュ~?⁶-#ᶜ2⁶.\0ᶜ゛3#088⁸⁶-#ᶜ7⁶.、□!@@@@@⁸⁶-#ᶜ8⁶.\0\0\0\0▮ᶜ⁷⁷⁸⁶-#ᶜe⁶.\0\0\0ᶜᶜ³\0\0⁶-#            \n⁶-#ᶜ2⁶.\0\0\0`ユ0ユナ⁸⁶-#ᶜ7⁶.\0\0`…⁸っ⁸▮⁶-#ᶜ1⁶.\0`オ█\0\0@d⁸⁶-#ᶜ2⁶.⁸⁴⁴⁴⁴⁸	ᵇ⁸⁶-#ᶜ7⁶.⁴²²²³⁷⁶\0⁸⁶-#ᶜ8⁶.ユ▤(x▤\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0ぬ…⁸⁶-#ᶜa⁶.\0\0\0\0`ユ\0\0²1ᶜ2⁶. `Pヲナららら⁸⁶-#ᶜ8⁶.テ♥⬇️³⁷³³³⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0004$⁸⁶-#ᶜa⁶.\0\0\0\0「<\0\0⁸⁶-#ᶜe⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ2⁶.<、アlnoヤエ⁸⁶-#ᶜ7⁶.@ナ0………▮0⁸⁶-#ᶜ8⁶.³³³³¹\0\0\0⁶-#ᶜ7⁶.\0¹¹\0\0\0¹¹           \n⁶-#ᶜ2⁶.\0\0\0ら` 00⁸⁶-#ᶜ7⁶.ナ\0ら ▮▮⁸⁸⁸⁶-#ᶜ8⁶.\0\0\0\0█ららら⁶-#ᶜ1⁶.d⁶²0 8x░⁸⁶-#ᶜ2⁶.ᵇ☉☉◆「⁴⁶{⁸⁶-#ᶜ7⁶.\0¹¹\0\0\0\0\0⁸⁶-#ᶜ8⁶.█pp@んれ▒\0⁸⁶-#ᶜ9⁶.▮\0\0\0\0\0\0\0²1ᶜ2⁶.ら\0¹³\0ナユナ⁸⁶-#ᶜ8⁶.⁷ュュᶜᶠᶠ⁷\0⁸⁶-#ᶜ9⁶. \0\0\0\0\0\0\0⁶-#ᶜ1⁶.\0▮ᵉ⁷⬅️p0\0⁸⁶-#ᶜ2⁶.せこねスtᶠᶜ	⁸⁶-#ᶜ7⁶.「⁴\0\0\0█@0⁸⁶-#ᶜ8⁶.@@@ \0\0³⁶⁶-#ᶜ7⁶.¹¹¹¹¹\0\0\0           \n⁶-#ᶜ2⁶.きてffNュヲユ⁸⁶-#ᶜ7⁶.、□」」1²⁴⁸⁸⁶-#ᶜ8⁶.@@███\0\0\0⁶-#ᶜ1⁶.²\0\0\0\0\0\0\0⁸⁶-#ᶜ2⁶.われり▒¹¹¹\0⁸⁶-#ᶜ7⁶.8$\"B🐱²²¹⁶-#ᶜ1⁶.、▮\0\0\0\0\0\0⁸⁶-#ᶜ2⁶.こ/?oテ「0ナ⁸⁶-#ᶜ7⁶.@らら█¹⁶⁸▮⁸⁶-#ᶜ8⁶.\0\0\0▮ ナら\0⁶-#ᶜ2⁶.⁙3rモンリ²²⁸⁶-#ᶜ7⁶. ら▒¹⁶ᶜル⁴⁸⁶-#ᶜ8⁶.ᶜᶜᶜ▮\0\0¹¹⁶-#ᶜ2⁶.\0¹¹¹¹\0\0\0⁸⁶-#ᶜ7⁶.¹²²²²¹\0\0⁶-#           \n⁶.ユ\0\0\0\0\0\0\0 ⁶-#ᶜ2⁶.らナユ`\0\0\0\0⁸⁶-#ᶜ7⁶. 「⁸…`\0\0\0⁶-#ᶜ2⁶.²³¹\0\0\0\0\0⁸⁶-#ᶜ7⁶.⁴⁴²¹\0\0\0\0⁸⁶-#ᶜ8⁶.¹\0\0\0\0\0\0\0⁶-#\n\n\n\n\n\n\n\n\n\n\n"
sp_dredge="⁶-b⁶x8⁶y8⁶-#ᶜ1⁶.\0\0\0\0ᵉ□\"D⁸⁶-#ᶜ6⁶.\0\0\0ᶠ■!A🐱⁸⁶-#ᶜ7⁶.\0\0\0\0\0ᶜ、8⁶-# ⁶-#ᶜ1⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ6⁶.\0\0\0\0\0\0█@⁶-#ᶜ1⁶.\0\0ナ「⁴²¹\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0ナ▮⁸⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜ6⁶.\0ナ「⁴²¹\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0ユ「F3⁸⁶-#ᶜa⁶.\0\0\0ナ⁸⁴(⁴⁶-#ᶜ1⁶.\0p◆\0\0\0\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜ4⁶.\0\0\0pら█\0\0⁸⁶-#ᶜ6⁶.p◆\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0ᶜ?<pユ⁸⁶-#ᶜa⁶.\0\0p⬇️\0B🅾️ᵉ⁶-#ᶜ1⁶.\0\0\0¹²⁴⁸⁸⁸⁶-#ᶜ4⁶.\0\0\0\0\0¹³⁷⁸⁶-#ᶜ6⁶.\0\0¹²⁴⁸▮▮⁸⁶-#ᶜ9⁶.\0\0\0\0\0²⁴\0⁸⁶-#ᶜa⁶.\0\0\0\0¹\0\0\0⁶-#          \n⁶-#ᶜ1⁶.☉▮ @███\0⁸⁶-#ᶜ6⁶.DそPき@@@@⁸⁶-#ᶜ7⁶.0@█\0\0\0\0\0⁶-#ᶜ1⁶.\0¹゜ @@@○⁸⁶-#ᶜ2⁶.\0\0\0\0¹⁷⁷\0⁸⁶-#ᶜ4⁶.\0\0\0゛>88\0⁸⁶-#ᶜ6⁶.¹゛ A████⁶-#ᶜ1⁶.@  ▮▮…きき⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0@⁸⁶-#ᶜ4⁶.█@\0 ``@\0⁸⁶-#ᶜ6⁶. ▮▮⁸⁸⁸▮▮⁸⁶-#ᶜ9⁶.\0█らら█\0\0\0²1ᶜ2⁶.☉p\0\0\0\0\0\0⁸⁶-#ᶜ4⁶.p\0😐n6•••⁸⁶-#ᶜ9⁶.¹¹\0\0\0█らナ⁸⁶-#ᶜa⁶.⁶²¹█ら` \0²1ᶜ2⁶.\0\0\0\0ナ▮⁸⁴⁸⁶-#ᶜ4⁶.\0\0\0\0\0█ナ0⁸⁶-#ᶜ9⁶.ユヲュ◝゜o▶ᵇ⁸⁶-#ᶜa⁶.ᶠ⁷³\0\0\0\0\0⁶-#ᶜ1⁶.▮▮    ▮⁸⁸⁶-#ᶜ2⁶.²\0⁴\0⁸」\n⁴⁸⁶-#ᶜ4⁶.ᶜᶜ「「▮\0¹³⁸⁶-#ᶜ6⁶.  @@@@ ▮⁸⁶-#ᶜ9⁶.\0¹¹³³⁶⁴\0⁸⁶-#ᶜa⁶.¹²²⁴⁴\0\0\0⁶-#          \nᶜ6⁶.███\0\0\0\0\0⁶-#ᶜ1⁶.▥■!B🐱ᶜ、<⁸⁶-#ᶜ5⁶.⁶²²$Dらナら⁸⁶-#ᶜ6⁶.`ナら▒¹²²²⁸⁶-#ᶜd⁶.\0ᶜ、「80\0\0⁶-#ᶜ1⁶.きりB░☉q\"D⁸⁶-#ᶜ2⁶.@\0█\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0¹³⁸⁶-#ᶜ6⁶.■\"$Is⁶ᶜ「⁸⁶-#ᶜ7⁶.\0\0¹²⁴⁸▮ ⁸⁶-#ᶜd⁶.\0\0\0\0\0█ら█²1ᶜ2⁶.\0\0\0 @█\0\0⁸⁶-#ᶜ4⁶.••ロウう8pナ⁸⁶-#ᶜ9⁶.ナナ\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0¹³⁷²1ᶜ2⁶.²\0\0²⁷エ゜ᶜ⁸⁶-#ᶜ4⁶.、やイ」0 \0\0⁸⁶-#ᶜ9⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0ら⁶-#ᶜ1⁶.⁸ᵇᵇ、\"!@@⁸⁶-#ᶜ2⁶.⁶⁴⁴³¹\0\0\0⁸⁶-#ᶜ4⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.▮▮▮ @Hうう⁸⁶-#ᶜd⁶.\0\0\0\0、◀##⁶-#          \n ⁶-#ᶜ1⁶.ヲヲヲユナら\0\0⁸⁶-#ᶜ6⁶.⁴⁴⁴⁸▮ ら\0²1ᶜ2⁶.\0\0pユ0「「「⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.0ナ█\0\0\0\0¹⁸⁶-#ᶜ7⁶.@\0\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0らナナナ⁸⁶-#ᶜd⁶.⁴ᶜᶜᶜ\0\0\0\0²1ᶜ2⁶.\0\0\0\0¹²⁴⁸⁸⁶-#ᶜ4⁶.ら█\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0`@ら⁸⁶-#ᶜ6⁶.\0\0¹³⁶ᶜ「0⁸⁶-#ᶜ8⁶.\0\0\0\0\0¹³⁷⁸⁶-#ᶜd⁶.゜>\0xユ██\0²1ᶜ4⁶.¹³⁷ᵇ⁶⁴ᶜ▮⁸⁶-#ᶜ9⁶.\0\0\0⁴⁸「▮⁸⁸⁶-#ᶜd⁶.ユヲ\0ナナりりれ²1ᶜ5⁶.\0███ナらら█⁸⁶-#ᶜ6⁶.<x0\0\0\0\0\0⁸⁶-#ᶜd⁶.C⁷O~\r³³³⁶-#ᶜ1⁶.\0¹²²⁴⁸▮ ⁸⁶-#ᶜ5⁶.\0\0¹¹³¹³⁷⁸⁶-#ᶜ6⁶.¹²⁴⁴⁸▮ ら⁸⁶-#ᶜd⁶.\0\0\0\0\0⁶ᶜ「⁶-#ᶜ6⁶.\0\0\0\0\0\0\0♥        \n  ⁶-#ᶜ1⁶.⁴⁸⁸⁸⁴²²²⁸⁶-#ᶜ2⁶.「\0\0\0\0\0\0ᶜ⁸⁶-#ᶜ6⁶.²⁴⁴⁴²¹¹¹⁸⁶-#ᶜ8⁶.`ぬ……ま|ュユ⁸⁶-#ᶜa⁶.█@``@█\0\0²1ᶜ2⁶.⁸\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.███ららららナ⁸⁶-#ᶜ6⁶.0\0\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.⁶\r\r\r\rᵉᶠ⁷⁸⁶-#ᶜa⁶.¹²²²²¹\0\0²1ᶜ4⁶.⁸▮「「、ᶜᵉ⁶⁸⁶-#ᶜ5⁶.\0¹³³りニナユ⁸⁶-#ᶜ9⁶.▮⁸\0\0\0\0\0\0⁸⁶-#ᶜd⁶.れるらら\0\0\0\0⁶-#ᶜ1⁶.◜◜モ∧⁙⁙	⁸⁸⁶-#ᶜ5⁶.\0¹■	ᶜᶜ⁶⁷⁸⁶-#ᶜ6⁶.\0\0\0`き ▮▮⁸⁶-#ᶜd⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ1⁶.り³⁷ᶠᶠ>xユ⁸⁶-#ᶜ5⁶.ᵉ、xユユら█\0⁸⁶-#ᶜ6⁶.\0\0\0\0\0¹⁶⁸⁸⁶-#ᶜd⁶.0ナ█\0\0\0\0\0⁶-#ᶜ1⁶.♥X`@@ 「⁷⁸⁶-#ᶜ2⁶.\0\0\0\0\0@ナヲ⁸⁶-#ᶜ4⁶.\0█████\0\0⁸⁶-#ᶜ5⁶.\0\0\0008?゜⁷\0⁸⁶-#ᶜ6⁶.X \0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0⁷゜⁷\0\0\0\0⁶-#ᶜ1⁶.\0¹¹⁶⁸⁸⁴³⁸⁶-#ᶜ4⁶.\0\0\0¹⁷⁷³\0⁸⁶-#ᶜ6⁶.¹²⁶⁸▮▮⁸⁴⁶-#       \n  ⁶-#ᶜ1⁶.ᵉ▮ナナユユヲヲ⁸⁶-#ᶜ2⁶.▮ \0\0\0\0\0\0⁸⁶-#ᶜ6⁶.¹ᵉ▮▮⁸⁸⁴⁴⁸⁶-#ᶜ8⁶.ナら\0\0\0\0\0\0²1ᶜ4⁶.\0\0███ら`4⁸⁶-#ᶜ5⁶.`p0 \0\0\0\0⁸⁶-#ᶜ8⁶.⁷³\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0@ ▮⁸²1ᶜ4⁶.⁷³³¹¹\0\0\0⁸⁶-#ᶜ5⁶.ユヲヲヲュュ\0◜⁶-#ᶜ1⁶.⁸⁸⁴²²³⁴⁴⁸⁶-#ᶜ5⁶.⁷⁷³¹¹\0¹¹⁸⁶-#ᶜ6⁶.▮▮⁸⁴⁴⁴⁸⁸⁸⁶-#ᶜd⁶.\0\0\0\0\0\0²²⁶-#ᶜ6⁶.ユ\0\0\0\0\0\0\0⁶-#ᶜ1⁶.ヲ\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.⁷ヲ\0\0\0\0\0\0⁶-#⁶.³\0\0\0\0\0\0\0       \n ⁶-#ᶜ1⁶.\0\0\0\0\0ナ「⁴⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0ナヲ⁸⁶-#ᶜ6⁶.\0\0\0\0ナ「⁴²⁶-#ᶜ1⁶.ュ<ᵉ●ニユヲュ⁸⁶-#ᶜ4⁶.\0@…h¥ᶠ⁷³⁸⁶-#ᶜ6⁶.²²¹¹\0\0\0\0⁸⁶-#ᶜ9⁶.\0█`▮⁴\0\0\0⁶-#ᶜ1⁶.ナx゛⁷#AD🐱⁸⁶-#ᶜ4⁶.」⁶¹\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0█ナヲチ🅾️³¹⁸⁶-#ᶜ6⁶.\0\0\0\0\0000(D⁸⁶-#ᶜ9⁶.⁶¹\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0█\0²1ᶜ5⁶.◝◝◝◝◝♥³³⁶-#ᶜ1⁶.⁴⁸⁸⁸⁸⁸▮■⁸⁶-#ᶜ5⁶.¹³³³³⁷⁷ᵉ⁸⁶-#ᶜ6⁶.⁸▮▮▮▮▮  ⁸⁶-#ᶜd⁶.²⁴⁴⁴⁴\0⁸\0⁶-#          \n⁶-#ᶜ1⁶.\0█`▮⁸\0\0\0⁸⁶-#ᶜ4⁶.\0\0█ナユ\0\0\0⁸⁶-#ᶜ6⁶.█`▮⁸⁴\0\0\0⁶-#ᶜ1⁶.²▒らナユ\0\0\0⁸⁶-#ᶜ4⁶.ュ~?゜ᶠ\0\0\0⁸⁶-#ᶜ6⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ1⁶.○??かか\0\0\0⁸⁶-#ᶜ5⁶.█らら``\0\0\0⁶-#ᶜ1⁶.²¹¹\0\0\0\0\0⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.█🐱²¹¹\0\0\0⁶-#ᶜ1⁶.ョンッッュ\0\0\0⁸⁶-#ᶜ5⁶.²⁴\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0¹¹²\0\0\0⁸⁶-#ᶜd⁶.\0²⁴⁴\0\0\0\0⁶-#ᶜ1⁶.⁙⁙'''\0\0\0⁸⁶-#ᶜ5⁶.ᶜᶜ「「「\0\0\0⁸⁶-#ᶜ6⁶.  @@@\0\0\0⁶-#          \n                \n                \n                \n                \n                \n                \n                \n                "
sp_tentacle="⁶-b⁶x8⁶y8                \n                \n     ᶜc⁶.\0\0\0\0\0000pP   ⁶-#ᶜ1⁶.\0\0\0\0\0\0ユᶜ⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0\0p⁸⁶-#ᶜa⁶.\0\0\0\0\0ユᶜ²⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0█⁶-#ᶜ1⁶.\0\0\0\0\0\0¹⁶⁸⁶-#ᶜa⁶.\0\0\0\0\0¹⁶⁸⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0¹⁶-#     \n     ⁶-#ᶜa⁶.\0\0\0\0\0█らら⁸⁶-#ᶜc⁶.ナナ\0\0\0\0\0\0⁶-#ᶜa⁶.\0\0\0|◝エん♥⁸⁶-#ᶜc⁶.\0¹\0\0\00008x⁶-#ᶜ9⁶.\0pヲヲヲp\0\0⁸⁶-#ᶜa⁶.\0\0\0\0¹³⁷⁷⁸⁶-#ᶜc⁶.\0\0\0\0\0\0⁸「⁶-#ᶜ1⁶.\0\0██@@@@⁸⁶-#ᶜ8⁶.\0\0\0\0████⁸⁶-#ᶜa⁶.\0█@@    ²1ᶜ8⁶.<゛゜?○◝◝◝⁸⁶-#ᶜa⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜe⁶.らナナら█\0\0\0⁶-#ᶜ1⁶.⁸▮ @@███⁸⁶-#ᶜ8⁶.\0\0\0「8qqa⁸⁶-#ᶜa⁶.▮ @██\0\0\0⁸⁶-#ᶜe⁶.⁷ᶠ゜'⁷ᵉᵉ゛⁶-#ᶜa⁶.\0\0\0\0\0¹¹¹    \n    ⁶-#ᶜ9⁶.\0\0\0\0\0\0\0⁴⁸⁶-#ᶜa⁶.\0\0pヲュュュヲ⁶-#ᶜ9⁶.\0\0\0¹\0゛゛゜⁸⁶-#ᶜa⁶.ナナナらり▒▒\0⁸⁶-#ᶜc⁶.ᵉᵉ゛>>``ナ²a⁶.xxp00▮⁸⁸⁶-#ᶜ9⁶.\0p\0\0\0\0\0\0⁸⁶-#ᶜa⁶.³⁷◝◝◝◝◝◝⁸⁶-#ᶜc⁶.、⁸\0\0\0\0\0\0⁶-#ᶜ1⁶.@@██████⁸⁶-#ᶜ8⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0¹\0\0\0▮ ⁸⁶-#ᶜa⁶.  @CGOO_²8 ²8ᶜ1⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜe⁶.、ュュヲヲヲヲヲ⁶-#ᶜ1⁶.\0¹¹¹²⁴⁴⁴⁸⁶-#ᶜa⁶.¹²²²⁴⁸⁸⁸⁸⁶-#ᶜe⁶.\0\0\0\0¹³³³⁶-#    \n    ⁶-#ᶜ1⁶.\0\0\0\0\0\0ら0⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ9⁶.😐ュュヲヲ0\0\0⁸⁶-#ᶜa⁶.p\0\0\0\0ら0ᶜ²1ᶜ7⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0>◝⁸⁶-#ᶜ9⁶.???゜¹\0\0\0⁸⁶-#ᶜa⁶.\0\0\0\0゛¹\0\0⁸⁶-#ᶜc⁶.@ららナナナら\0²7ᶜ8⁶.\0\0\0\0\0\0⁷゜⁸⁶-#ᶜ9⁶.\0² \0\0\0\0\0⁸⁶-#ᶜa⁶.ワユら\0\0\0\0\0⁸⁶-#ᶜc⁶.⁸\r゜ユヨ◝ヲナ²1ᶜ8⁶.\0\0\0\0\0\0\0p⁸⁶-#ᶜa⁶.◝◝◝ユ🅾️、\0\0⁸⁶-#ᶜc⁶.\0\0\0ᶠqネん◆²1ᶜ2⁶.\0\0\0\0\0\0\0²⁸⁶-#ᶜ8⁶.\0\0\0\0らxゆュ⁸⁶-#ᶜ9⁶.   \0\0\0\0\0⁸⁶-#ᶜa⁶.___?⁷\0\0\0⁸⁶-#ᶜc⁶.\0\0\0\0\0\0¹¹²1ᶜ2⁶.\0\0\0\0\0\0█@⁸⁶-#ᶜ8⁶.◜◜◜◜◜◝○?⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0█²1ᶜ2⁶.\0\0\0\0\0¹\0\0⁸⁶-#ᶜ8⁶.⁷³³³¹\0\0\0⁸⁶-#ᶜe⁶.ヲュュュ◜ウエん⁶-#ᶜ1⁶.⁸⁸⁸⁸⁸⁸⁸⁷⁸⁶-#ᶜa⁶.▮▮▮▮▮▮▮⁸⁸⁶-#ᶜe⁶.⁷⁷⁷⁷⁷⁷⁷\0⁶-#    \n   ⁶-#ᶜ1⁶.\0\0\0█@  ▮⁸⁶-#ᶜ8⁶.\0\0\0\0█ららナ⁸⁶-#ᶜa⁶.\0\0█@ ▮▮⁸⁶-#ᶜ1⁶.ᶜ²¹\0\0\0\0\0⁸⁶-#ᶜ2⁶.\0\0█ららナユヲ⁸⁶-#ᶜ8⁶.ユュ~??゜ᶠ⁷⁸⁶-#ᶜa⁶.²¹\0\0\0\0\0\0²2ᶜ8⁶.ᶠ¹\0\0\0\0ユ◜²2⁶.\0\0\0█らヲ◝◝⁸⁶-#ᶜc⁶.█\0\0\0\0\0\0\0²2ᶜ8⁶.`ら█⬇️⁷ᶠᶠ゜⁸⁶-#ᶜc⁶.か?~|ヲユユナ²2ᶜ8⁶.◜ヲヲヲ「\0\0\0⁸⁶-#ᶜc⁶.¹⁷⁷⁷⁷⁷ᶠᶠ⁸⁶-#ᶜe⁶.\0\0\0\0\0ナユユ²2ᶜ1⁶.\0\0\0\0\0\0⁸ᶠ⁸⁶-#ᶜ8⁶.ᶠᶠ¹¹\0\0\0\0⁸⁶-#ᶜe⁶.らユヲ◜◝◝ワユ²1ᶜd⁶.\0\0\0\0\0\0、?⁸⁶-#ᶜe⁶.ん◝○◝◝◝ネ@⁶-#ᶜ1⁶.⁷⁷³²²¹¹\0⁸⁶-#ᶜa⁶.⁸⁸⁴⁴⁴²²¹⁸⁶-#ᶜe⁶.\0\0\0¹¹\0\0\0⁶-#    \n   ⁶-#ᶜ1⁶.▮⁸⁸⁸⁸⁸⁸⁸⁸⁶-#ᶜ8⁶.ナユユユユユユユ⁸⁶-#ᶜa⁶.⁸⁴⁴⁴⁴⁴⁴⁴²2ᶜ8⁶.⁷⁷♥んヤ◝◝◝²8  ²8ᶜ1⁶.\0\0⁸xpら\0\0⁸⁶-#ᶜ2⁶.、²¹¹²、ナ\0⁸⁶-#ᶜc⁶.ナら@\0█\0\0\0⁸⁶-#ᶜd⁶.\0\0██\0\0\0\0⁸⁶-#ᶜe⁶.\0<6⁶ᶜ \0\0²8ᶜ1⁶.█ららら\0\0¹⁶⁸⁶-#ᶜc⁶.゛。■0 \0\0 ⁸⁶-#ᶜd⁶.¹²ᵉᶠト◝◜ス⁸⁶-#ᶜe⁶.`  \0\0\0\0\0²1ᶜa⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜd⁶.らユx<ᶠ⁷ᶠᶠ⁸⁶-#ᶜe⁶.0\0\0\0\0\0\0\0⁶-#ᶜ1⁶.@ 」⁵³¹\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0█チ◜◝⁸⁶-#ᶜa⁶.█@ 「⁴²¹\0⁸⁶-#ᶜd⁶.?゜⁶²\0\0\0\0⁶-#ᶜ9⁶.\0\0\0\0³⁷⁷⁷⁸⁶-#ᶜa⁶.\0\0\0\0\0█らら⁶-#ᶜ9⁶.\0\0\0\0\0\0 ナ⁸⁶-#ᶜa⁶.\0\0\0\0⁷ᶠ゜゜⁶-#   \n   ⁶-#ᶜ1⁶.⁸⁸⁸▮▮▮`き⁸⁶-#ᶜ8⁶.ユユユナナナ█\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0⁷⁸⁶-#ᶜa⁶.⁴⁴⁴⁸⁸⁸▮▮⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0@²1ᶜ8⁶.◝◝◝◝◝◝◝◜²8  ᶜ2⁶.\0\0\0⁴Nノナら²8ᶜ1⁶.ュユ█\0\0\0\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0¹⁷ᶠ²8ᶜ1⁶.ᶠ⁷¹⁶「`█\0⁸⁶-#ᶜ9⁶.ら\0\0\0\0\0\0\0⁸⁶-#ᶜa⁶.0ヲ◜ヲナ█\0\0²1ᶜ9⁶.◝◜ヲユナナらら⁸⁶-#ᶜa⁶.\0¹⁷ᶠ゜゜?>⁶-#ᶜ9⁶.³³んんエエ◆◆⁸⁶-#ᶜa⁶.ら█\0\0\0\0\0\0²9⁶.゜ᶠ⁷\0\0\0\0\0⁶-#ᶜ9⁶.¹¹³³³³¹¹  \nᶜ8⁶.\0\0\0\0\0\0\0ら⁶.\0\0\0\0\0\0゜○⁶-#⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜ9⁶.███\0\0\0\0\0⁶-#ᶜ1⁶.@█\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0ヲ◜◝ニ⁸⁶-#ᶜ9⁶.ᶠᶠᶠ⁷\0\0\0゛⁸⁶-#ᶜa⁶. @█\0\0\0\0\0⁸⁶-#ᶜe⁶.█\0\0\0\0\0\0\0²1ᶜ8⁶.ュナ\0\0¹³ᶠ?⁸⁶-#ᶜa⁶.\0\0\0¹²ᶜ0ら⁸⁶-#ᶜe⁶.¹³゛ュユら\0\0²1ᶜ8⁶.◝◝ュ\0\0\0\0\0⁸⁶-#ᶜe⁶.\0\0\0³◝◝◝▤²1ᶜ8⁶.◝◝◝\0\0\0\0\0⁸⁶-#ᶜe⁶.\0\0\0\0◝◝れ⬇️²1ᶜ8⁶.◝◝◝◝ュユナら⁸⁶-#ᶜe⁶.\0\0\0\0\0³ᶠ゜²2ᶜ8⁶.み゜゜?◝◝◝◝⁶.◝◜ュヲナれ⁷⁷²2ᶜ1⁶.²⁴⁸▮ @@\0⁸⁶-#ᶜ8⁶.¹³⁷ᶠ゜?>|⁸⁶-#ᶜ9⁶.らららら█\0\0\0⁸⁶-#ᶜa⁶.<80 @█\0\0⁸⁶-#ᶜc⁶.\0\0\0\0\0\0██⁶-#ᶜ9⁶.ᶠᶠᶠ○◝ュヲヲ⁸⁶-#ᶜc⁶.\0\0\0\0\0³⁷⁷⁶-#ᶜ9⁶.◝<\0\0³ᶠ゜?⁶.\0\0\0\0\0ᵉ゜゜ᶜ8⁶.\0\0\0\0\0ユュ◜⁶.\0\0\0\0\0¹⁷ᶠ\n⁶.ナユヲヲュュュュ²8 ⁶-#⁶.`1;゜゜゜゜?⁸⁶-#ᶜ9⁶.█ららナナナナら²8⁶.G⬇️⬇️⬇️ん◝◝◝⁸⁶-#ᶜa⁶.8|||8\0\0\0²8ᶜ9⁶.█らナヨヨンンx⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0█²1ᶜ9⁶.\0⁷゜ᶠ⁷¹\0\0⁸⁶-#ᶜa⁶.⁷「 ユヲ◜◝◝²1⁶.\0\0\0¹³⁷ᶠᶠ⁸⁶-#ᶜe⁶.ᵉ「8ユナら██²1ᶜ8⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜe⁶.?|ュャュ◝◝◝²1ᶜ8⁶.◝◝◜◜ュュヲヲ⁸⁶-#ᶜe⁶.\0\0\0\0¹¹³³²2ᶜ8⁶.³⁷ᶠ゜?○◝○²2ᶜ7⁶.\0\0\0\0\0@`0⁸⁶-#ᶜ8⁶.|80▮\0\0\0\0⁸⁶-#ᶜc⁶.█ららナナぬ▤L⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0█²1ᶜ8⁶.\0\0\0⁴ᶜ「「8⁸⁶-#ᶜ9⁶.ヲヲユナら██\0⁸⁶-#ᶜa⁶.\0\0⁸▮ @@█⁸⁶-#ᶜc⁶.⁷⁷⁷³³⁷⁶⁶⁸⁶-#ᶜd⁶.\0\0\0\0\0\0¹¹⁶-#ᶜ9⁶.○◝゜⁷³¹¹\0⁸⁶-#ᶜa⁶.\0\0ナヲュ◜◜◝⁶-#ᶜ8⁶.\0█ュユナらら█⁸⁶-#ᶜ9⁶.゜ᵉ\0\0\0\0\0\0⁸⁶-#ᶜa⁶.\0\0³ᶠ゜??○²8 ⁶-#ᶜ8⁶.゜○◝◝◝◝◝◝\n⁶.ュ◝◝◝◝◝◝◝²8 ᶜ9⁶.ら█\0\0\0\0\0\0⁶.◝○゛\0\0█ナユ²8⁶.x8880???⁸⁶-#ᶜa⁶.█ららららららら²1⁶.◝◝◝◝◝◝◝?²1⁶.ᶠᶠᶠ⁷³¹\0\0⁸⁶-#ᶜe⁶.\0\0\0\0██るg²1⁶.◝◝◝◝◝れ😐♥²1ᶜ8⁶.ヲユユユユユユp⁸⁶-#ᶜc⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜe⁶.³⁷⁷⁷⁷⁷⁷⁷²2ᶜ7⁶.\0\0\0\0らら\0⁴⁸⁶-#ᶜ8⁶.????ᶠ³¹\0⁸⁶-#ᶜc⁶.\0\0█ら0<ゆい⁸⁶-#ᶜd⁶.\0\0\0\0\0\0@`²2ᶜ7⁶.▮ᶜ⁴¹¹\0\0\0⁸⁶-#ᶜc⁶.n3い🅾️●れりら⁸⁶-#ᶜd⁶.█ら```000²2ᶜ1⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.|xユナナららら⁸⁶-#ᶜc⁶.³³³³¹¹\0\0²1ᶜ8⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜa⁶.◝◝◜◜◜ュュュ²8⁶.○○○○??゜ᶠ  \n   ²8ᶜ9⁶.ヲュ◜◜◝○○?⁸⁶-#ᶜa⁶.\0\0\0\0\0██ら²1ᶜ9⁶.??⁷¹\0\0\0\0⁸⁶-#ᶜa⁶.ららヲ◜◝◝○\0⁸⁶-#ᶜc⁶.\0\0\0\0\0\0\0◝²1ᶜa⁶.゜ᶠ⁷³¹\0\0\0⁸⁶-#ᶜc⁶.\0\0\0\0\0\0ユ?⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜe⁶.らナユヲュ◜ᶠ\0²1ᶜc⁶.\0\0\0\0\0ュ◝<⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0れ⁸⁶-#ᶜe⁶.gリンョ◜³\0\0²1ᶜc⁶.\0\0らヲ○⁷ナ゜⁸⁶-#ᶜd⁶.\0\0\0\0█ヲ゜\0⁸⁶-#ᶜe⁶.⬇️⬇️¹¹\0\0\0ナ²1ᶜ8⁶.\0\0\0\0\0xxx⁸⁶-#ᶜc⁶.ユュ?ᶠ\0\0\0\0⁸⁶-#ᶜd⁶.\0\0@p○⁷\0\0⁸⁶-#ᶜe⁶.⁷³\0\0\0\0³³²1ᶜ8⁶.\0◜◝3333れ⁸⁶-#ᶜa⁶.\0\0\0アアアア<⁸⁶-#ᶜc⁶.¹\0\0\0\0\0\0\0²1ᶜ8⁶.\0◝◝³³33れ⁸⁶-#ᶜa⁶.\0\0\0ュュアア<²1ᶜ8⁶.\0◝◝³³33³⁸⁶-#ᶜa⁶.\0\0\0ュュアアュ²1ᶜ8⁶.\0ン◝ᶠᶠリリ3⁸⁶-#ᶜa⁶.⁴\0\0ユユᶜᶜᶜ²1ᶜ8⁶.\0◝◝3333れ⁸⁶-#ᶜa⁶.\0\0\0アアアア<²1ᶜ8⁶.◜ョャャャャャャ²8 \n   ²8ᶜ7⁶.\0\0\0\0\0\00000⁸⁶-#ᶜ9⁶.??゜ᵉᵉ⁴\0\0⁸⁶-#ᶜa⁶.@\0\0\0\0\0\0\0⁸⁶-#ᶜc⁶.█らナユユヲっL⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0█²1ᶜ7⁶.\0\0\0\0\0\0█\0⁸⁶-#ᶜc⁶.◝◝○³¹█@ユ⁸⁶-#ᶜd⁶.\0\0█ナユx<ᶜ⁸⁶-#ᶜe⁶.\0\0\0「ᶜ⁶³³²7ᶜc⁶.エフ0…ユp、⁷⁸⁶-#ᶜd⁶.0「ᶠ⁷³█ナx⁸⁶-#ᶜe⁶.\0\0\0\0\0\0\0█²cᶜd⁶.\0\0\0⁸⁶⁷³\0⁸⁶-#ᶜe⁶.\0\0らユヲヲュ◝²cᶜ1⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜe⁶.ヲュ◝◝◝◝◝○²cᶜ1⁶.🐱🐱🐱🐱ニ■	⁸⁸⁶-#ᶜ8⁶.<、ᶜ⁴⁶ヒロ7⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜe⁶.¹¹¹¹\0\0\0\0²8ᶜa⁶.<アアアア\0\0エ⁶.<アアアア\0\0エ⁶.ュアアアア\0\0エ²8ᶜ1⁶.ら\0\0\0\0\0\0\0⁸⁶-#ᶜa⁶.ᶜᶜᶜユユ\0\0ᶠ²8⁶.<アアアア\0\0エ²8ᶜ1⁶.⁴⁴⁴⁴、 @@⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0ᶜ²8 \n  ²8ᶜ1⁶.\0\0\0\0\0█`、⁸⁶-#ᶜa⁶.\0\0\0\0█`、³⁸⁶-#ᶜd⁶.\0\0\0\0\0\0█ナ²8ᶜ1⁶.\0\0\0ろるa`0⁸⁶-#ᶜa⁶.\0\0\0²¹\0\0\0⁸⁶-#ᶜc⁶.|<<「\0██ら⁸⁶-#ᶜd⁶.\0█ら <゛゜ᶠ⁸⁶-#ᶜe⁶.█@\0\0\0\0\0\0²1ᶜc⁶.◜◜◝○ᶠᶠ⁷⁷⁸⁶-#ᶜd⁶.\0¹\0██ららナ⁸⁶-#ᶜe⁶.¹\0\0\0\0\0\0\0²1ᶜc⁶.³¹\0\0\0\0\0\0⁸⁶-#ᶜd⁶.<>か◝◝○?゜⁸⁶-#ᶜe⁶.@@ \0\0\0\0 ²1ᶜc⁶.\0ら\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0¹\0¹\0\0\0\0⁸⁶-#ᶜe⁶.ナ゛ナナナナユユ²1ᶜ2⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ8⁶.\0██らナユユx⁸⁶-#ᶜc⁶.³ᶠᶠ⁷\0\0\0\0⁸⁶-#ᶜe⁶.|00「ᶠ⁷⁷³²1ᶜ8⁶.77777777⁸⁶-#ᶜa⁶.らららららららら²8⁶.エᶜᶜᶠᶠᶜᶜᶜ²8ᶜ1⁶.\0\0\00000000⁸⁶-#ᶜa⁶.エ³³³³³³³²8⁶.エれれれれれれれ⁶.ᶠアアエエアアᶜ²8ᶜ1⁶.\0\0\0ᶜᶜ\0\0\0⁸⁶-#ᶜa⁶.エららららららエ²8ᶜ1⁶.@@@@@@@@⁸⁶-#ᶜa⁶.ᶜᶜᶜ³³ᶜᶜᶜ²8 \n ²8ᶜ1⁶.\0█@ ▮⁸⁴²⁸⁶-#ᶜa⁶.█@ ▮⁸⁴²¹⁸⁶-#ᶜd⁶.\0\0█らナユヲュ²1ᶜc⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜd⁶.ュ◝◝◝◝◝○?²1ᶜc⁶.ナユヲヲ~?゜ᶠ⁸⁶-#ᶜd⁶.⁷⁷⁷⁷▒らナユ²1ᶜc⁶.³¹\0\0\0\0\0\0⁸⁶-#ᶜd⁶.ユヲュ◝◝◝◝◝²1⁶.⁷³³ᵇ³⁷³¹⁸⁶-#ᶜe⁶.▮▮⁸\0█ヲュ◜²1ᶜ2⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ8⁶.\0\0\0\0█らユx⁸⁶-#ᶜe⁶.ヲュ◜○?ᶠ⁷³²1ᶜ2⁶.@█ オナュ◝◝⁸⁶-#ᶜ8⁶.ま|テ/゜³\0\0⁸⁶-#ᶜe⁶.³¹\0\0\0\0\0\0²1ᶜ2⁶.⁵⁶ᶠ゜◝◝◝◝⁸⁶-#ᶜ8⁶.2ヨナ\0\0\0\0\0⁸⁶-#ᶜa⁶.ら\0\0\0\0\0\0\0²1ᶜ2⁶.\0\0\0`◝◝◝◝⁸⁶-#ᶜ8⁶.リ◝か\0\0\0\0\0⁸⁶-#ᶜa⁶.ᶜ\0\0\0\0\0\0\0²1ᶜ2⁶.\0\0000x◝◝◝◝⁸⁶-#ᶜ8⁶.アエ♥\0\0\0\0\0⁸⁶-#ᶜa⁶.³\0\0\0\0\0\0\0²1ᶜ2⁶.\0\0\0⁸ᶠᶠᶠᶠ⁸⁶-#ᶜ8⁶.<◝フ\0らららら⁸⁶-#ᶜa⁶.れ\0\0\0    ²1ᶜ8⁶.リ◝か`◝◝◝◝⁸⁶-#ᶜa⁶.ᶜ\0\0\0\0\0\0\0²1ᶜ8⁶.0◝◝\0◝◝◝◝⁸⁶-#ᶜa⁶.エ\0\0\0\0\0\0\0²1ᶜ8⁶.はよトナ◝◝◝◝⁸⁶-#ᶜa⁶.ᶜ\0\0\0\0\0\0\0²8 "
-->8
--battle sys

--menu select
bsel=1
bselpos={{34,108},{24,116},{58,116}}

-- initial variables
ens={30,10,30,10,30,10,30,10,30,10}
en_hp=0
en_cnt=1
hp=0
maxhp=20
plr_ded=false
en_ded=false
en_fright=false
mov_plr=0
mov_en=0
batt_cnt=0

--hit marker
en_hit=false
eoff=0
hitcnt=0
plr_hit=false
poff=0

--pos of target 
x1=22
y1=90
x2=100
y2=30
fx,dx=x1,x1
fy,dy=y1,y1

--★
trigbat=false
plr_turn=true
txt=split"bam!,bop!,bip!,kup!,wak!"
hitmsg=""
hittim=0

function drw_gameover()
	cls(8)
	cprint("d e d",64,7)
end


function drw_target()
	if hp>0 and en_hp>0 
	and not en_fright then
		if plr_turn then
			if bsel~=2 then
				dx=x2
				dy=y2
			else
				dx=x1
				dy=y1
			end
		else
			dx=x1
			dy=y1
		end
		
		fx+=(dx-fx)/10
		fy+=(dy-fy)/10
		
		circfill(fx,fy,13,6)
		circfill(fx,fy,12,7)
		circfill(fx,fy,10,2)
		circfill(fx,fy,8,7)
		circfill(fx,fy,6,2)
		circfill(fx,fy,4,7)
		circfill(fx,fy,2,8)
	end
end

function upd_battle()
	--timer
	if wait>0 then
		wait-=1
	end
	
	
	--plr health
	if hp<=0 then
			isgameover()
	else
		--plr selecting
		plr_choosing()
		--enemy
		en_action()
		backtogame()
	end
end

function isgameover()
		if wait<=0 then
			mov_plr=0
			mov_en=0
			plr_ded=false
			en_ded=false
			en_fright=false
			en_cnt=1
			
			_upd=upd_gameover
			_drw=drw_gameover
		end
end


function en_action()
	if not plr_turn then
		if wait<=0 then
			if rnd()<0.5 then
				attack()
			end
		end
	end
end

function plr_choosing()
	--select command
	if plr_turn then
		if btnp(⬆️) then
			bsel-=1
			if bsel==0 then
				bsel=3
			end
		elseif btnp(⬇️) then
			bsel+=1
			if bsel==4 then
				bsel=1
			end
		end
		
		if not en_ded then
			if not bswap then
				if btnp(❎) then
					chosen_action(bsel)
				end
			else
				if btnp(🅾️) then
					chosen_action(bsel)
				end
			end--bswap
		end--en_ded
	end--plr_turn
end

function chosen_action(b)
	if b==1 then
		wait=40
		attack()
	elseif b==2 then
		wait=40
		heal()
	elseif b==3 then
		wait=40
		fright()
	end
end

function attack()
	if plr_turn then
		atk_en()
	else
		atk_plr()
	end
end

function atk_plr()
	sfx(56)
	hp-=maxhp\6
	plr_hit=true
	hitcnt=7
	hitmsg=tostr(rnd(txt))
	hittim=20
	plr_turn=true
	if hp<=0 then
		hp=0
		plr_ded=true
		wait=120
	end
end

function atk_en()
	local pwr=1
	if gems_r>0 then
		gems_r-=1
		pwr=2
	end
	if en_hp>0 then
	sfx(56)
	en_hp-=(ens[en_cnt]/4)*pwr
	en_hit=true
	hitcnt=7
	hitmsg=tostr(rnd(txt))
	hittim=20
	plr_turn=false
	end
	--enemy health
	if en_hp<=0 then
		sfx(55)
		krak=false
		en_ded=true
		plr_turn=true
		wait=120
		backtogame()
		return
	end
end

function heal()
	if gems_g>0 then
		hp=maxhp
		gems_g-=1
		plr_turn=false
		bsel=1
		wait=60
		new_bubbs(30,90)
	end
end

function fright()
	if gems_o>0 then
		if en_hp>0 then
			sfx(55)
			krak=false
			en_ded=true
			en_fright=true
			wait=120
			backtogame()
			gems_o-=1
		end
	end
end

function backtogame()
	if wait<=0 and not krak then
		mov_en=0
		en_ded=false
		en_fright=false
		en_cnt+=1
		trigbat=false
		_upd=upd_game
		_drw=drw_game
	end
end

function upd_battleintro()
	if t>500 then
		t=0
	else
		t+=1
	end
	
	if wait>0 then
		wait-=1
		if wait%2==0 then
			new_mov_bubbs(100)
		end
	else
		devspeed=0
		develop=0
		shake=0
		en_hp=ens[en_cnt]
		_upd=upd_kraken
		_drw=drw_kraken
	end
	fadeeff(5)
	upd_bubbs()
end

function drw_battleintro()
	cls(1)
	fadepal((100-develop)/100)
	drw_bubbs()
	?sp_tentacle,0,3+sin(t*0.02)/0.6
end
__gfx__
00544455550000544455550000544455550000555555550000511111150000770000022200000000022200000000111100000000011110000000001111000000
0549d4ddd5500549d488d5500549d4ddd55005dddddddd5005199444415007776000020200000000020200000001111110000000111111000000011111100000
549d4ddd5d52549d4d825d55249d4ddd5d525dddddaa9dd2519111111412711116000020000000000020000000117fff1100000117aaa1100000117aaa110000
9d4dddd5ddd29d4d1871ddd52d4dded5ddd29dddaa994dd21411111111417171160002020000000002020000011788eef1110011733bba111001174499a11100
9dd555ddd2d39dd18888d2853dd5efe112d39ddff99422d2121111111141701707000222000000000222000011788888ef11011733333ba110117444449a1100
5d511d222db35d58898878853deeaeeee1b35df212142dd21211111111416011070222222222222222222201178eff8e8ef11173baa3b3ba111749aa4949a100
5d1dd22bb3325d118a9841152d1eeeee13325df219122dd2121111111141167771222a992a992a9922a922211e8eef2288e111b3bba1133b1119499a22449100
5dddd22333215dd1888413251d14414413215d2f9922dd21121111111121111111222911291129992911222011e8ee288e11011b3bb133b11011949924491100
5ddd22b332155ddd114132155dd1111132155d22222d22151211111111210111102229222992291921992220011e8888e1100011b3333b110001194444911000
55223311211555223311211555223111211555222222211551211111121500000022292929122929222922200011e88e110000011b33b1100000119449110000
055222221150055222221150055222221150055222221150051222222150000000222999299929292991222000011ee11000000011bb11000000011991100000
00555555550000555555550000555555550000555555550000511111150000000022211121112121211222200000111100000000011110000000001111000000
00000000000000000000000000000000000011111111100000000000000000000012211121112121211222100000000000000000000000000000000110000000
00000000000000000000555500000000000017777777100000000000000000000001111111111111111111000000000000000000000000000000000000000000
0000000000000000005555550000000000001755576110000000a900000000000000a9000000000000000000000000a000000000000000000000000000000000
000000000000000055500055550000000000175756110000000aa99000000000000aa99000000000000000000000000000000000000000000000000000000000
0000000055000055500000005500000000001d7561100000aaaaaaaaaa000000aaaaaaaaaa00000000000000000000a000000000000000000000000000000000
0000000005555550000000005500000000001d771100000a1111111111a0000a1111111111a0000000000000000000a00000000cc000000000aaaaaaa0000000
0000000000000000000000055500000000001c111000000a11cccccc11a0000a11cccccc11a0000000000000000000a0000000ccc0000000aa8888888aa00000
0000000000000000000000055000000000001c11000000aa1c88888dc1aa00aa1c11cc11c1aa000000000000000000a0000000ccc00000aa88888888888a0000
0000000000000000000000555000000000001c1100000aaa1c8aaa8dc1aaaaaa1c1a1191c1aaa0000000000000000a900000000cc0000a88888888282888a000
00000000000000000000005550000555550011110000049a1c8a8a8dc1a9449a1cc1a91cc1a940000000000090000990000000000000a8888888828282282a00
0000000000000000000000555005555555500000000000491cc8a8dcc19400491cc1991cc1940000000a00000900000000000000000a88888888888828828a00
0000000000000000000000555055550555550000000000041ccc8dccc14000041c1a1191c14000000000a0000000000000000000000a888888eaaeee82282a00
0000000000000000000000055555000005550000000000041d111111d14000041d111111d140000000000a990000aaa000ccc000000a88888ea00aeee8828a00
00000000000000000000000555500000005500000000000911dddddd1140000911dddddd114000000000099000aa777000cccc0000a88888ea000aeee2282a00
00000000000000000000000000000000000500000000000911111111114000091111111111400000000009000a77777000cccc0000a88888ea000aeee2222a00
0000000000000000000000000000000000000000000000009999999444000000999999944400000000900000a7a77770000cccc000a88888a00aaaee22222a00
000000000000000000000000000000000000000000000000000aa94000000000000aa94000000000000900097aaaaaa0000000c0000a8888a00a22e222222a00
0000000000000000000000000000111100000000000000000000a400000000000000a4000000000000000009aaaaaaa000000000000a88888a0a22222222a000
000000000000000000000000001122441100000000000000000000000000000000000000000000000000009aaaaaaaa0000000000000a8888a00a222222a0000
00000000000000000000000001224222221000000a22a222ad0d00d00dd0dd000000000000000000000a909aaaaaaaa0000000000000a88888a00aaaaaa00000
00000000000000000000000012442222222100000a91a911ad0d0d0d000d00000000000000000a0aaaa9909aaaaaaaa00000000000000a8888a0000000000000
00000000000000000000000122422211222100000a91a911a0d0d000d00000000000000000000000000a904aaaaaaaa000000000000000a8888a000000000000
00000000000000000000001244221100121100000aaaaaaaa000000000000000000000000000000000000004aaaaaaa0000000000000000a8888a00000000000
00000000000000000000012442210000011100000aa999999000000000000000000000000000000000000004aaaaaaa00000000000000000a2888a0000000000
00000000000000000000122222100000001100000aa1111990000000000000000000000000000000000900004aaaaaa000000000000000000a2888a000000000
00000000000000000001242221000000000100000a991889900000000000000000000000000000000090000004aaaaa000000000000000000a22888a00000000
00000000000000000012422210000000000000000aaa9999a0000000000000000000000000000000000009000044aaa0000000aaaaaaa00000a22888a0000000
000000000000000001242221000000000000000000007fff0000007aaa0000007aaa000a99a00000000009900000444000000a8888888aa000a22288a0000000
0000000000000000111222100000000000000000000788eef0000733bba000074499a00a99a0000000000a99000000000000a8888888888a00a22288da000000
000000000000000011111100000000000000000000788888ef00733333ba007444449a0a99a000000000a00000000990000a888888888888aa222288da000000
0000000000000001122211000000000000000000078eff8e8ef73baa3b3ba749aa4949aa99a00000000a000009000a9000a888888888888822222888eda00000
00000000000000011442210000000000000000000e8eef2288eb3bba1133b9499a22449a999a000000000000900000a000a888888888888888228888eea00000
000000000000011442222100000000000000000000e8ee288e00b3bb133b00949924490aa999a00000000000000000a00a888888888888888888888eeeda0000
0000000000011444942221100000000000000000000e8888e0000b3333b00009444490000aa9a00000000000000000a00a8888888eeeeeeee888888eeeea0000
00000000011144994422199110000000000000000000e88e000000b33b00000094490000000aa00000000000000000a0a888888eeedddeeeee8888eeeeea0000
000000001991299442211999911000000000000000000ee00000000bb000000009900000000000000000000000000000a888888eeddddddeddddddeeddda0000
0000001199aa1222221199999991000000000000000000000000000000000000000000000000000000000000000000a0a88888eeeddaaaadd11111dd11a00000
00000199aaaaa11111aaa994999a10000000000000000000000000000000000007d0000000000000000000000000000a888888eedda0000a111111dd11a00000
0000199aaaaaaaaaaaaaaa994999a1000000000000000000000000000000000117d0000000000000000000000000000a828288eedda00000a17711d11a000000
0000199aaa7777aaaaaaaa9944499a100000000000000000000000000000000017d0000000000000000000000000000a882888ededa000000aa71dd1a0000000
000199aaaa7777aaaaaaaaa9944499100000000000000000000000000000000100d0000000000000000000000000000a8888888edda00000000aaaaa00000000
001999aaaa7777aaaaaaaaa9944449a10000000000000000000000000000000000d0000000000000000000000000000a8828288dedda00000000000000000000
00199aaa4444444aaaaaaaaa944449a100000000000000000000000bbb30000000d00000000000000000000000000000a882888ededa00000000000000000000
01999aa4444444444aaaaaaa9944999a1000000000000000000000bbb333ffff00d00000000000000000000000000000a888888eeeeda0000000000000000000
01999a444499994444aaaaaa999999991000000000000000000000bb3333f00440d000000000000000000000000000000a888288eeeeea000000000000000000
0199944444111194444aaaaa99999999100000000000000000000006666ff666666600000000000000000000000000000a882288eee11ea00000000000000000
1999944411c1c1199444aaaa99999222210000000000000000000067777f76666666600000000000000000000000000000a888888e1111eaa000000000000000
199944444c11114419444aa999992422210000000000000000000677777f76dddd77d00000000000000666660000000000a8888888d1177eea00000000000000
1999441444111441119444a999924422221000000000000000000677777ff6ddd771d000000000000660756600000000000a8888888d1771deaa000000000000
1994441c4491441111944499992444422210000000000000000006771dddff6d7d11d0000000000660055945000000000000a888888d1111deeeaa0000000000
1994417114494111111942999944422112100000000000000000226611dd7446666660000000066005599445000000000000a8888888ed11deeeeea000000000
199441c1114491111119429992442111121000000000000000020aa9677776442888800000006005599444550000000000000a8888888edddeeeeeea00000000
01944111122449111119429992442221121000000000000000020a116777866222228400006604599444445500000000000000a888888eeeeeeeee11aa000000
01944111421144411119429992422442121000000000000000005a996668786111111dd00600559444444554000000000000000a888888eeeeeeeee117a00000
019944144211144411942244424211421210000000000000000555115666866626612ddd66559444444445540000000000000000a888888eeee11eed177a0000
001944442111114441942299924211242100000000000000994f4444f449999999999999559449444444554000000000000000000a88888eeee1111ed11a0000
001994421111111149422999924221122100000000000009944444444444444444499995444999944455554000000000000000000a888888eee11771ed11a000
0001924411111111944224992244222210000000000000099999999999999999999995599999995555555550000000000000000000a888888eed1771de11da00
0000192449111199422244422224442111000000000000099999999999999999999559999999555555555500000000000000000000a8888888ee1111deddea00
000019924499994422244442222221111d1100000003333559999999999999999559999999555554455440000000000000000000000a888288eed111deeeeda0
00001199224444222244442222441111dddd08e000333334955555555555555555555555555599445544000000000000000000000000a82828eed111deeeeda0
0000166d94222224444442222411111ddddd8e8803310004999999999999995999999999999944455444000000000000000000000000a888288eedddeeeeeeda
000166dd19444444444422224111111dd666888803100000444444444444554444444444444444554440000000000000000000000000a822828eeeeeeeeeeeda
000166ddd119444442222241111111dd666622220000002222222222225522222222222222222222222222220000000000000000000a88888888eeeeeeedeedd
0016666dddd111222222111111111dd6666602200000000441111111551111111114441141144104000000000000000000000000000a88222828edee11ded11d
006666dddddd11111111111111111ddd66660000000000000000000000000000000000000000000000000000000000000000000000a882888288ded111ed111d
00666dddddd11111111111111111ddddd666000000000000000000000000000000000000000000000000000000000000000000000a222822282ddde177d1177d
0066dddddd11111111111111111111ddddd600000000000000000000000000000000000000000000000000000000000000000000a2222222222ede1177d1177d
006dddddd111111111111111111111111ddd000000000000000000000000000000000000000000000000000000000000000000aa2222222222edd11111d1111d
000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000eeeee22222222222222222222222222222222222222eeeeee000000000000000000000000000000000000000000000
000000000000000000000000000000000e22222222aaa2aaa2aaa22aa2aaa22aa2aa22aaa2222222222e00000000000000000000000000000000000000000000
0000000000000000000000000000000ee222222222a112a112aaa2a1121a12a1a2a1a2a1122222222222ee000000000000000000000000000000000000000000
00000000000000000000000000000002222aaaaa22a112aa12a1a2aaa21a12a1a2a1a2aa222aaaaa222222000000000000000000000000000000000000000000
00000000000000000000000000eeeee222222a9922a2a2a122a1a211a22a22a2a2a2a2a122299a22222222eeee00000000000000000000000000000000000000
00000000000000eeeeeeeeeeee2222222222211122aa92aa9292929a1229229a1292929aa22111222222222222eeeeeeeeeeeee000000000000000a0000000a0
000000000000018888222222222222222222211122111211121212111221221112121211122111222222222222222222222888810000000000000aa0000000aa
00000000000001888222222222222222222222222211121112121211222122112212121112222222222222222222222222228881000000000000000a00000a00
000000000000018822222222222aa992222aa999922aa999922aa99222222aa9922aa999922aa99222222aa9922222222222288100000000000000000aaa0000
1eeeeeee2222218222aaa22222299992222999999229999992299992222229999229999992299992222229999222222aaa22228122222eeeeeee1000a0a0a000
11ee2222222221222292922222299119922991199229911112299119922991111221199112299119922991111222222929222221222222222ee11000aa0aa000
0111222222221122222a2222222991199229911992299111122991199229911112211991122991199229911112222222a2222221222222222111000000000000
0011122222221122222a22222229922992299a9112299992222992299229922222222992222992299229922222222222a222222112222222111000000aaa0000
0000112222221122222a2222222992299229999112299992222992299229922222222992222992299229922222222222a2222221122222211000000a00000a00
000001112222112aa22a22aa22299229922991199229911222299229922992299222299222299229922992299222aa22a22aa2211222211100000aa0000000aa
0000001112221129222a2229222992299229911992299112222992299229922992222992222992299229922992229222a222922112221110000000a0000000a0
0000000011121129222a22292229999992299229922999999229999a9229999a92299999922992299229999a92229222a2229221121110000000000000000000
0000000001121122922a2292222999999229922992299999922999999229999992299999922992299229999992222922a2292221121100000000000000000000
000000000002112229aaa92222211111122112211221111112211111122111111221111112211221122111111222229aaa922221120000000000000000000000
0000000000021182229a9222222111111221122112211111122111111221111112211111122112211221111112222229a9222281120000000000000000000000
00000000000211882229222222222222222222222222222222222222222222222222222222222222222222222222222292222881120000000000000000011100
00000000022211888222222222222222222222222222222222222222222222222222222222222222222222222222222222228881122200000000000000177100
00000002222211888822222222111111111111111111111111111111111111111111111111111111111111111122222222288881122222000000000001771100
00000222222211111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111122222220000000017771000
00122222222221111122111111000000000000000000000000000000000000000000000000000000000000000011111122111111222222222210000001661100
00111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111110000000166100
00111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111100000000011100
68888d555500051111115000000000a9000000001111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
68a80d51500051222222150000000aa9900000018888888100000000000000000000000000000000000000000000000000000000000000000000000000000000
78800155000512282822212000aaaaaaaaaa00018aaa841100000000000000000000000000000000000000000000000000000000000000000000000000000000
7000010000012222222222100a1111111111a0018a8a411000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000100000122a8828a22100a1111111110a00148a4110000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001228a82882210aa1000000000aa014881100000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001a2888222281aaa1000000000aaa17111000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001a222822228149a1000000000a9417100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000182222282281149100000000094117100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000051a282822a15014100000000041011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000005188888a150004100000000041000007100000077000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005111111500009100000000041005599655000019900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000009100000000041000557650005576000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000001999999944410000577500055770000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000111aa94111100dd777000dd7770000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000111a4111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666222666666666222666666c
c666544455556666544455556666544455556666544455556666544455556666544455556666544455556666544455556666666666262666666666262666666c
c66549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d488d5566549d4ddd55666666666626666666666626666666c
c6249d4ddd5d52549d4ddd5d52249d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4d825d55549d4ddd5d5266666666262666666666262666666c
c62d4dded5ddd29d4dddd5ddd22d4dded5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4d1871ddd59d4dddd5ddd266666666222666666666222666666c
c63dd5efe112d39dd555ddd2d33dd5efe112d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd18888d2859dd555ddd2d316666622222222222222222226666c
c63deeaeeee1b35d511d222db33deeaeeee1b35d511d222db35d511d222db35d511d222db35d58898878855d511d222db316666222a992a992a9922a9222666c
c62d1eeeee13325d1dd22888322d1eeeee13325d1dd22888325d1dd22bb3325d1dd22bb3325d118a9841155d1dd22bb33216666222911291129992911222666c
c61d14414413215dddd28888811d14414413215dddd28888815dddd22333215dddd22333215dd1888413255dddd223332116666222922299229192199222666c
c65dd1111132155ddd228888855dd1111132155ddd228888855ddd22b332155ddd22b332155ddd114132155ddd22b3321516666222929291229292229222666c
c655223111211555223388888555223111211555223388888555223311211555223311211555223311211555223311211516666222999299929292991222666c
c665522222115115522228885115522222115115522228885115522222115115522222115115522222115115522222115116666222111211121212112222666c
c666555555551116555555551116555555551116555555551116555555551116555555551116555555551116555555551116666122111211121212112221666c
c666544455551166555555551166544455551166544455551166544455551166544455551166544455551166544455551166666611111111111111111116666c
c66549d4ddd55665dddddddd566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd55666666666666666666666666666666c
c6549d4ddd5d525dddddaa9dd2549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d5266666666661111666666666666666c
c69d4dddd5ddd29dddaa994dd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd266666666611111166666666666666c
c69dd555ddd2d39ddff99422d29dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d316666666117fff116666666666666c
c65d511d222db35df212142dd25d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db3166666611788eef11111111116666c
c65d1dd22bb3325df2191888d25d1dd22bb3325d1dd22bb3325d1dd22888325d1dd22bb3325d1dd22bb3325d1dd22bb33216666611788888ef111eeeef16666c
c65dddd22333215d2f998888815dddd22333215dddd22333215dddd28888815dddd22333215dddd22333215dddd2233321166661178eff8e8ef11e222e16666c
c65ddd22b332155d22228888855ddd22b332155ddd22b332155ddd228888855ddd22b332155ddd22b332155ddd22b332151666611e8eef2288e11e2e2e16666c
c655223311211555222288888555223311211555223311211555223388888555223311211555223311211555223311211516666611e8ee288e111e2e2e16666c
c6655222221151155222288851155222221151155222221151155222288851155222221151155222221151155222221151166666611e8888e1161e2e2e16666c
c66655555555111655555555111655555555111655555555111655555555111655555555111655555555111655555555111666666611e88e11661e222e16666c
c666544455551166555555551166544455551166544455551166544455551166544455551166544455551166544455551166666666611ee116661feeee16666c
c66549d488d55665dddddddd566549d488d5566549d4ddd5566549d4ddd5566549d4ddd5566549d488d5566549d4ddd55666666666661111666611111116666c
c6549d4d825d555dddddaa9dd2549d4d825d55249d4ddd5d52549d4ddd5d52249d4ddd5d52549d4d825d55549d4ddd5d5266666666661111666666111116666c
c69d4d1871ddd59dddaa994dd29d4d1871ddd52d4dded5ddd29d4dddd5ddd22d4dded5ddd29d4d1871ddd59d4dddd5ddd266666666611111166666666666666c
c69dd18888d2859ddff99422d29dd18888d2853dd5efe112d39dd555ddd2d33dd5efe112d39dd18888d2859dd555ddd2d316666666117aaa116666666666666c
c65d58898878855df212142dd25d58898878853deeaeeee1b35d511d222db33deeaeeee1b35d58898878855d511d222db3166666611733bba11111111116666c
c65d118a9841155df219122dd25d118a9841152d1eeeee13325d1dd22bb3322d1eeeee13325d118a9841155d1dd22bb33216666611733333ba111bbbba16666c
c65dd1888413255d2f9922dd215dd1888413251d14414413215dddd22333211d14414413215dd1888413255dddd2233321166661173baa3b3ba11b333b16666c
c65ddd114132155d22222d22155ddd114132155dd1111132155ddd22b332155dd1111132155ddd114132155ddd22b332151666611b3bba1133b11b3b3b16666c
c655223311211555222222211555223311211555223111211555223311211555223111211555223311211555223311211516666611b3bb133b111b3b3b16666c
c665522222115115522222115115522222115115522a921151155222221151155222221151155222221151155222221151166666611b3333b1161b3b3b16666c
c66655555555111655555555111655555555111655aa9955111655555555111655555555111655555555111655555555111666666611b33b11661b333b16666c
c66654445555116654445555116655555555116aaaaaaaaaa1665444555511665444555511665444555511665444555511666666c6611bb116661abbbb16666c
c66549d4ddd5566549d4ddd55665dddddddd56a1111111111a6549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd55666666c6c661111666611111116666c
c6549d4ddd5d52549d4ddd5d525dddddaa9dd2a1111111115a249d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d526666c6c6c61111666666111116666c
c69d4dddd5ddd29d4dddd5ddd29dddaa994ddaa14dddd5dddaad4dded5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd266666c6c611111166c6c6c6c6c6c6c
c69dd555ddd2d39dd555ddd2d39ddff99422aaa1d555ddd2daaad5efe112d39dd555ddd2d39dd555ddd2d39dd555ddd2d3166666c6117aaa11c6c6c6c6c6c6cc
c65d511d222db35d511d222db35df212142d49a1511d222dba94eeaeeee1b35d511d222db35d511d222db35d511d222db316666661174499a1111111111c6c6c
c65d1dd22bb3325d1dd22bb3325df219122d14911dd22bb339411eeeee13325d1dd22bb3325d1dd22bb3325d1dd22bb332166666117444449a1119999a16c6cc
c65dddd22333215dddd22333215d2f9922dd2141ddd22333241d14414413215dddd22333215dddd22333215dddd22333211666611749aa4949a11944491c6c6c
c65ddd22b332155ddd22b332155d22222d221541dd22b332141dd1111132155ddd22b332155ddd22b332155ddd22b3321516666119499a22449119494916c6cc
c65522331121155522331121155522222221159122331121141522311121155522331121155522331121155522331121151666661194992449111949491c6c6c
c665522222115115522222115115522222115191522222115415522222115115522222115115522222115115522222115116666661194444911619494916c6cc
c666555555551116555555551116555555551119999999444116555555551116555555551116555555551116555555551116666666119449116c1944491c6c6c
c66654445555116655555555116654445555116111aa9411116654445555116655555555116655555555116654445555116666666661199116c61a999916c6cc
c66549d4ddd55665dddddddd566549d4ddd55665111a4111166549d4ddd55665dddddddd5665dddddddd566549d4ddd556666666666611116c6c1111111c6c6c
c6549d4ddd5d525dddddaa9dd2549d4ddd5d525ddd11119dd2549d4ddd5d525dddddaa9dd25dddddaa9dd2549d4ddd5d5266666666666116c6c6c6111116c6cc
c69d4dddd5ddd29dddaa994dd29d4dddd5ddd29ddda1194dd29d4dddd5ddd29dddaa994dd29dddaa994dd29d4dddd5ddd26666666666666c6c6c6c6c6c6c6c6c
c69dd555ddd2d39ddff99422d29dd555ddd2d39ddff99422d29dd555ddd2d39ddff99422d29ddff99422d29dd555ddd2d316666666666666c6c6c6c6c6c6c6cc
c65d511d222db35df212142dd25d511d222db35df212142dd25d511d222db35df212142dd25df212142dd25d511d222db31666666666666c6c6c6c6c6c6c6c6c
c65d1dd22bb3325df2191888d25d1dd22bb3325df219122dd25d1dd22888325df219122dd25df219122dd25d1dd22bb332166666c6666666c6c6c6c6c6c6c6cc
c65dddd22333215d2f998888815dddd22333215d2f9922dd215dddd28888815d2f9922dd215d2f9922dd215dddd2233321166c6c6c6c66666c6c6c6c6c6c6c6c
c65ddd22b332155d22228888855ddd22b332155d22222d22155ddd228888855d22222d22155d22222d22155ddd22b332151666c6c6c6666666c6c6c6c6c6c6cc
c6552233112115552222888885552233112115552222222115552233888885552222222115552222222115552233112115166c6c6c6c6666666c6c6c6c6c6c6c
c665522222115115522228885115522222115115522222115115522228885115522222115115522222115115522222115116c6c6c6c6c655556666c6c6c6666c
c6665555555511165555555511165555555511165555555511165555555511165555555511165555555511165555555511166c6c6c6c5555556666666666666c
c66655555555116654445555116654445555116654445555116654445555116654445555116654445555116654445555116666c6c6555666555566666666666c
c665dddddddd566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d488d556556c6c555c6666665566666666666c
c65dddddaa9dd2549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4d825d5565555556666666665566666666666c
c69dddaa994dd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4d1871ddd566666666666666655566666666666c
c69ddff99422d29dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd18888d28516666666666666655666666666666c
c65df212142dd25d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d58898878851666666666666c555c6c6c6c6c666c
c65df219122dd25d1dd22888325d1dd22888325d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22bb3325d118a98411516666666c6c6c65556c6c55555c6cc
c65d2f9922dd215dddd28888815dddd28888815dddd22333215dddd22333215dddd22333215dddd22333215dd18884132516666c6c6c6c6c555c655555555c6c
c65d22222d22155ddd228888855ddd228888855ddd22b332155ddd22b332155ddd22b332155ddd22b332155ddd1141321516c6c6c6c6c6c655565555c55555cc
c65522222221155522338888855522338888855522331121155522331121155522331121155522331121155522331121151c6c6c6c6c6c6c6555556c6c65556c
c665522222115115522228885115522228885115522222115115522222115115522222115115522222115115522222115116c6c6c6c6c6c6c55556c6c6c655cc
c66655555555111655555555111655555555111655555555111655555555111655555555111655555555111655555555111c6c6c6c6c6c6c6c6c6c6c6c6c656c
c6665444555511665444555511665444555511665444555511665444555511665444555511665444555511665444555511c6c6c6c6c6c6c6c6c616c616c6c6cc
c66549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd55c6c6c1c6c6c6c6c6c1c6c1c6c6c6c6c
c6249d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52c616c616c6c6c6c6c616c6c6c6c6cc
c62d4dded5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd26c6c1c6c1c6c6c6c1c6c11111c6c6c
c63dd5efe112d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d31616c616c616c616c61112244116cc
c63deeaeeee1b35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db31c6c1c6c1c6c1c6c1c12242222211c
c62d1eeeee13325d1dd22888325d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22bb3321616c616c616c616c124422222221c
c61d14414413215dddd28888815dddd22333215dddd22333215dddd22333215dddd22333215dddd22333215dddd22333211c6c1c6c1c6c1c6c1224222112221c
c65dd1111132155ddd228888855ddd22b332155ddd22b332155ddd22b332155ddd22b332155ddd22b332155ddd22b332151616c616c616c61124422116c1211c
c65522311121155522338888855522331121155522331121155522331121155522331121155522331121155522331121151c6c1c6c1c6c1c1244221c6c1c111c
c66552222211511552222888511552222211511552222211511552222211511552222211511552222211511552222211511616c616c616c1222221c616c6111c
c66655555555111655555555111655555555111655555555111655555555111655555555111655555555111c55555555111c6c1c6c1c6c1242221c1c6c1c6c1c
c6665444555511665444555511665444555511665444555511665444555511665444555511665444555511c65444555511c616c616c6112422211111111616cc
c66549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd5566549d4ddd55c6549d4ddd55c1c6c1c6c1c1242221111111111111c
c6549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52549d4ddd5d52c616c611111122211111111111111c
c69d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd29d4dddd5ddd21c6c1111111111111111111111111c
c19dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d39dd555ddd2d311111111112221111111111111111c
c15d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db35d511d222db311111111114422111111111111111c
c15d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22888325d1dd22bb3325d1dd22bb3325d1dd22bb3325d1dd22bb33211111111442222111111111111111c
c15dddd22333215dddd22333215dddd22333215dddd28888815dddd22333215dddd22333215dddd22333215dddd223332111111144494222111111111111111c
c15ddd22b332155ddd22b332155ddd22b332155ddd228888855ddd22b332155ddd22b332155ddd22b332155ddd22b3321511111449944221991111111111111c
c155223311211555223311211555223311211555223388888555223311211555223311211555223311211555223311211511991299442211999911111111111c
c1155222221151155222221151155222221151155222288851155222221151155222221151155222221151155222221151199aa122222119999999111111111c
c11155555555111155555555111155555555111155555555111155555555111155555555111155555555111155555555199aaaaa11111aaa994999a11111111c
c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111199aaaaaaaaaaaaaaa994999a1111111c
c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111199aaa7777aaaaaaaa9944499a111111c
c111222222222222222222222222222222222222222222222222222222222222222222222222222222222222222111199aaaa7777aaaaaaaaa9944499111111c
c1122eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2211999aaaa7777aaaaaaaaa9944449a11111c
c122e2222222222222222222222222222222222222222222222222222222222222222222222222222222222222e22199aaa4444444aaaaaaaaa944449a11111c
c12e2eee2222222222222222222222222222222222222222222222222222222222222222222222222222222eee2e1999aa4444444444aaaaaaa9944999a1111c
c12e2ee222222222222222222222222222222222222222222222222222222222222772222222222222222222ee2e1999a444499994444aaaaaa999999991111c
c12e2e22222222222222222222222222222222222222222222222222222222222277762222222222222222222e2e199944444111194444aaaaa999999991111c
c12e2222aa22aa22aa2aaa2aaa22222aaa2222222222222222222222222222222711116222727222222222222221999944411c1c1199444aaaa999992222111c
c12e222a112a112a1a2a1a2a1122222a1a222222222222222222222222222222271711622272722222222222222199944444c11114419444aa9999924222111c
c12e222aaa2a112a1a2aa12aa122222a1a2222222222222222222222222222222721727222777222222222222221999441444111441119444a9999244222211c
c12e22211a2a222a2a2a1a2a1222222a2a2222222222222222222222222222222621127222117222222222222221994441c4491441111944499992444422211c
c12e2229a1219a29a1291929aa22222aaa222222222222222222222222222222216777122211722222222222222199441711449411111194299994442211211c
c12e222111211121112121211122222111222222222222222222222222222222211111122222122222222222222199441c11144911111194299924421111211c
c12e222112221121122121211122222111222222222222222222222222222222221111222222122222222222222e19441111224491111194299924422211211c
c12e222222222222222222222222222222222222222222222222222222222222222222222222222222222222222e19441114211444111194299924224421211c
c12e222222222222222222222222222222222222222222222222222222222222222222222222222222222222222e19944144211144411942244424211421211c
c12e222222222222222688882688882688882688882688882688882688882688882688882688882222222222222e21944442111114441942299924211242111c
c12e22222222222222268a82268a82268a82268a82268a82268a82268a82268a82268a82268a822222222222222e21994421111111149422999924221122111c
c12e2e22222222222227882227882227882227882227882227882227882227882227882227882222222222222e2e21192441111111194422499224422221111c
c12e2ee222222222222722222722222722222722222722222722222722222722222722222722222222222222ee2e21119244911119942224442222444211111c
c12e2eee2222222222272222272222272222272222272222272222272222272222272222272222222222222eee2e21119924499994422244442222221111d11c
c122e2222222222222222222222222222222222222222222222222222222222222222222222222222222222222e22111199224444222244442222441111ddddc
c1122eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22111166d94222224444442222411111dddddc
c111222222222222222222222222222222222222222222222222222222222222222222222222222222222222222111166dd19444444444422224111111dd666c
c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111166ddd119444442222241111111dd6666c
c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111116666dddd111222222111111111dd66666c
c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111116666dddddd11111111111111111ddd6666c
c11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111666dddddd11111111111111111ddddd666c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

__sfx__
451e0000004100041102411024110f414124151541515415154151541515415124150c4151541515415154150c4150c4150c415154151541312414124140f4150f4150f415124150e4150c4110c4110000200000
711e00000302303023030200302003020030230002300023000230302306023060230602303023030230002300023000230002000020000200302303023060230602303023030200002300020000230002300023
b91e00001e72524725277252772527725247251e7251b7251b7251e7251e7251e7231e7231e7251b725187251872518725187251b725217251b725157250c725097250c7250c7250c7230c723097250972309725
391e00001572015722127200c720097200972209722097200c72012720127211272012720127221572218720187201572112720127201272012722127221872018720187211b7201b7201872012722127220f720
311e00000c0140c0140c0140f0110f011120121501215012150151501515015120150c0121501215012150120c0110c0110c011150121501212012120150f0150f0150f015120151201512012150151501515015
cd1e00000311303113031100311003110031130011300113001130311306113061130611303113031130011300113001130011000110001100311303113061130611303113031100011300110001130011300113
d51e0000000140001402013040140301406011060110601103012000120001202013040130301206012060120301200012000120001202012040120301206012060120901309013060120a015040150201500015
311e00000000000011000110f0140f01412012150121501215015150150901106011000111500015000150000c0110c0110c011150121501212012120150f0150f0150f015120151201512011000110000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000001e0201c3201b0202a020263201f02026020360203332000020251201d130171300f1300913004130021200102001020000000000000000000000000000000000000000000000000000000000000
000200003d2303d23026230302303e2303f6303f6300063007630000301e6301e6301e65000050000501c65008650056500265000050000500000000000000000000000000000000000000000000000000000000
00060000226202862027620206201f6202f32029320243201f3201a32016320123100e3100b310073100531001310003100000000000000000000000000000000000000000000000000000000000000000000000
0103000030733305000e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
79060000240361203611506147060e7360a736155060b70624506120360d5361353622036145360d1360f13612136357360000600006000060000600006000060000600006000060000600006000060000600006
400300000a153000530005325553213530000308353100531a0032605323053000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c50400003365007153000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000041410e6410d0431364318641021010010100101001010010100101001010010100101001010010100101001010010100101001010010100101001010010100101001010010100101001010010100000
010200001273116733000030050301003005030170300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300000
__music__
01 40014344
02 41010044
01 44064344
00 04054344
00 05060444
02 07044644

