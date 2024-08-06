pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- gem dredging
-- by the sailor


function _init()
	
	--butt swap
	bswap=false
	menuitem(1,"swap ❎/🅾️", butt_swap)
	
	fadetable={
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{1,1,1,1,1,1,1,0,0,0,0,0,0,0,0},
	{2,2,2,2,2,2,1,1,1,0,0,0,0,0,0},
	{3,3,3,3,3,3,1,1,1,0,0,0,0,0,0},
	{4,4,4,2,2,2,2,2,1,1,0,0,0,0,0},
	{5,5,5,5,5,1,1,1,1,1,0,0,0,0,0},
	{6,6,13,13,13,13,5,5,5,5,1,1,1,0,0},
	{7,6,6,6,6,13,13,13,5,5,5,1,1,0,0},
	{8,8,8,8,2,2,2,2,2,2,0,0,0,0,0},
	{9,9,9,4,4,4,4,4,4,5,5,0,0,0,0},
	{10,10,9,9,9,4,4,4,5,5,5,5,0,0,0},
	{11,11,11,3,3,3,3,3,3,3,0,0,0,0,0},
	{12,12,12,12,12,3,3,1,1,1,1,1,1,0,0},
	{13,13,13,5,5,5,5,1,1,1,1,1,0,0,0},
	{14,14,14,13,4,4,2,2,2,2,2,1,1,0,0},
	{15,15,6,13,13,13,5,5,5,5,5,1,1,0,0}
	}
	
	t=0
	trans=nil
	wait=nil
	shake=0
	develop=0
	devspeed=0
	
	hi=0
	music(0,6000)
	
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
		local s="\^#"..debug[i]
		print(s,1,1+(i*6),8)
	end
end
-->8
-- screens

function upd_splash()
	t+=1
	
	devspeed+=0.2
	develop+=devspeed
	develop=min(100,develop)
	
	if t>=240 or btnp(❎) or btnp(🅾️) then
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
	cprint("a game by",32,1)
	cprint("the sailor",40,9)
	
end

function upd_menu()
	t+=1
	
	devspeed+=0.1
	develop+=devspeed
	develop=min(100,develop)
	
	
	if t>=60 and sf then
		sy+=(22-sy)/20
	end
	
	if sy-22<=0.5 and sf then
		sf=false
	end
	
	local lyb=76
	local gyd=96
	if t>=120 and float then
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
	
	if wait~=nil then
		wait-=1
		
		if wait<=0 then
			devspeed=0
			develop=0
			ini_board()
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
	print(s,60,8,1)
	print(s,60,9,1)
	print(s,60,7,9)
	
	clip(90,7,8,1)
	print(s,60,7,10)
	clip()
	
	pset(60,7,10)
	line(64,7,65,7,10)
	line(80,7,81,7,10)
	line(84,7,85,7,10)
	
end

function upd_game()
	t+=1
	
	upd_board()
	upd_parts()
	upd_bubbs()
	
	devspeed+=0.1
	develop+=devspeed
	develop=min(100,develop)
	
	checkwin()
	
	if krak then
		if trans==nil then
			if wait >=0 then
				wait-=1
			else
				trans=127
				shake=5
			end
		elseif trans<=-220 then
			trans=nil
			krak=false
			devspeed=0
			develop=0
			t=0
			bsel=1
			_upd=upd_kraken
			_drw=drw_kraken
		else
			trans-=5
		end
	else
		if timer<999 then
			gtimer+=1
		end
			
		if (gtimer>=60) then
			gtimer=0
			timer+=1
		end
		
		upd_cursor()
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
	drw_bubbs()
	
	if (krak) camera()
	
	
	rect(0,0,127,127,12)
	
	--kraken
	if krak and wait<=0 then
		rectfill(0,trans,127,127,8)
		if trans~=nil then
			if trans<=50 then
			fillp(░)
			rectfill(0,trans,127,127,2)
			fillp()
			print("\^t\^wbattle!",36,68,1)
			print("\^t\^wbattle!",36,66,1)
			print("\^t\^wbattle!",36,64,9)
			end
		end
	end
end

function butt_swap()
	if not bswap then
		bswap=true
	else
		bswap=false
	end
	return
end
-->8
-- game play

function ini_board()
	
	score=0
	opentiles=0
	flagtiles=0
	battletiles=0
	gtimer=0
	timer=0
	
	tiles={}
	flags={}
	bubbs={}
	
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
	
	
	allgems=flr(rnd(11))
	while allgems>0 do
		local pickedgem
		choices=rnd(1)
		if choices<0.1 then
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
	if t<100 then
		fadepal((100-develop)/100)
	end
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
	if t<100 then
		fadepal((100-develop)/100)
	end
	
	for tl in all(tiles) do
		if curx*size==tl.id_x and
					cury*size==tl.id_y then
					sspr(23,109,16,18,curx*size,cury*size)
		end
	end
end--drw_cursor()

function drw_gemboard()
	if t<100 then
		fadepal((100-develop)/100)
	end
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
	if t<100 then
		fadepal((100-develop)/100)
	end
	
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
	print("score "..score,7,108,1)
	print("score "..score,7,107,1)
	print("score "..score,7,106,10)
	pset(7,110,9)
	pset(12,110,9)
	pset(15,110,9)
	pset(19,110,9)
	pset(21,110,9)
	pset(23,110,9)
	
	--time
	sspr(60,0,6,9,65,104)
	print(timer,74,108,1)
	print(timer,74,107,1)
	print(timer,74,106,7)
	
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
	if t<100 then
		fadepal((100-develop)/100)
	end
	sspr(8,13,28,14,98,60+(sin(t*0.002)*1.2))
	sspr(0,29,37,50,91,79+(sin(t*0.005)*2))
end


function upd_cursor()
	if t>60 then
		movecursor()
		
		if bswap then
			if btnp(❎) then
				new_bubbs()
				flagtile()
			elseif btnp(🅾️) then
				opentile()
			end
		elseif not bswap then
			if btnp(❎) then
				opentile()
			elseif btnp(🅾️) then
				new_bubbs()
				flagtile()
			end
		end
		
	end
end--upd_cursor()

function opentile()
	local t
	for t=1,#tiles do
			if (curx*size==tiles[t].id_x
			and cury*size==tiles[t].id_y 
			and not tiles[t].revealed
			and not tiles[t].flag) then
				tiles[t].revealed=true
				if tiles[t].hasmine then
					sfx(57)
					shake=10
					wait=60
					krak=true
					enhp=ens[1]
					battletiles+=1
				else
					sfx(62)
					shake=0.1
					score+=10
					checkgems(t)
					checkaround(t)
					opentiles+=1
				end
			end
	end
end--opentile

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
		
		new_bubbs()
		
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
		sspr(39,109,9,10,f.x+4,f.y+3)
	end
end--drw_flags()

function drw_wflags()
	for f in all(flags) do
		for t in all(tiles) do
			if t.flag and t.revealed 
			and t.id_x==f.x
			and t.id_y==f.y then
				sspr(36,12,9,10,f.x+4,f.y+3)
			end
		end
	end
end--drw_wflags()

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
		opentiles+=1
		score+=10
		checkgems(u)
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
		opentiles+=1
		score+=10
		checkgems(d)
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
		opentiles+=1
		score+=10
		checkgems(l)
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
		opentiles+=1
		score+=10
		checkgems(r)
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
		opentiles+=1
		score+=10
		checkgems(tl)
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
		opentiles+=1
		score+=10
		checkgems(tr)
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
		opentiles+=1
		score+=10
		checkgems(bl)
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
		opentiles+=1
		score+=10
		checkgems(br)
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
		sfx(63)
		if curx<cols-1 then
			curx+=1
		else
			curx=0
		end
	end
	if btnp(⬅️) then
		sfx(63)
		if curx>0 then
			curx-=1
		else
			curx=cols-1
		end
	end
	if btnp(⬆️) then
		sfx(63)
		if cury>0 then
			cury-=1
		else
			cury=rows-1
		end
	end
	if btnp(⬇️) then
		sfx(63)
		if cury<rows-1 then
			cury+=1
		else
			cury=0
		end
	end
end--movecursor()

function upd_kraken()
	t+=1
	wait+=1
	
	devspeed+=0.1
	develop+=devspeed
	develop=min(100,develop)
	
	upd_bubbs()
	
	enatk()
	killen()
	
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
	
	battcmd()
end--/

function closekrak()
	wait=nil
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
	circfill(93,58,8,5)
	circfill(113,68,8,5)
	fillp()
	drw_bubbs()
	
	rectfill(0,80,127,104,13)
	circfill(10,80,10,13)
	circfill(28,80,7,13)
	circfill(65,80,9,13)
	circfill(85,80,12,13)
	circfill(100,80,8,13)
	circfill(120,80,8,13)
	
	drw_fighter()
	
	?sp_krak,64,12+sin(t*0.008)*2.2
	?sp_dredge,12,48+sin(t*0.005)*2
	
	print("krak",44,32,5)
	print("krak",44,31,7)
	rect(29,22,29+ens[1]+2,28,2)
	rectfill(30,23,30+enhp,27,9)
	
	print("dredger",66,96,1)
	print("dredger",66,95,7)
	rect(83,86,83+maxhp+2,92,2)
	rectfill(84,87,84+hp,91,9)
	
	rectfill(0,105,127,127,2)
	
	line(2,104,125,104,2)
	rectfill(2,105,125,125,14)
	rectfill(3,106,124,124,2)
	pset(2,105,2)
	pset(2,125,2)
	pset(125,105,2)
	pset(125,125,2)
	
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
	
	print("attack",8,109,c1)
	print("heal",8,117,c2)
	print("fright",34,117,c3)
	
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
	print(flagtiles.."X",12,44,2)
	print(flagtiles.."X",12,43,7)
	print("15",12,63,4)
	
	print(gems_r.."X",44,44,2)
	print(gems_r.."X",44,43,7)
	print("10",44,63,4)
	
	print(gems_g.."X",74,44,2)
	print(gems_g.."X",74,43,7)
	print("20",74,63,4)
	
	print(gems_o.."X",104,44,2)
	print(gems_o.."X",104,43,7)
	print("30",104,63,4)
	
	--divider
	rectfill(0,70,127,74,9)
	line(0,74,127,74,4)
	fillp(0xcc33)
	rectfill(0,70,127,73,148)
	fillp()
	
	--points
	rectfill(0,75,127,90,9)
	line(0,76,127,76,10)
	line(0,91,127,91,4)
	rectfill(0,92,127,94,1)
	
	local f_points=flagtiles*15
	local r_points=gems_r*10
	local g_points=gems_g*20
	local o_points=gems_o*30
	
	local newscore=score+f_points+r_points+g_points+o_points
	
	if hi<newscore then
		hi=newscore
	end
	
	print("\^t\^wscore "..newscore,24,81,4)
	print("\^t\^wscore "..newscore,24,79,7)
	
	--frame
	rect(0,0,127,127,10)
	rect(1,1,126,126,9)
	
end

function upd_win()
	devspeed+=0.2
	develop+=devspeed
	develop=min(100,develop)
	
	if not bswap then
		if btnp(❎) then
			gotomenu()
		end
	else
		if btnp(🅾️) then
			gotomenu()
		end
	end
end

function gotomenu()
	wait=nil
	music(0,4000)
	_drw=drw_menu
	_upd=upd_menu
end
-->8
-- tools


function lerp(a,b,spd)
	local res=a-b/spd
	return res
end

--[[function lerp(a,b,t)
 local result=a+t*(b-a)
 return result
end]]

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

function new_bubbs()
	local amt=2+flr(rnd(6))
	for b=1,amt do
	add(bubbs,{
			x=86+rnd(30),
			y=100-rnd(20),
			yspd=-1,
			r=rnd({1,3}),
			c=12,
			typ=1
		})
	end
end

function big_bubbs()
	local amt=18+flr(rnd(20))
	for b=1,amt do
		add(bubbs,{
			x=rnd(127),
			y=75+rnd(20),
			yspd=rnd(1)*-1,
			r=rnd(6),
			c=rnd({5,13}),
			typ=2
		})
	end
end

function drw_bubbs()
	for b in all(bubbs) do
		if b.typ==1 then
			circ(b.x+sin(t*0.3)*0.9,b.y,b.r,b.c)
		elseif b.typ==2 then
			circ(b.x+sin(t*0.3)*0.9,b.y,b.r,b.c)
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
			if b.y>-20 then
				b.r-=0.04
			else
				del(bubbs,b)
			end
		end
	end
end
-->8
--p8scii

sp_krak="⁶-b⁶x8⁶y8 ⁶-#ᶜ2⁶.\0\0\0\0\0█`▮⁸⁶-#ᶜ7⁶.\0\0\0\0█`▮⁸⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0█ナ⁶-#ᶜ2⁶.\0\0\0\0◜¹\0\0⁸⁶-#ᶜ7⁶.\0\0\0◜¹\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0\0²▒ら⁸⁶-#ᶜe⁶.\0\0\0\0\0ュ~?⁶-#ᶜ2⁶.\0ᶜ゛3#088⁸⁶-#ᶜ7⁶.、□!@@@@@⁸⁶-#ᶜ8⁶.\0\0\0\0▮ᶜ⁷⁷⁸⁶-#ᶜe⁶.\0\0\0ᶜᶜ³\0\0⁶-#            \n⁶-#ᶜ2⁶.\0\0\0`ユ0ユナ⁸⁶-#ᶜ7⁶.\0\0`…⁸っ⁸▮⁶-#ᶜ1⁶.\0`オ█\0\0@d⁸⁶-#ᶜ2⁶.⁸⁴⁴⁴⁴⁸	ᵇ⁸⁶-#ᶜ7⁶.⁴²²²³⁷⁶\0⁸⁶-#ᶜ8⁶.ユ▤(x▤\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0ぬ…⁸⁶-#ᶜa⁶.\0\0\0\0`ユ\0\0²1ᶜ2⁶. `Pヲナららら⁸⁶-#ᶜ8⁶.テ♥⬇️³⁷³³³⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0004$⁸⁶-#ᶜa⁶.\0\0\0\0「<\0\0⁸⁶-#ᶜe⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ2⁶.<、アlnoヤエ⁸⁶-#ᶜ7⁶.@ナ0………▮0⁸⁶-#ᶜ8⁶.³³³³¹\0\0\0⁶-#ᶜ7⁶.\0¹¹\0\0\0¹¹           \n⁶-#ᶜ2⁶.\0\0\0ら` 00⁸⁶-#ᶜ7⁶.ナ\0ら ▮▮⁸⁸⁸⁶-#ᶜ8⁶.\0\0\0\0█ららら⁶-#ᶜ1⁶.d⁶²0 8x░⁸⁶-#ᶜ2⁶.ᵇ☉☉◆「⁴⁶{⁸⁶-#ᶜ7⁶.\0¹¹\0\0\0\0\0⁸⁶-#ᶜ8⁶.█pp@んれ▒\0⁸⁶-#ᶜ9⁶.▮\0\0\0\0\0\0\0²1ᶜ2⁶.ら\0¹³\0ナユナ⁸⁶-#ᶜ8⁶.⁷ュュᶜᶠᶠ⁷\0⁸⁶-#ᶜ9⁶. \0\0\0\0\0\0\0⁶-#ᶜ1⁶.\0▮ᵉ⁷⬅️p0\0⁸⁶-#ᶜ2⁶.せこねスtᶠᶜ	⁸⁶-#ᶜ7⁶.「⁴\0\0\0█@0⁸⁶-#ᶜ8⁶.@@@ \0\0³⁶⁶-#ᶜ7⁶.¹¹¹¹¹\0\0\0           \n⁶-#ᶜ2⁶.きてffNュヲユ⁸⁶-#ᶜ7⁶.、□」」1²⁴⁸⁸⁶-#ᶜ8⁶.@@███\0\0\0⁶-#ᶜ1⁶.²\0\0\0\0\0\0\0⁸⁶-#ᶜ2⁶.われり▒¹¹¹\0⁸⁶-#ᶜ7⁶.8$\"B🐱²²¹⁶-#ᶜ1⁶.、▮\0\0\0\0\0\0⁸⁶-#ᶜ2⁶.こ/?oテ「0ナ⁸⁶-#ᶜ7⁶.@らら█¹⁶⁸▮⁸⁶-#ᶜ8⁶.\0\0\0▮ ナら\0⁶-#ᶜ2⁶.⁙3rモンリ²²⁸⁶-#ᶜ7⁶. ら▒¹⁶ᶜル⁴⁸⁶-#ᶜ8⁶.ᶜᶜᶜ▮\0\0¹¹⁶-#ᶜ2⁶.\0¹¹¹¹\0\0\0⁸⁶-#ᶜ7⁶.¹²²²²¹\0\0⁶-#           \n⁶.ユ\0\0\0\0\0\0\0 ⁶-#ᶜ2⁶.らナユ`\0\0\0\0⁸⁶-#ᶜ7⁶. 「⁸…`\0\0\0⁶-#ᶜ2⁶.²³¹\0\0\0\0\0⁸⁶-#ᶜ7⁶.⁴⁴²¹\0\0\0\0⁸⁶-#ᶜ8⁶.¹\0\0\0\0\0\0\0⁶-#\n\n\n\n\n\n\n\n\n\n\n"
sp_dredge="⁶-b⁶x8⁶y8⁶-#ᶜ1⁶.\0\0\0\0ᵉ□\"D⁸⁶-#ᶜ6⁶.\0\0\0ᶠ■!A🐱⁸⁶-#ᶜ7⁶.\0\0\0\0\0ᶜ、8⁶-# ⁶-#ᶜ1⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ6⁶.\0\0\0\0\0\0█@⁶-#ᶜ1⁶.\0\0ナ「⁴²¹\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0ナ▮⁸⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜ6⁶.\0ナ「⁴²¹\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0ユ「F3⁸⁶-#ᶜa⁶.\0\0\0ナ⁸⁴(⁴⁶-#ᶜ1⁶.\0p◆\0\0\0\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜ4⁶.\0\0\0pら█\0\0⁸⁶-#ᶜ6⁶.p◆\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0ᶜ?<pユ⁸⁶-#ᶜa⁶.\0\0p⬇️\0B🅾️ᵉ⁶-#ᶜ1⁶.\0\0\0¹²⁴⁸⁸⁸⁶-#ᶜ4⁶.\0\0\0\0\0¹³⁷⁸⁶-#ᶜ6⁶.\0\0¹²⁴⁸▮▮⁸⁶-#ᶜ9⁶.\0\0\0\0\0²⁴\0⁸⁶-#ᶜa⁶.\0\0\0\0¹\0\0\0⁶-#          \n⁶-#ᶜ1⁶.☉▮ @███\0⁸⁶-#ᶜ6⁶.DそPき@@@@⁸⁶-#ᶜ7⁶.0@█\0\0\0\0\0⁶-#ᶜ1⁶.\0¹゜ @@@○⁸⁶-#ᶜ2⁶.\0\0\0\0¹⁷⁷\0⁸⁶-#ᶜ4⁶.\0\0\0゛>88\0⁸⁶-#ᶜ6⁶.¹゛ A████⁶-#ᶜ1⁶.@  ▮▮…きき⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0@⁸⁶-#ᶜ4⁶.█@\0 ``@\0⁸⁶-#ᶜ6⁶. ▮▮⁸⁸⁸▮▮⁸⁶-#ᶜ9⁶.\0█らら█\0\0\0²1ᶜ2⁶.☉p\0\0\0\0\0\0⁸⁶-#ᶜ4⁶.p\0😐n6•••⁸⁶-#ᶜ9⁶.¹¹\0\0\0█らナ⁸⁶-#ᶜa⁶.⁶²¹█ら` \0²1ᶜ2⁶.\0\0\0\0ナ▮⁸⁴⁸⁶-#ᶜ4⁶.\0\0\0\0\0█ナ0⁸⁶-#ᶜ9⁶.ユヲュ◝゜o▶ᵇ⁸⁶-#ᶜa⁶.ᶠ⁷³\0\0\0\0\0⁶-#ᶜ1⁶.▮▮    ▮⁸⁸⁶-#ᶜ2⁶.²\0⁴\0⁸」\n⁴⁸⁶-#ᶜ4⁶.ᶜᶜ「「▮\0¹³⁸⁶-#ᶜ6⁶.  @@@@ ▮⁸⁶-#ᶜ9⁶.\0¹¹³³⁶⁴\0⁸⁶-#ᶜa⁶.¹²²⁴⁴\0\0\0⁶-#          \nᶜ6⁶.███\0\0\0\0\0⁶-#ᶜ1⁶.▥■!B🐱ᶜ、<⁸⁶-#ᶜ5⁶.⁶²²$Dらナら⁸⁶-#ᶜ6⁶.`ナら▒¹²²²⁸⁶-#ᶜd⁶.\0ᶜ、「80\0\0⁶-#ᶜ1⁶.きりB░☉q\"D⁸⁶-#ᶜ2⁶.@\0█\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0¹³⁸⁶-#ᶜ6⁶.■\"$Is⁶ᶜ「⁸⁶-#ᶜ7⁶.\0\0¹²⁴⁸▮ ⁸⁶-#ᶜd⁶.\0\0\0\0\0█ら█²1ᶜ2⁶.\0\0\0 @█\0\0⁸⁶-#ᶜ4⁶.••ロウう8pナ⁸⁶-#ᶜ9⁶.ナナ\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0¹³⁷²1ᶜ2⁶.²\0\0²⁷エ゜ᶜ⁸⁶-#ᶜ4⁶.、やイ」0 \0\0⁸⁶-#ᶜ9⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0ら⁶-#ᶜ1⁶.⁸ᵇᵇ、\"!@@⁸⁶-#ᶜ2⁶.⁶⁴⁴³¹\0\0\0⁸⁶-#ᶜ4⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.▮▮▮ @Hうう⁸⁶-#ᶜd⁶.\0\0\0\0、◀##⁶-#          \n ⁶-#ᶜ1⁶.ヲヲヲユナら\0\0⁸⁶-#ᶜ6⁶.⁴⁴⁴⁸▮ ら\0²1ᶜ2⁶.\0\0pユ0「「「⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.0ナ█\0\0\0\0¹⁸⁶-#ᶜ7⁶.@\0\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.\0\0\0\0らナナナ⁸⁶-#ᶜd⁶.⁴ᶜᶜᶜ\0\0\0\0²1ᶜ2⁶.\0\0\0\0¹²⁴⁸⁸⁶-#ᶜ4⁶.ら█\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0`@ら⁸⁶-#ᶜ6⁶.\0\0¹³⁶ᶜ「0⁸⁶-#ᶜ8⁶.\0\0\0\0\0¹³⁷⁸⁶-#ᶜd⁶.゜>\0xユ██\0²1ᶜ4⁶.¹³⁷ᵇ⁶⁴ᶜ▮⁸⁶-#ᶜ9⁶.\0\0\0⁴⁸「▮⁸⁸⁶-#ᶜd⁶.ユヲ\0ナナりりれ²1ᶜ5⁶.\0███ナらら█⁸⁶-#ᶜ6⁶.<x0\0\0\0\0\0⁸⁶-#ᶜd⁶.C⁷O~\r³³³⁶-#ᶜ1⁶.\0¹²²⁴⁸▮ ⁸⁶-#ᶜ5⁶.\0\0¹¹³¹³⁷⁸⁶-#ᶜ6⁶.¹²⁴⁴⁸▮ ら⁸⁶-#ᶜd⁶.\0\0\0\0\0⁶ᶜ「⁶-#ᶜ6⁶.\0\0\0\0\0\0\0♥        \n  ⁶-#ᶜ1⁶.⁴⁸⁸⁸⁴²²²⁸⁶-#ᶜ2⁶.「\0\0\0\0\0\0ᶜ⁸⁶-#ᶜ6⁶.²⁴⁴⁴²¹¹¹⁸⁶-#ᶜ8⁶.`ぬ……ま|ュユ⁸⁶-#ᶜa⁶.█@``@█\0\0²1ᶜ2⁶.⁸\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.███ららららナ⁸⁶-#ᶜ6⁶.0\0\0\0\0\0\0\0⁸⁶-#ᶜ8⁶.⁶\r\r\r\rᵉᶠ⁷⁸⁶-#ᶜa⁶.¹²²²²¹\0\0²1ᶜ4⁶.⁸▮「「、ᶜᵉ⁶⁸⁶-#ᶜ5⁶.\0¹³³りニナユ⁸⁶-#ᶜ9⁶.▮⁸\0\0\0\0\0\0⁸⁶-#ᶜd⁶.れるらら\0\0\0\0⁶-#ᶜ1⁶.◜◜モ∧⁙⁙	⁸⁸⁶-#ᶜ5⁶.\0¹■	ᶜᶜ⁶⁷⁸⁶-#ᶜ6⁶.\0\0\0`き ▮▮⁸⁶-#ᶜd⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ1⁶.り³⁷ᶠᶠ>xユ⁸⁶-#ᶜ5⁶.ᵉ、xユユら█\0⁸⁶-#ᶜ6⁶.\0\0\0\0\0¹⁶⁸⁸⁶-#ᶜd⁶.0ナ█\0\0\0\0\0⁶-#ᶜ1⁶.♥X`@@ 「⁷⁸⁶-#ᶜ2⁶.\0\0\0\0\0@ナヲ⁸⁶-#ᶜ4⁶.\0█████\0\0⁸⁶-#ᶜ5⁶.\0\0\0008?゜⁷\0⁸⁶-#ᶜ6⁶.X \0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0⁷゜⁷\0\0\0\0⁶-#ᶜ1⁶.\0¹¹⁶⁸⁸⁴³⁸⁶-#ᶜ4⁶.\0\0\0¹⁷⁷³\0⁸⁶-#ᶜ6⁶.¹²⁶⁸▮▮⁸⁴⁶-#       \n  ⁶-#ᶜ1⁶.ᵉ▮ナナユユヲヲ⁸⁶-#ᶜ2⁶.▮ \0\0\0\0\0\0⁸⁶-#ᶜ6⁶.¹ᵉ▮▮⁸⁸⁴⁴⁸⁶-#ᶜ8⁶.ナら\0\0\0\0\0\0²1ᶜ4⁶.\0\0███ら`4⁸⁶-#ᶜ5⁶.`p0 \0\0\0\0⁸⁶-#ᶜ8⁶.⁷³\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0@ ▮⁸²1ᶜ4⁶.⁷³³¹¹\0\0\0⁸⁶-#ᶜ5⁶.ユヲヲヲュュ\0◜⁶-#ᶜ1⁶.⁸⁸⁴²²³⁴⁴⁸⁶-#ᶜ5⁶.⁷⁷³¹¹\0¹¹⁸⁶-#ᶜ6⁶.▮▮⁸⁴⁴⁴⁸⁸⁸⁶-#ᶜd⁶.\0\0\0\0\0\0²²⁶-#ᶜ6⁶.ユ\0\0\0\0\0\0\0⁶-#ᶜ1⁶.ヲ\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.⁷ヲ\0\0\0\0\0\0⁶-#⁶.³\0\0\0\0\0\0\0       \n ⁶-#ᶜ1⁶.\0\0\0\0\0ナ「⁴⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0ナヲ⁸⁶-#ᶜ6⁶.\0\0\0\0ナ「⁴²⁶-#ᶜ1⁶.ュ<ᵉ●ニユヲュ⁸⁶-#ᶜ4⁶.\0@…h¥ᶠ⁷³⁸⁶-#ᶜ6⁶.²²¹¹\0\0\0\0⁸⁶-#ᶜ9⁶.\0█`▮⁴\0\0\0⁶-#ᶜ1⁶.ナx゛⁷#AD🐱⁸⁶-#ᶜ4⁶.」⁶¹\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0█ナヲチ🅾️³¹⁸⁶-#ᶜ6⁶.\0\0\0\0\0000(D⁸⁶-#ᶜ9⁶.⁶¹\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0█\0²1ᶜ5⁶.◝◝◝◝◝♥³³⁶-#ᶜ1⁶.⁴⁸⁸⁸⁸⁸▮■⁸⁶-#ᶜ5⁶.¹³³³³⁷⁷ᵉ⁸⁶-#ᶜ6⁶.⁸▮▮▮▮▮  ⁸⁶-#ᶜd⁶.²⁴⁴⁴⁴\0⁸\0⁶-#          \n⁶-#ᶜ1⁶.\0█`▮⁸\0\0\0⁸⁶-#ᶜ4⁶.\0\0█ナユ\0\0\0⁸⁶-#ᶜ6⁶.█`▮⁸⁴\0\0\0⁶-#ᶜ1⁶.²▒らナユ\0\0\0⁸⁶-#ᶜ4⁶.ュ~?゜ᶠ\0\0\0⁸⁶-#ᶜ6⁶.¹\0\0\0\0\0\0\0⁶-#ᶜ1⁶.○??かか\0\0\0⁸⁶-#ᶜ5⁶.█らら``\0\0\0⁶-#ᶜ1⁶.²¹¹\0\0\0\0\0⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.█🐱²¹¹\0\0\0⁶-#ᶜ1⁶.ョンッッュ\0\0\0⁸⁶-#ᶜ5⁶.²⁴\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0¹¹²\0\0\0⁸⁶-#ᶜd⁶.\0²⁴⁴\0\0\0\0⁶-#ᶜ1⁶.⁙⁙'''\0\0\0⁸⁶-#ᶜ5⁶.ᶜᶜ「「「\0\0\0⁸⁶-#ᶜ6⁶.  @@@\0\0\0⁶-#          \n                \n                \n                \n                \n                \n                \n                \n                "
-->8
--battle sys

bsel=1
bselpos={{34,108},{24,116},{58,116}}

ens={30,20}
enhp=0
hp=0
maxhp=30
batturn=1
enturn=false

x1=22
y1=90
x2=100
y2=30
fx,dx=x1,x1
fy,dy=y1,y1

--★

function battcmd()
	if not bswap then
		if btnp(❎) and batturn==1 then
			if bsel==1 then
				if enhp>0 then
				--attack creature
					if gems_r>0 then
						enhp-=10
						gems_r-=1
					else
						enhp-=5
					end
				end
			elseif bsel==2 and hp<maxhp then
				--heal dredger
				if gems_g>0 then
					hp+=maxhp/2
					gems_g-=1
				end
			elseif bsel==3 then
				--scare creature away
				if gems_o>0 then
					enhp=0
					gems_o-=1
				end
			end
			nextturn()
		end
	else
		if btnp(🅾️) and batturn==1 then
			--do something
		end
	end
end

function enatk()
	if batturn==2 and canatt(0.1) then
		if hp>0 then
			hp-=5
			wait=0
			nextturn()
		end
end
end

function killen()
	if enhp<=0 then
		bubbs={}
		_upd=upd_game
		_drw=drw_game
	end
end

function canatt(r)
	debug[1]=wait
	if enturn and rnd()<r then
		enturn=false
		return true
	end
	return false
end

function drw_fighter()
	
	if batturn==2 then
		dx=x2
		dy=y2
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

function nextturn()
	if wait>=60 then
		if batturn==2 then
			batturn=1
		else
			batturn=2
		end
	end
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
78800155000512222222212000aaaaaaaaaa00018aaa841100000000000000000000000000000000000000000000000000000000000000000000000000000000
7000010000012222222222100a1111111111a0018a8a411000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000100000122a8828a22100a1111111110a00148a4110000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001228a82882210aa1000000000aa014881100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000122888222221aaa1000000000aaa17111000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000012222222222149a1000000000a9417100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000122222282221149100000000094117100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000512222222215014100000000041011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000051222222150004100000000041000007100000077000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005111111500009100000000041005599655000019900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000009100000000041000557650005576000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000001999999944410000577500055770000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000111aa94111100dd777000dd7770000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000111a4111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000000000000077777777777700000000005555555
55555550222222221111888888882222222222222222111111111111111111111111111105555550000000000011111111170000000000733333333305555555
55555550222222221111888888882222222222222222111111111111111111111111111105555550000000000011111111170222222220733333333305555555
55555550222222221111111111111111111111111111111111111111111111111111111105555550000000000011111111170222222220733333333305555555
55555550222222221111111111111111111111111111111111111111111111111111111105555550000000000011111111170222222220733333333305555555
55555550222222222211111111112222111111111111000000000000000000000000000005555550000000000011111111170222222220733333333305555555
55555550222222222211111111112222111111111111000000000000000000000000000005555550000000000011111111170222222220733333333305555555
55555550111111111111111111111111110000000000000000000000000000000000000005555550000000000011111111170222222220733333333305555555
55555550111111111111111111111111110000000000000000000000000000000000000005555550000000000011111111170222222220733333333305555555
55555550111111111111111111111111110000000000000000000000000000000000000005555550000000000011111111170000000000733333333305555555
55555550111111111111111111111111110000000000000000000000000000000000000005555550444444444455555555577777777777777777777705555555
5555555055550000005511111111111155000000000000000000aa99000000000000000005555550444444444455555555556666666666777777777705555555
5555555055550000005511111111111155000000000000000000aa99000000000000000005555550444444444455555555556666666666777777777705555555
55555550550000005511999944444444115500000000000000aaaa99990000000000001105555550444444444455555555556666666666777777777705555555
55555550550000005511999944444444115500000000000000aaaa99990000000000001105555550444444444455555555556666666666777777777705555555
55555550000000551122888888888888441122000000aaaaaaaaaaaaaaaaaaaa0000001105555550444444444455555555556666666666777777777705555555
55555550000000551712888888888888441122000000aaaaaaaaaaaaaaaaaaaa0000001105555550444444444455555555556666666666777777777705555555
555555500000001122818888888888888844110000aa11111111111111111111aa00001105555550444444444455555555556666666666777777777705555555
555555500000001722871888888888888844110000aa11111111111111111111aa00001105555550444444444455555555556666666666777777777705555555
55555550000000112281aa99998899aa8844110000aa11111111111111111100aa0000110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550000000111718aa99998899aa8844110000aa11111111111111111100aa0000110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000011218899aa9988999988441100aaaa11000000000000000000aaaa00110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000011228899aa9988999988441100aaaa11000000000000000000aaaa00110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550000000112288999999888888884411aaaaaa11000000000000000000aaaaaa110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550000000112288999999888888884411aaaaaa11000000000000000000aaaaaa110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
555555500000001122888888888888888822114499aa11000000000000000000aa9944110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
555555500000001122888888888888888822114499aa11000000000000000000aa9944110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000011228888888888998844221111449911000000000000000000994411110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550000000112288888888889988442211114499110000000000000000009944111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000551122888888444444221155001144110000000000000000004411001105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000551122888888444444221155001144110000000000000000004411001105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005511222222222222115500000044110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000005511222222222222115500000044110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000055111111111111550000000099110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000055111111111111550000000099110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000000000000099110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000000000000099110000000000000000004411000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550000000000000000000000000000000000011999999999999994444441100000005555550000000000000000000000000000000000000000005555555
55555550000000000000000000000000000000000011999999999999994444441100000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000111111aaaa9944111111110000dd05555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000111111aaaa9944111111110000dd05555555555555555555555555555555555555555555555555555555
5555555000000000000000000000000000000000000000111111aa44111111110000000005555550000000555556667655555555555555555555555555555555
5555555000000000000000000000000000000000000000111111aa44111111110000000005555550000000555555666555555555555555555555555555555555
5555555000000000000000000000000000000000000000000011111111000000000000000555555000000055555556dddddddddddddddddddddddd5555555555
555555500000000000000000000000000000000000000000001111111100000000000000055555500020005555555655555555555555555555555d5555555555
55555550000000000000000000000000000000000000000000001111000000000000000005555550000000555555576666666d6666666d666666655555555555
55555550000000000000000000000000000000000000000000001111000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550110011001100110011001100110011001100110011001100110011001100110005555555555555555555555555555555555555555555555555555555
55555550100110011001100110011001100110011001100110011001100110011001100105555556665666555555555555555555555666765555555555555555
55555550001100110011001100110011001100110011001100110011001100110011001105555556555556555555555555555555555566655555555555555555
5555555001100110011001100110011001100110011001100110011001100110011001100555555555555555555555ddddddddddddddd6dddddddd5555555555
555555501100110011001100110011001100110011001100110011001100110011001100055555565555565555555655555555555555565555555d5555555555
55555550100110011001100110011001100110011001100110011001100110011001100105555556665666555555576666666d6666666d666666655555555555
55555550001100110011001100110011001100110011001100110011001100110011001105555555555555555555555555555555555555555555555555555555
55555550011001100110011001100110011001100110011001100110011001100110011005555555555555555555555555555555555555555555555555555555
55555550110011001100110011001100110011001100110011001100110011001100110005555555555555555555555555555555555555555555555555555555
55555550100110011001100110011001100110011001100110011001100110011001100105555555555555555555555555555555555555555555555555555555
55555550001100110011001100110011001100110011001100110011001100110011001105555550005550005550005550005550005550005550005550005555
555555500110011001100110011001100110011001100110011001100110011001100110055555011d05011d05011d05011d05011d05011d05011d05011d0555
55555550110011001100110011001100110011001100110011001100110011001100110005555501110501110501110501110501110501110501110501110555
55555550100110011001100110011001100110011001100110011001100110011001100105555501110501110501110501110501110501110501110501110555
55555550001100110011001100110011001100110011001100110011001100110011001105555550005550005550005550005550005550005550005550005555
55555550011001100110011001100110011001100110011001100110011001100110011005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555575555555ddd55555d5d5d5d55555d5d555555555d5555555ddd5555552222118855555555555555555555555555555555555555555555555555
555555555555777555555ddd55555555555555555d5d5d55555555d55555d555d555552222111156666666666666555555555555555555555555555557777755
555555555557777755555ddd55555d55555d55555d5d5d555555555d555d55555d55552222211156ddd6ddd6ddd6555556666655566666555666665577eee775
555555555577777555555ddd55555555555555555ddddd5555ddddddd55d55555d5555111111115666d6d6d6d6d6555566ddd66566dd666566ddd665777ee775
5555555557577755555ddddddd555d55555d555d5ddddd555d5ddddd555d55555d55551111111156ddd6d6d6ddd6555566d6d665666d66656666d6657777e775
5555555557557555555d55555d55555555555555dddddd555d55ddd55555d555d555555500051156d666d6d666d6555566d6d665666d666566d6666577eee775
5555555557775555555ddddddd555d5d5d5d555555ddd5555d555d5555555ddd5555555000519956ddd6ddd666d6555566ddd66566ddd66566ddd66577777775
55555555555555555555555555555555555555555555555555555555555555555555550005128856666666666666555566666665666666656666666577777775
555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ddddddd5ddddddd5ddddddd5eeeeeee5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001112222112aa22a22aa22299229922991199229911222299229922992299222299222299229922992299222aa22a22aa2211222211100000aa0000000aa
0000001112221129222a2229222992299229911992299112222992299229922992222992222992299229922992229222a222922112221110000000a0000000a0
0000000011121129222a22292229999992299229922999999229999a9229999a92299999922992299229999a92229222a2229221121110000000000000000000
0000000001121122922a2292222999999229922992299999922999999229999992299999922992299229999992222922a2292221121100000000000000000000
000000000002112229aaa92222211111122112211221111112211111122111111221111112211221122111111222229aaa922221120000000000000000000000
0000000000021182229a9222222111111221122112211111122111111221111112211111122112211221111112222229a9222281120000000000000000000000
00000000000000000000000000000000000000000022222222222222222222222222222222222222222222222222222292222881120000000000000000011100
00000007777777777777777777777777777777777022222222222222222222222222222222222222222222222222222222228881122200000000000000177100
00000007222211888822222222111111111111117011111111111111111111111111111111111111111111111122222222288881122222000000000001771100
00000207222211111111111111111111111111117011111111111111111111111111111111111111111111111111111111111111122222220000000017771000
00122207222221111122111111000000000000007000000000000000000000000000000000000000000000000011111122111111222222222210000001661100
00111107111111111111100000000000000000007000000000000000000000000000000000000000000000000000000111111111111111111110000000166100
00111107111111111111100000000000000000007000000000000000000000000000000000000000000000000000000111111111111111111100000000011100
68888d075500051111115000000000a9000000007011111000000000000000000000000000000000000000000000000000000000000000000000000000000000
68a80d07500051994444150000000aa9900000017088888100000000000000000000000000000000000000000000000000000000000000000000000000000000
78800107000512888888412000aaaaaaaaaa000170aa841100000000000000000000000000000000000000000000000000000000000000000000000000000000
7000010700012888888884100a1111111111a001708a411000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000107000128a9989a84100a1111111110a00170a4110000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000070001289a98998410aa1000000000aa017081100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000128999888841aaa1000000000aaa17011000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000700012888888882149a1000000000a9417000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000128888898421149100000000094117000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000512888444215014100000000041017000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000051222222150004100000000041007007100000077000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000005111111500009100000000041007099655000019900000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000009100000000041007057650005576000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000001999999944410007077500055770000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000000111aa94111100d7077000dd7770000000000000000000000000000000000000000000000000000000000000000000000000000
000000070000000000000000000111a4111100007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000000000111100000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000000000011000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600003e6503e6503e6503f650353502f35029350243501f3501a35016350123500e3500b350073500535001350003500000000000000000000000000000000000000000000000000000000000000000000000
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

