pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--scoundrel
--thesailor

---------
--todo---
---------
-- improve win screen
-- more juice to card actions
-- music to menu screen

cartdata("sailor_scoundrel")


function _init()
	menuitem(
		1,
		"reset highscore",
		function()
			if _upd==upd_menu then
			deletehiscore()
			end
		end)
	
	bestscore=dget(0)
	loadseed=dget(1)
	dungeons=dget(2)
	playtut=dget(3)
	newhigh=false
	totscore=0
	
	gametime=0
	gtmr=0
	updtmr=true
	
	tmr=0
	shake=0
	ini_fx()
	ini_menu()
end

function _update60()
	if shake>0 then
		shake-=1
		shakex=rnd(5)+1
		shakey=rnd(5)+1
	else
		camera()
	end
	_upd()
end

function _draw()
		doshake()
		_drw()
		drw_animations()
end

-----------------
-- ini
-----------------
function ini_game(_oldseed)
	seed=_oldseed or rnd(1234)
	srand(seed)
	
	resetdev()
	
	
	hp=20
	maxhp=20
	totscore=0
	
	bgx,bgy=0,20
	
	cursel=1
	oldcursel=1
	
	ini_deck()
	
	room=1
	roomcol={1,1,1,2,2,2,3,3,3,5,5,5,4,4,11,11,8,8,9,9,13,13,12,12,10,10}
	hasrun=false
	usedpotion=false
	
	--★
	if playtut!=-999 then
		shfdeckcopy={}
		shfdeckcopy[1]={remcard=false,suit="clb",rank=2}
		shfdeckcopy[2]={remcard=false,suit="spd",rank=13}
		shfdeckcopy[3]={remcard=false,suit="hrt",rank=10}
		shfdeckcopy[4]={remcard=false,suit="dmd",rank=5}
		shfdeckcopy[5]={remcard=false,suit="dmd",rank=10}
		shfdeckcopy[6]={remcard=false,suit="spd",rank=4}
		shfdeckcopy[7]={remcard=false,suit="hrt",rank=3}
		shfdeckcopy[8]={remcard=false,suit="clb",rank=3}
	end
	
--animations
	wpnattached=false
	bleed,heal=0,0
	async(deckani)
	dealcards(4)
	
	_upd=upd_game
	_drw=drw_game
	
end

function ini_deck()
	deck={}
	deckcopy={}
	shfdeck={}
	shfdeckcopy={}
	hand={}
	suits={"hrt","dmd","clb","spd"}
	discards={}
	hasweapon=nil
	totmonsterscore=0
	
	cardpos={
		{x=10,y=8},
		{x=52,y=8},
		{x=10,y=46},
		{x=52,y=46},
		{x=84,y=40}
	}
	
	--create deck
	mk_deck()
	--remove face cards (red)
	rm_faces()
	--make a copy / keep orig
	copy(deck,deckcopy)
	-- shuffle copy (a) into new 
	-- deck (b)
	-- del orig copy (a)
	shuffle(deckcopy,shfdeck)
	--make a copy of deck (b)
	--into new deck (c)
	copy(shfdeck,shfdeckcopy)
end

function ini_menu()
	logoy1=0
	logoy2=70
	_upd=upd_menu
	_drw=drw_menu
end

function ini_cut1()
	music(0,12000)
	_upd=upd_cut1
	_drw=drw_cut1
end

function ini_cut2()
	music(0,12000)
	_upd=upd_cut2
	_drw=drw_cut2
end

function deletehiscore()
	dset(0,-999)
	dset(2,0)
	dset(3,0)
	bestscore=dget(0)
	dungeons=dget(2)
	playtut=dget(3)
end
-->8
--draws
function drw_menu()
	fadepal((100-develop)/100)
	cls()
	?menu,0,0
	
	?"웃 THESAILOR_DEV",2,2,9
	?"♪ THE PACKBATS",2,8,9
	
	?"new run ❎",4,109,0
	?"new run ❎",5,108,15
	?"previous run 🅾️",4,118,0
	?"previous run 🅾️",5,117,9
	
	
	if develop==100 then
	palt(7,true)
	palt(0,false)
	logoy1=lerp(logoy1,logoy2,easeoutbounce(time()/2))
	sspr(109,30,24,36,100,logoy1+sin(time()/2)*2)
	palt()
	end
end

function drw_cut1()
	fadepal((100-develop)/100)
	cls()
	
	palt(7,true)
	sspr(
		42,62,
		82,60,
		20+sin(time()*0.4),
		50+sin(time()/1.3),
		82,60,
		false)
	palt()
	
	local s="the adventurer stumbles"
	?s,64-(#s*2),30,13
	s="through the dark,"
	?s,64-(#s*2),36,13
	s="looking for..."
	?s,64-(#s*2),42,13
	s="the scoundrel"
	?s,64-(#s*2),109,13
	
	local b=""
	if (bestscore!=-999) b=bestscore
	?"HIGHSCORE: "..b,2,12,9
	?"COMPLETE DUNGEONS: "..dungeons,2,18,9
end

function drw_cut2()
	
	fadepal((100-develop)/100)
	cls()
	
	local txt="PLAYING SEED "..loadseed.." AGAIN"
	?txt,64-(#txt*2),38,9
	
	local s="return for revenge"
	?s,64-(#s*2),30,9
	
	local b=""
	if (bestscore!=-999) b=bestscore
	?"HIGHSCORE: "..b,2,12,1
	?"COMPLETE DUNGEONS: "..dungeons,2,18,1
	
	if develop==100 then
	pal(1,2)
	pal(5,8)
	end
	
	palt(7,true)
	sspr(
		42,62,
		82,60,
		20+sin(time()*0.4),
		50+sin(time()/1.3),
		82,60,
		true)
	palt()
	pal()
end


function drw_gameover()
	fadepal((100-develop)/100)
	cls()
	?dead,0,0
end

function drw_game()
	fadepal((100-develop)/100)
	
	cls()
	
	drw_bkg()
	drw_hline(0,82,5)
	drw_vline(60,82,5)
	drw_healthbar()
	drw_flee()
	
		if allgame==true then
			drw_weapon(70,90,83,88)
			drw_deck(10,88)
			drw_hand()
			drw_cursor()
		end
		
		if cursel!=5 and #routines==0 then
			drw_icos(cardpos[cursel].x,
													cardpos[cursel].y,
													hand[cursel])
		end
			
		
	drw_frame()
	if playtut!=-999 and
				#routines==0 then
		drw_tut()
	end
end

function drw_bkg()
	fillp(…)
	circfill(bgx+sin(time()*8)*.2,bgy,34,1)
	circfill(127+bgx+sin(time()*8)*.2,bgy,34,1)
	fillp(░)
	circfill(30+bgx+sin(time()*8)*.2,bgy,34,1)
	circfill(90+bgx+sin(time()*8)*.2,bgy,34,1)
	circfill(60+bgx+sin(time()/8)*7,bgy-20,22,2)
	circfill(20+bgx+sin(time()/8)*12,bgy-20,22,2)
	circfill(80+bgx+sin(time()/8)*12,bgy-20,22,2)
	fillp(▒)
	circfill(110+bgx+sin(time()/8)*12,bgy-20,22,2)
	circfill(110+bgx+sin(time()/8)*7,bgy-20,14,4)
	circfill(10+bgx+sin(time()/8)*7,bgy-20,14,4)
	fillp()
end

function drw_hline(_x1,_y1,_c)
	for i=1,127 do
		if i%4==0 then 
			pset(_x1+i,_y1,_c)
		end
	end
end

function drw_vline(_x1,_y1,_c)
	for i=1,127 do
		if i%4==0 then 
			pset(_x1,_y1+i,_c)
		end
	end
end

function drw_healthbar()
	? "hp",93,11,0
	? "hp",94,11,0
	? "hp",93,10,7
	? hp,113,11,0
	? hp,114,11,0
	? hp,113,10,7
	line(100,14,111,14,13)
	
	local newx=94
	local newy=12
	for i=0,maxhp-1 do
		if i%4==0 then
			newx=94
			newy+=6
		end
		
		? "♥",newx,newy,13
		newx+=6
	end
	
	local newx=94
	local newy=12
	for i=0,hp-1 do
		if i%4==0 then
			newx=94
			newy+=6
		end
		
		palt(7,true)
		sspr(120,1,6,5,newx+1,newy)
		palt()
		newx+=6
	end
end

function drw_deck(_x,_y)
	drw_bcard(_x,_y)
	? "_..",_x+36,(_y+22)-(room*2),roomcol[room]
	? #shfdeckcopy,_x+36,(_y+28)-(room*2),roomcol[room]
	? "_..",_x+36,(_y+30)-(room*2),roomcol[room]
--	? "room:"..room,_x+8,_y+26,7
end

function drw_bcard(_x,_y)
	rectfill(_x+1,_y-1,_x+30,_y+31,1)
	rectfill(_x,_y,_x+31,_y+30,1)
	
	pset(_x,_y-1,6)
	pset(_x+31,_y-1,12)
	pset(_x,_y+31,5)
	pset(_x+31,_y+31,5)
	
	line(_x+1,_y-2,_x+20,_y-2,6)
	line(_x+21,_y-2,_x+30,_y-2,12)
	
	line(_x-1,_y,_x-1,_y+12,6)
	line(_x-1,_y+12,_x-1,_y+24,12)
	line(_x-1,_y+24,_x-1,_y+30,5)
	
	line(_x+32,_y,_x+32,_y+12,12)
	line(_x+32,_y+12,_x+32,_y+24,13)
	line(_x+32,_y+24,_x+32,_y+30,5)
	
	line(_x+1,_y+32,_x+30,_y+32,5)
	
	fillp(▒)
	rectfill(_x,_y+23,_x+31,_y+26,0)
	fillp()
	
	rectfill(_x,_y+26,_x+31,_y+30,0)
	line(_x+1,_y+31,_x+30,_y+31,0)
	
	
	? "sco",_x+4,_y+4,6
	? "und",_x+4,_y+10,6
	? "rel",_x+4,_y+16,6
end

function drw_fcard(_x,_y,_rank,_suit)
	local c1,c2,c3,c4,c5=8,7,14,8,14
	if _suit=="spd" or
				_suit=="clb" then
				c1=0
				c2=9
				c3=13
				c4=5
				c5=5
	end
	
	rectfill(_x+1,_y-1,_x+30,_y+31,7)
	rectfill(_x,_y,_x+31,_y+30,7)
	
	pset(_x,_y-1,10)
	pset(_x+31,_y-1,9)
	pset(_x,_y+31,13)
	pset(_x+31,_y+31,13)
	
	line(_x+1,_y-2,_x+20,_y-2,10)
	line(_x+21,_y-2,_x+30,_y-2,9)
	
	line(_x-1,_y,_x-1,_y+12,10)
	line(_x-1,_y+12,_x-1,_y+24,9)
	line(_x-1,_y+24,_x-1,_y+30,13)
	
	line(_x+32,_y,_x+32,_y+12,9)
	line(_x+32,_y+12,_x+32,_y+24,4)
	line(_x+32,_y+24,_x+32,_y+30,13)
	
	line(_x+1,_y+32,_x+30,_y+32,13)
	
	fillp(…)
	rectfill(_x,_y+23,_x+31,_y+27,6)
	fillp(▒)
	rectfill(_x,_y+28,_x+31,_y+30,6)
	fillp()
	
	line(_x+1,_y+31,_x+30,_y+31,6)
	
	rectfill(_x+1,_y+6,_x+5,_y+29,c3)
	line(_x+1,_y+30,_x+5,_y+30,c4)
	line(_x+2,_y+31,_x+4,_y+31,c4)
	line(_x+3,_y+32,_x+3,_y+32,c4)
	pset(_x+1,_y+31,1)
	pset(_x+2,_y+32,1)
	pset(_x+5,_y+31,1)
	pset(_x+4,_y+32,1)
	
	for i=1,#_suit do
		? _suit[i],_x+2,_y+7+((i-1)*6),7
	end
	
	line(_x+1,_y-2,_x+9,_y-2,c5)
	
	palt(0,false)
	palt(7,true)
	if _suit=="spd" or 
				_suit=="clb" then
		if _rank==14 then
			sspr(72,0,23,28,_x+9,_y+4)
		elseif _rank==13 then
			sspr(24,0,23,28,_x+9,_y+4)
		elseif _rank==12 then
			sspr(95,0,23,28,_x+9,_y+4)
		elseif _rank==11 then
			sspr(0,30,23,28 ,_x+9,_y+4)
		elseif _rank==10 or 
									_rank==9 or 
									_rank==8 or 
									_rank==7 or
									_rank==6 then
			sspr(0,0,23,29,_x+9,_y+3)
		elseif _rank==5 or
									_rank==4 or
									_rank==3 or
									_rank==2 then
			sspr(48,0,23,28,_x+9,_y+4 )
		end
	end
	if _suit=="dmd" then
		if _rank==10 or
					_rank==9 or
					_rank==8 then
			sspr(84,30,23,27,_x+9,_y+4)
		elseif _rank==7 or
									_rank==6 or
									_rank==5 or
									_rank==4 then
			sspr(65,30,17,28,_x+11,_y+2)
		elseif _rank==3 or
									_rank==2 then
			sspr(45,30,18,25,_x+11,_y+2)
		end
	end
	if _suit=="hrt" then
		if _rank>5 then
			sspr(22,59,20,29,_x+8,_y+1)
		else
			sspr(0,60,20,24,_x+8,_y+1)
		end
	end
	palt()
	
	rectfill(_x+1,_y-1,_x+9,_y+5,c1)
	local newrank
	if _rank<10 then
		? _rank,_x+4,_y,c2
	elseif _rank==10 then
		? _rank,_x+2,_y,c2
	else
		if (_rank==11) newrank="j"
		if (_rank==12) newrank="q"
		if (_rank==13) newrank="k"
		if (_rank==14) newrank="a"
		? newrank,_x+4,_y,c2
	end
end

function drw_hand()
	if #discards==0 then
		for i=1,#hand do
			drw_fcard(
				cardpos[i].x,
				cardpos[i].y,
				hand[i].rank,
				hand[i].suit
				)
		end
	end
end

function drw_flee()
	if hasrun==false and 
				#hand==4 and 
				#shfdeckcopy>0 then
		rect(
			cardpos[5].x+10,
			cardpos[5].y+13,
			cardpos[5].x+10+22,
			cardpos[5].y+13+18,
			1)
		
		? "flee",cardpos[5].x+14,cardpos[5].y+16,12
		? "room",cardpos[5].x+14,cardpos[5].y+24,12
	end
end

function drw_cursor()
	local movey=sin(time()/1.5)*0.8
	palt(0,false)
	palt(7,true)
	sspr(
		24,30,
		21,22
		,cardpos[cursel].x+22,
		cardpos[cursel].y+20+movey
		)
	palt()
end

function drw_weapon(_x1,_y1,_x2,_y2)
	if hasweapon!=nil and
				wpnattached==true then
		drw_fcard(_x1,_y1,hasweapon.lmt,hasweapon.lmtsuit)
		line(81,88,81,118,0)
		pset(82,119,0)
		pset(83,120,0)
		line(84,121,101,121,0)
		drw_fcard(_x2,_y2,hasweapon.rank,hasweapon.suit)
	end
end

function drw_icos(_x,_y,_tbl)
	
	if _tbl.suit=="spd" or
				_tbl.suit=="clb" then
		
		if hasweapon then
			if _tbl.rank<=hasweapon.lmt then
				rectfill(
					_x,_y+13,
					_x+16,_y+19,4
				)
				line(_x,_y+20,_x+16,_y+20,1)
				? "wpn",_x+5,_y+14,10
				palt(7,true)
				pal(2,4)
				sspr(120,6,6,7,_x-3,_y+13)
			end
		end
		
		rectfill(
			_x,_y+22,
			_x+20,_y+28,4
		)
		line(_x,_y+29,_x+19,_y+29,1)
		? "fist",_x+5,_y+23,10
		palt(7,true)
		pal(2,4)
		sspr(120,13,6,7,_x-3,_y+22)
		pal()
	elseif _tbl.suit=="hrt" then
		rectfill(
			_x,_y+22,
			_x+16,_y+28,2
		)
		line(_x,_y+29,_x+16,_y+29,1)
		if usedpotion==true then
		? "-x-",_x+5,_y+23,14
		else
			? "use",_x+5,_y+23,14
		end
		
		palt(7,true)
		pal(9,2)
		sspr(120,13,6,7,_x-3,_y+22)
		pal()
	elseif _tbl.suit=="dmd" then
		rectfill(
			_x,_y+22,
			_x+16,_y+28,3
		)
		line(_x,_y+29,_x+16,_y+29,1)
		? "pck",_x+5,_y+23,11
		
		palt(7,true)
		pal(2,3)
		sspr(120,13,6,7,_x-3,_y+22)
		pal()
	end
end

function drw_frame()
	for i=0,2 do
		rect(0+i,0+i,127-i,127-i,6)
	end
end

function drw_animations()
	for r in all(routines) do
		if costatus(r)=="dead" then
			del(routines,r)
		else
			coresume(r)
		end
	end
end

function drw_win()
	fadepal((100-develop)/100)
	cls()
	
	palt(7,true)
	sspr(
		42,62,
		82,60,
		20+sin(time()*0.4),
		50+sin(time()/1.3),
		82,60,
		false)
	palt()
	
	local s="highscore!"
	if newhigh==true then
		?s,63-(#s*2),5,0
		?s,65-(#s*2),5,0
		?s,64-(#s*2),4,0
		?s,64-(#s*2),6,0
		?s,64-(#s*2),5,8
	end
	local my=sin(time()/4)*1.3
	?"\^t\^wscored  "..totscore,21,15+my,0
	?"\^t\^wscored  "..totscore,19,15+my,0
	?"\^t\^wscored  "..totscore,20,14+my,0
	?"\^t\^wscored  "..totscore,20,16+my,1
	?"\^t\^wscored  "..totscore,20,15+my,8
	
	?"\^t\^wdungeon master",8,32,1
	?"\^t\^wdungeon master",8,30,9
	
	local gt=(gametime%(24*3600*3600))/60
	s="run completed in "..ceil(gt).." minutes"
	?s,64-(#s*2),24,7
end

function drw_tut()
	poke(0x5f34,0x2)
	circfill(
		cardpos[cursel].x+20,
		cardpos[cursel].y+16,
		26+cos(t()/2)*1.2,
		0 | 0x1800)
	
	
	local title,txt,col,sx,intro
	
	if cursel==1 then
		intro=[[
			EACH ROOM HAS 4 CARDS.
			WHEN 1 CARD IS LEFT,
			3 NEW CARDS ARE DEALT.
		]]
	elseif cursel==2 then
		intro=[[
			USE ALL THE CARDS
			IN YOUR DECK TO
			ESCAPE THE DUNGEON.
		]]
	end
	
	?intro,-50,60,7
	
	if cursel!=5 then
		sx=-70
		if hand[cursel].suit=="clb" or
					hand[cursel].suit=="spd" then
			local csuit=hand[cursel].suit=="clb" and "clubs" or "spades"
			title=hand[cursel].suit.." ("..csuit..") ".."rank:"..hand[cursel].rank 
			col=9
			txt=[[
				ATTACK MONSTERS WITH WEAPONS
				OR USING YOUR FISTS. MONSTERS
				RANK FROM 2-14 (J,Q,K,A).
			]]
		elseif hand[cursel].suit=="hrt" then
			title=hand[cursel].suit.." (hearts) ".."rank:"..hand[cursel].rank 
			col=8
			txt=[[
				GAIN HEALTH EQUAL TO THE RANK.
				POTIONS CAN ONLY BE USED ONCE 
				PER ROOM, OTHERWISE IT WILL BE
				DISCARDED WHEN USED (-x-)
			]]
		elseif hand[cursel].suit=="dmd" then
			title=hand[cursel].suit.." (diamonds) ".."rank:"..hand[cursel].rank 
			col=14
			txt=[[
				WEAPONS ARE AS STRONG AS THEIR
				RANKS. ATTACK MONSTERS OF THE
				SAME OR LOWER RANK ALLOWED
				BY THE ATTACHED MONSTER CARD.
			]]
		end
	else
		col=12
		sx=-50
		title="escape the room"
		txt=[[
			FLEE FROM A ROOM IF YOU
			HAVE NOT PLAYED A CARD.
			YOU CANNOT FLEE TWO ROOMS
			IN A ROW. press ❎
		]]
	end
	
	?cursel.."OF5",1,83,col
	print(title,0,92,col)
	?txt,sx,100,13
end


-->8
--updates
function upd_menu()
	fadeeff(.17)
	if btnp(❎) then
		sfx(60)
		resetdev()
		ini_cut1()
	end
	
	if btnp(🅾️) then
		sfx(60)
		resetdev()
		ini_cut2()
	end
end

function upd_cut1()
	fadeeff(.06)
	if btnp(❎) then
		sfx(60)
		if playtut==0 then
			dset(3,-999)
		end
		ini_game()
	end
end

function upd_cut2()
	fadeeff(.06)
	if btnp(❎) then
		sfx(60)
		if playtut==0 then
			dset(3,-999)
		end
		ini_game(loadseed)
	end
end

function upd_gameover()
	fadeeff(.1)
	if develop==100 then
		if tmr>0 then
			tmr-=1
		else
			async(statsboard)
		end
	end
	
	if btnp(❎) then
		sfx(60)
		allgame=false
		hasweapon=nil
		ini_game()
		music(0)
	end
	
	if btnp(🅾️) then
		sfx(60)
		allgame=false
		hasweapon=nil
		ini_game(seed)
		music(0)
	end
end

function upd_game()
	fadeeff(.2)
	if develop==100 and #routines==0 then
		if gtmr==60 and updtmr==true then
			gametime+=1
			gtmr=0
		else
			gtmr+=1
		end
	
	if playtut!=-999 then
		upd_tutcursor()
	else
		upd_cursor()
	end
		upd_cards()
	end
end

function upd_cursor()
	local current=cursel
	
	--check for game end
	if hp==0 then
		-- dead / lose
		local scorehand,scoredeck=0,0
		-- find monsters in hand
		for i=1,#hand do
			if hand[i].suit=="spd" or
						hand[i].suit=="clb" then
				scorehand+=hand[i].rank
			end
		end
		--find monsters in deck
		for i=1,#shfdeckcopy do
			if shfdeckcopy[i].suit=="spd" or
						shfdeckcopy[i].suit=="clb" then
				scoredeck+=shfdeckcopy[i].rank
			end
		end
		-- add scores together
		totscore=hp-scorehand-scoredeck
		if bestscore<totscore then
			newhigh=true
			dset(0,totscore)
		end
		dset(1,seed)
		sfx(54)
		wait(60)
		resetdev()
		tmr=30
		music(-1)
		_upd=upd_gameover
		_drw=drw_gameover
	end
	
	if (btnp(➡️)) cursel+=1
	if (btnp(⬅️)) cursel-=1
	if (btnp(⬆️) and cursel>=3) cursel-=2
	if (btnp(⬇️) and cursel<=2) cursel+=2
	
	local n
	if (#hand<4) n=#hand
	if (#hand==4) n=5
	if (#hand==4 and hasrun==true) n=4
	
	
	plractions()
	
	
	cursel=mid(1,cursel,n)
	
	if current!=cursel then
		sfx(63)
	end
	
end

function upd_cards()
	if #shfdeckcopy!=0 and #hand==1 then
		sfx(52)
		room+=1
		hasrun=false
		if #shfdeckcopy>=3 then
			totcards=3
		else
			totcards=#shfdeckcopy
		end
		async(hidehand)
	elseif #shfdeckcopy==0 and
								#hand==0 and
								hp>0 and
								#routines==0 then
						sfx(49)
						for i=1,90 do
							---wait
							flip()
						end
						totscore=hp
						if bestscore<totscore then
							newhigh=true
							dset(0,totscore)
						end
						dset(1,seed)
						local comp=dget(2)+1
						dset(2,comp)
						allgame=false
						updtmr=false
						resetdev()
						_upd=upd_win
						_drw=drw_win
						music(10)
	end
end


function upd_win()
	fadeeff(.1)
	
	if #routines==0 and btnp(❎) then
		music(-1)
			sfx(60)
			hasweapon=nil
		_init()
	end
end

function plractions()
	if btnp(❎) then
		if cursel==5 and #hand==4 then
			--flee room
			if (hasrun==false) flee()
		elseif hand[cursel].suit=="spd" or
			hand[cursel].suit=="clb" then
			--punch with fists
			atkpunch()
		elseif hand[cursel].suit=="hrt" then
			--drink potion
			usepotion()
		elseif hand[cursel].suit=="dmd" then
			--take weapon
			pckweapon()
		end
	end
	
	if btnp(🅾️) and hasweapon and
				cursel!=5 then
		if hand[cursel].suit=="clb" or
					hand[cursel].suit=="spd" then
			if hasweapon.lmt>=hand[cursel].rank then
				async(cardslide)
				atkstab()
			else
				sfx(53)
			end
		end
	end
end

function upd_tutcursor()
	if (btnp(➡️)) cursel+=1
	if (btnp(⬅️)) cursel-=1
	local n
	if (#hand<4) n=#hand
	if (#hand==4) n=5
	if (#hand==4 and hasrun==true) n=4
	
	--actions
	if btnp(❎) and cursel==5 then
		cls()
		resetdev()
		playtut=-999
		allgame=false
		ini_game()
	end
	
	cursel=mid(1,cursel,n)
	
	if current!=cursel then
		sfx(63)
	end
end
-->8
--effects
function ini_fx()
	routines={}
	shake=0
	develop=0
	devspeed=0
end

function fadepal(_perc)
 local p=flr(mid(0,_perc,1)*100)
 local kmax,col,dpal,j,k
 dpal={0,1,1,2,1,13,
 						6,4,4,9,3,13,
 						1,13,14}
 
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22
  
  for k=1,kmax do
   col=dpal[col]
  end
  
  pal(j,col)
 end
end

function fadeeff(n)
	if develop<100 then
		devspeed+=n
		develop+=devspeed
	end
	develop=min(100,develop)
end

function resetdev()
	devspeed=0
	develop=0
end
-->8
--cards
function mk_deck()
	for s=1,4 do
		for r=2,14 do
			add(deck,{
				remcard=false,
				suit=suits[s],
				rank=r
			})
		end
	end
end

function rm_faces()
	for c in all(deck) do
		if c.suit=="hrt" or
					c.suit=="dmd" then
						if c.rank>10 then
							del(deck,c)
						end
		elseif c.suit=="clb" or
									c.suit=="spd" then
									totmonsterscore+=c.rank
		end
	end
end

function copy(tbl1,tbl2)
	for c=1,#tbl1 do
		--copy deck into deckcopy
		add(tbl2,tbl1[c])
	end
end

function shuffle(tbl1,tbl2) 
	for r=1,#tbl1 do
		local randcard=1+flr(rnd(#tbl1))
		add(tbl2,tbl1[randcard])
		deli(tbl1,randcard)
	end
end

function dealcards(v)
	for i=1,v do
		add(hand,shfdeckcopy[1])
		deli(shfdeckcopy,1)
	end
end

function discard(c)
	deli(hand,c)
end

function usepotion()
	if usedpotion==false then
		sfx(59)
		mk_discard(cursel)
		heal=hand[cursel].rank
		async(gethp)
		if (hp>maxhp) hp=maxhp
		discard(cursel)
		cursel=1
		usedpotion=true
	else
		sfx(53)
		mk_discard(cursel)
		discard(cursel)
		cursel=1
	end
end

function pckweapon()
	sfx(62)
	hasweapon=hand[cursel]
	hasweapon.x=cardpos[cursel].x
	hasweapon.y=cardpos[cursel].y
	hasweapon.lmt=14
	hasweapon.lmtsuit="clb"
	wpnattached=false
	async(cardslide)
	oldcursel=cursel
	async(monsterlmt)
	discard(cursel)
	cursel=1
end

function atkpunch()
	sfx(61)
	shake=6
	bleed=hand[cursel].rank
	async(redflash)
	async(loshp)
	mk_discard(cursel)
	discard(cursel)
	cursel=1
end

function atkstab()
	if hasweapon then
		atky=20
		--weapon lmt
		if hasweapon.lmt>=hand[cursel].rank then
			--calc dmg
			if hand[cursel].rank>hasweapon.rank then
				dmg=hand[cursel].rank-hasweapon.rank
				bleed=dmg
				async(redflash)
				async(loshp)
				shake=3
			else
				dmg=0
			end
			sfx(55)
			if (dmg<0) dmg*=-1
			
			oldcursel=cursel
			mk_discard(cursel)
			async(monsterlmt)
			hasweapon.lmt=hand[cursel].rank
			discard(cursel)
		end
	end
	cursel=1
end

function flee()
	sfx(52)
	
	--copy hand back into bottom
	-- of the deck
	for i=#hand,1,-1 do
			add(shfdeckcopy,hand[i])
			deli(hand,i)
	end
	
	hasrun=true
	cursel=1
	
	--pull new hand
	totcards=4
	async(hidehand)
	
end

-->8
--animations
function async(_func)
	add(routines,cocreate(_func))
end

function wait(f)
	local f=f or 90
	for i=1,f do
		yield()
	end
end

function deckani()
	local oy,yy=-20,0
	local c=0
	local cnt=0
	
	wait(40)
	for i=1,30 do
		drw_bcard(10+cos(time()*12),88)
		c+=1.3
		cnt=c%44
		? flr(1+cnt),46,117,12
		
		if oy+yy>60 then
			oy=10
			yy=0
		else
			yy+=20
			sfx(58)
		end
		drw_bcard(10+(cos(time()*33)*2),oy+yy)
		yield()
	end
	totcards=4
	async(carddeal)
	wait(38)
	wpnattached=true
	allgame=true
end

function carddeal()
local fr=37
local _x1,_x2,_x3,_x4=10,10,10,10
local _y1,_y2,_y3,_y4=88,88,88,88
local cnt

sfx(50)
	for i=1,fr do
	
	drw_deck(10,88)
	
	if totcards==4 then
		_x4=lerp(_x4,cardpos[4].x,easeinovershoot(i/30))
		_y4=lerp(_y4,cardpos[4].y,easeinovershoot(i/30))
		drw_bcard(_x4,_y4)
		
		_x3=lerp(_x3,cardpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,cardpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)
		
		_x2=lerp(_x2,cardpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,cardpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
		
		_x1=lerp(_x1,cardpos[1].x,easeinovershoot(i/20))
		_y1=lerp(_y1,cardpos[1].y,easeinovershoot(i/20))
		drw_bcard(_x1,_y1)
	elseif totcards==3 then
			drw_fcard(cardpos[1].x,cardpos[1].y,hand[1].rank,hand[1].suit)
		
		_x4=lerp(_x4,cardpos[4].x,easeinovershoot(i/30))
		_y4=lerp(_y4,cardpos[4].y,easeinovershoot(i/30))
		drw_bcard(_x4,_y4)
		
		_x3=lerp(_x3,cardpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,cardpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)
		
		_x2=lerp(_x2,cardpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,cardpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
	elseif totcards==2 then
			drw_fcard(cardpos[1].x,cardpos[1].y,hand[1].rank,hand[1].suit)
		
		_x3=lerp(_x3,cardpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,cardpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)
		
		_x2=lerp(_x2,cardpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,cardpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
		elseif totcards==1 then
			drw_fcard(cardpos[1].x,cardpos[1].y,hand[1].rank,hand[1].suit)
		
		_x2=lerp(_x2,cardpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,cardpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
		end
		
		yield()
	end
	sfx(51)
end

function cardslide()
local _x,_y=-20,128
local cnt
	for i=1,30 do
		hasweapon.x=lerp(hasweapon.x,83,easeinovershoot(i/30))
		hasweapon.y=lerp(hasweapon.y,88,easeinovershoot(i/30))
		drw_deck(10,88)
		drw_hand()
		drw_weapon(70,90,83,88)
		drw_flee()
		drw_cursor()
		drw_fcard(hasweapon.x,hasweapon.y,hasweapon.rank,hasweapon.suit)
		
		yield()
	end
	wpnattached=true
end

function discardani()
	local randx=rnd({-90,-60,-30,0,30,60,90})
	for i=1,40 do
		discards.x=lerp(
			discards.x,randx,
			easeinovershoot(i/30))
		discards.y=lerp(
			discards.y,-32,
			easeinovershoot(i/30))
		
		drw_deck(10,88)
		drw_hand()
		drw_weapon(70,90,83,88)
		drw_flee()
		drw_cursor()
		
		drw_fcard(
			discards.x,
			discards.y,
			discards.rank,
			discards.suit
			)
		yield()
	end
	discards={}
end

function mk_discard(c)
	discards.rank=hand[c].rank
	discards.suit=hand[c].suit
	discards.x=cardpos[c].x
	discards.y=cardpos[c].y
	async(discardani)
end

function redflash()
	for i=1,5 do
		cls(8)
		wait(10)
		cls(2)
		circfill(
			handpos[oldcursel].x+12,
			handpos[oldcursel].y+12,
			9,15
		)
		yield()
	end
end

function gethp()
	for i=1,heal do
		if (hp<maxhp) then
			hp+=1
			sfx(57)
			wait(8)
		end
	end
end

function loshp()
	for i=1,bleed do
		if (hp>0) then
			hp-=1
			shake=1.001
			sfx(56)
			wait(9)
		end
	end
end

function monsterlmt()
	local x,y,r
	x=cardpos[oldcursel].x
	y=cardpos[oldcursel].y
	r=5
	r2=10
	for i=1,30 do
		pal(7,9)
		pal(9,4)
		pal(10,9)
		pal(6,10)
		pal(12,15)
		pal(8,5)
		pal(14,4)
		drw_weapon(70,90,83,88)
		
		r-=0.14
		r2-=1.2
		x=lerp(x,70,easeinovershoot(i/20))
		y=lerp(y,88,easeinovershoot(i/20))
		circfill(x,y+sin(time()*2)*2,r+1,9)
		circfill(x-6,(y-6)+sin(time()*2)*2,r+0,9)
		circfill(x-8,(y-8)+sin(time()*2)*2,r,9)
		
		--
		circ(
			70,90,r2,9
		)
		
		yield()
	end
	pal()
end

function statsboard()
	local yheight=0
	local s
	for i=1,10 do
		yheight+=1.3
		
		
		fillp(░)
		rectfill(
			0,80,127,128,0
		)
		fillp()
		s="\#0rooms cleared:"
		?s..room,32,90,12
		s="\#0NEW ❎"
		?s,28,100,9
		s="\#0RETRY 🅾️"
		?s,64,100,9
		
		local my=sin(time()/4)*1.3
		local mx=0
		if totscore<=-100 then
			mx=15
		elseif totscore<-10 then
			mx=20
		elseif totscore<=0 then
			mx=26
		end
		
		local s="highscore!"
		if newhigh==true then
			?s,63-(#s*2),55,0
			?s,65-(#s*2),55,0
			?s,64-(#s*2),54,0
			?s,64-(#s*2),56,0
			?s,64-(#s*2),55,8
		end
		?"\^t\^wscored  "..totscore,mx+1,70+my,0
		?"\^t\^wscored  "..totscore,mx-1,70+my,0
		?"\^t\^wscored  "..totscore,mx,71+my,0
		?"\^t\^wscored  "..totscore,mx,69+my,0
		?"\^t\^wscored  "..totscore,mx,70+my,8
		yield()
	end
end

function hidehand()
	for i=1,40 do
		drw_deck(10,88)
		drw_weapon(70,90,83,88)
		drw_flee()
		yield()
	end
		
	async(carddeal)
	wait(40)
	dealcards(totcards)
	usedpotion=false
end

function doshake()
	local shakex=16-rnd(32)
	local shakey=16-rnd(32)
	 
	shakex*=shake
	shakey*=shake
	 
	camera(shakex,shakey)
	
	shake = shake*0.95
	if (shake<0.05) shake=0
end
-->8
--★
function drw_chkdeck(tbl,x,y,col)
	if #tbl>0 then
		for c=1,#tbl do
			? "\#0"..tbl[c].suit.."."..tbl[c].rank,x,y+((c-1)*6),col
		end
	else
		? "\#0[-x-]",x,y,col
	end
end

function lerp(a,b,t)
	return a+(b-a)*t
end

function easeinovershoot(t)
	return 1.7*t*t*t-.7*t*t
end

function easeoutovershoot(t)
	t-=.1
	return 1+.01*t*t*t+.1*t*t
end

function easeoutbounce(t)
    local n1=.5625
    local d1=1.25
   
    if (t<1/d1) then
        return n1*t*t;
    elseif(t<2/d1) then
        t-=1.5/d1
        return n1*t*t+.75;
    elseif(t<2.5/d1) then
        t-=2.25/d1
        return n1*t*t+.9375;
    else
        t-=2.625/d1
        return n1*t*t+.984375;
    end
end

function invlerp(a,b,v)
	return (v-a)/(b-a)
end
-->8
--sprites
dead="⁶-b⁶x8⁶y8ᶜ1⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶-#⁶.◝◝◝モ◝め◝🐱⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0|⁶-#ᶜ1⁶.◝◝◝モ◝め◝⌂⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0 ⁶-#ᶜ1⁶.◝◝◝モ◝め◝ち⁶-#⁶.◝◝◝モ?いエち⁸⁶-#ᶜa⁶.\0\0\0\0ら`0▮⁶-#ᶜ1⁶.◝◝◝モ◜ね◆*⁸⁶-#ᶜa⁶.\0\0\0\0¹ᵉpら⁶-#ᶜ1⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち⁶.◝◝◝モ◝め◝ち\n⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0⁶-#⁶.◝*U*‖ち‖\0⁸⁶-#ᶜ9⁶.\0██ら@@@@⁶-#ᶜ1⁶.\0*UちUちU\0⁸⁶-#ᶜ9⁶.◝り█\0\0\0⁸\0⁶-#ᶜ1⁶.◜そPきQけE\0⁸⁶-#ᶜ9⁶.\0\0¹³²⁴\0\0⁸⁶-#ᶜa⁶.¹³⁶ᶜᶜ「「「⁶-#ᶜ1⁶.◝ちUちUちU\0⁶-#⁶.ヤちE\nUちU\0⁸⁶-#ᶜa⁶.▮▮▮ユ\0\0\0\0⁶-#ᶜ1⁶.~そUちUちE\0⁸⁶-#ᶜa⁶.▒²²¹\0\0▮▮⁶-#ᶜ1⁶.◜ちTそPそQ\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0 ⁸⁶-#ᶜ9⁶.\0\0²⁴⁴⁴ᶜᶜ⁸⁶-#ᶜa⁶.¹¹¹²³²²²⁶-#ᶜ1⁶.◝ちUちUちU\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0 \0⁶-#ᶜ1⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0⁶.◝ちUちUちU\0\n⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0⁶-#⁶.U\0D\0■\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0ナ0▮⁶-#ᶜ1⁶.‖\0D\0■\0\0\0⁸⁶-#ᶜ9⁶.@ら█\0\0¹る~⁶-#ᶜ1⁶.U\0@\0▮\0\0\0⁸⁶-#ᶜ6⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ9⁶.\0³⁷⁷³³\0\0⁸⁶-#ᶜa⁶.\0\0\0\0\0\0ら ⁶-#ᶜ1⁶.E\0⁴\0¹\0\0\0⁸⁶-#ᶜ6⁶.\0\0\0█ナナ#リ⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0▮⁸⁸⁶-#ᶜa⁶.「「スx「゜ᶜ⁴⁸⁶-#ᶜd⁶.\0\0\0\0\0\0ら\0⁶-#ᶜ1⁶.U\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0◜れョユ◝¹⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0\0◜⁸⁶-#ᶜa⁶.\0◜¹\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0<²ᶠ\0\0⁶-#ᶜ1⁶.U\0\0\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0?ン◝◝◝ユ⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0\0ᶠ⁸⁶-#ᶜ9⁶.\0xら\0\0\0\0\0⁸⁶-#ᶜa⁶.\0⁷\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0⁶\0\0\0\0⁶-#ᶜ1⁶.U\0D\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0\0¹⁷ᶠ゜ᶠ⁸⁶-#ᶜ9⁶.\0\0³ᵉ「ぬ█ら⁸⁶-#ᶜa⁶.\0\0\0\0█@`0⁶-#ᶜ1⁶.Q\0@\0▮\0\0\0⁸⁶-#ᶜ9⁶.⁴⁴⁶²#¹¹\0⁸⁶-#ᶜa⁶.²²¹¹\0\0\0\0⁶-#ᶜ1⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0⁶.U\0D\0■\0\0\0\n   ⁶-#ᶜ4⁶.\0\0\0@\0\0\0\0⁸⁶-#ᶜ9⁶.、\0\0\0\0\0\0\0⁶-#⁶.\0\0\0\0\0\0²@⁸⁶-#ᶜa⁶.\0\0\0\0██ら█⁶-#ᶜ4⁶.\0\0\0\0\0\0\0⁸⁸⁶-#ᶜ5⁶.\0\0\0\0²\0\0\0⁸⁶-#ᶜ6⁶.ナp<、\0\0@ ⁸⁶-#ᶜ9⁶.\0\0\0█らp、⁶⁸⁶-#ᶜa⁶.▮😐るc=ᶠ#¹⁸⁶-#ᶜc⁶.\0\0\0\0\0██オ²6ᶜ7⁶.\0\0██\0ナユュ⁸⁶-#ᶜ9⁶.ᶜ⁴³³\0\0\0\0⁸⁶-#ᶜa⁶.³³\0\0\0\0\0\0²7 ²7ᶜ6⁶.ら█\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0ナ`\0\0\0\0⁸⁶-#ᶜa⁶.⁶>、うヲユ\0\0⁶-#ᶜ6⁶.⁷れナユヲユ`\0⁸⁶-#ᶜ7⁶.\0\0\0\0\0ᶜ゜○⁸⁶-#ᶜ9⁶.p0。ᵉ⁷\0\0\0⁸⁶-#ᶜa⁶.⁸ᶜ²¹\0³██⁶-#ᶜ2⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0▮▮⁸⁶-#ᶜ5⁶.\0¹\0²\0\0⁸⁸⁸⁶-#ᶜ6⁶.\0\0¹¹³¹⁴⁷⁸⁶-#ᶜ9⁶.¹²⁶ᶜᶜ\0\0\0⁸⁶-#ᶜa⁶.\0\0\0\0\0◜³\0⁶-#ᶜ4⁶.\0\0\0\0\0█ら█⁸⁶-#ᶜa⁶.\0\0\0\0\0¹⁷ᶜ⁶-#ᶜ4⁶.\0\0\0\0\0\0¹\0   \n    ⁶-#ᶜ2⁶.\0\0\0\0\0\0「、⁸⁶-#ᶜ4⁶.\0\0ら`8<⁶²⁸⁶-#ᶜ9⁶.ユユ8、⁴²\0\0⁸⁶-#ᶜd⁶.\0\0\0█ららナナ²4ᶜ6⁶.☉ュろサ6ササケ⁸⁶-#ᶜ9⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜc⁶.p\0008(っ))+⁸⁶-#ᶜd⁶.\0\0³¹¹\0\0\0⁶-#ᶜ1⁶.\0\0@ナユ▮⁸ᶜ⁸⁶-#ᶜ5⁶.\0\0█\0\0\0\0\0⁸⁶-#ᶜ6⁶.¹\0\0\0¹³³¹⁸⁶-#ᶜ7⁶.◜ᶠ⁶⁶⁶\0\0\0⁸⁶-#ᶜc⁶.\0\0¹¹\0\0\0\0⁸⁶-#ᶜd⁶.\0ユ8「⁸ᶜ⁴²⁶-#ᶜ1⁶.\0\0\0¹¹³²ᶜ⁸⁶-#ᶜ5⁶.\0\0\0²²ᶜ、▮⁸⁶-#ᶜ6⁶.⁸゜、0ナら\0 ⁸⁶-#ᶜ7⁶.ワナナら\0\0\0\0⁸⁶-#ᶜd⁶.\0\0³ᶜ、0ナら⁶-#ᶜ1⁶.\0\0\0█らら@`⁸⁶-#ᶜ5⁶.\0\0\0\0 08「⁸⁶-#ᶜ6⁶.\0|>ᶠ⁷¹⁴⁴⁸⁶-#ᶜ7⁶.◝³¹\0\0\0\0\0⁸⁶-#ᶜd⁶.\0█らp「ᵉ³³⁶-#ᶜ1⁶.\0\0²⁷ᶠ、0ナ⁸⁶-#ᶜ5⁶.\0⁶\r8P`ら\0⁸⁶-#ᶜ6⁶.█▤0@き█\0\0⁸⁶-#ᶜ7⁶.? \0\0\0\0\0\0⁸⁶-#ᶜa⁶.@@ら█\0\0\0\0⁸⁶-#ᶜd⁶.\0¹\0\0\0\0\0\0⁶-#ᶜ4⁶.0 `@@@@ら⁸⁶-#ᶜ5⁶.⁸▮▮ \0\0¹¹⁸⁶-#ᶜ6⁶.⁵		、ᶠ゜゛゛⁸⁶-#ᶜa⁶.²⁶⁶³\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0000   ⁶-#ᶜ2⁶.\0\0\0\0\0@`\0⁸⁶-#ᶜ4⁶.\0\0\0\0⁴\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0▮「「⁸⁶-#ᶜa⁶.「「▮00 \0\0⁶-#ᶜ4⁶.\0\0²「0```⁸⁶-#ᶜ9⁶.\0\0<ナら███⁶-#⁶.\0\0\0\0¹¹¹\0  \n   ᶜ4⁶.\0\0█\0\0\0\0\0⁶-#ᶜ1⁶.     \0\0\0⁸⁶-#ᶜ2⁶.゛゛゛「\0\0\0▮⁸⁶-#ᶜ4⁶.\0¹¹¹▮\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0ᶜ⁸⁶-#ᶜa⁶.\0\0\0█らナナナ⁸⁶-#ᶜd⁶.ららら@\0\0\0\0²6ᶜ7⁶.\0\0\0\0\0\0ᶜᶜ⁸⁶-#ᶜa⁶.゛ᶠ⁷⁷³¹¹\0⁸⁶-#ᶜc⁶.\0 ((ᶜ\0\0\0⁸⁶-#ᶜd⁶.\0███らる█¹⁶-#ᶜ1⁶.⁴⁶²⁷⁷ᶜ「ユ⁸⁶-#ᶜ5⁶.\0\0\0\0\0³⁷ᵉ⁸⁶-#ᶜd⁶.³¹¹\0\0\0\0¹⁶-#ᶜ1⁶.ᶜᶜᶜᶜ⁴⁶²¹⁸⁶-#ᶜ5⁶.▮▮▮▮⁸⁸⁴🐱⁸⁶-#ᶜ6⁶.``ナナ \0▮「⁸⁶-#ᶜ7⁶.\0\0\0\0らナナ`⁸⁶-#ᶜd⁶.██\0\0▮▮⁸⁴⁶-#ᶜ1⁶.@@ら███\0\0⁸⁶-#ᶜ5⁶.88(HX@れ⬇️⁸⁶-#ᶜ6⁶.⁶⁶⁶⁶⁴\0\0⁴⁸⁶-#ᶜ7⁶.\0\0\0\0³ᶠ、「⁸⁶-#ᶜd⁶.¹¹■1 0 `⁶-#ᶜ1⁶.ナらららき!•か⁸⁶-#ᶜ5⁶.\0\0\0\0@らナ`²1ᶜ2⁶.\0██\0\0\0██⁸⁶-#ᶜ4⁶.█\0\0███\0\0⁸⁶-#ᶜ5⁶.¹³⁶⁶⁶⁶⁷⁷⁸⁶-#ᶜ6⁶.゛<「「「▮\0\0⁸⁶-#ᶜd⁶.`@`  (8「⁶-#ᶜ2⁶.\0\0\0\0「\0\0\0⁸⁶-#ᶜ4⁶.\0⁸\nᶠんy⁷\0⁸⁶-#ᶜ9⁶.「⁶⁵\0\0\0\0\0⁶-#ᶜ4⁶.p8ᶜ³¹\0\0\0⁸⁶-#ᶜ9⁶.█@▮⁴\0\0\0\0⁶-#   \n   ⁶-#ᶜ4⁶.\0⁴\0\0█ら`▮⁸⁶-#ᶜ9⁶.\0\0らら`0▮⁸⁶-#ᶜ2⁶.108ᶜᵉ¹¹¹⁸⁶-#ᶜ4⁶.\0⁸░🐱ねぬぬら⁸⁶-#ᶜ9⁶.NG³1\0\0\0\0⁸⁶-#ᶜa⁶.██@\0\0\0\0\0²1ᶜ4⁶.\0\0\0\0¹¹¹\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0²\0\0⁸⁶-#ᶜ6⁶.ナら\0▮\0、ᵉ⁷⁸⁶-#ᶜ7⁶.「8ヲナナナユヲ⁸⁶-#ᶜd⁶.⁷⁶⁶ᶜ、\0\0\0²1ᶜ5⁶.、\0\0\0\0\0000「⁸⁶-#ᶜ6⁶.¹³³oゆおウヒ⁸⁶-#ᶜ7⁶.\0\0\0\0¹¹¹¹⁸⁶-#ᶜd⁶.²「██@`\0\0⁶-#ᶜ1⁶.¹\0█@@\0\0 ⁸⁶-#ᶜ5⁶.らら`008(▮⁸⁶-#ᶜ6⁶.⁸ᶜᵉᵉᶠ⁷▶ᶠ⁸⁶-#ᶜ7⁶.00▮\0\0\0\0\0⁸⁶-#ᶜd⁶.⁶³¹¹\0\0\0\0⁶-#ᶜ1⁶.¹³⁷⁶ᶜ⁴⁸⁸⁸⁶-#ᶜ5⁶.🅾️ᶜ「「▮「▮▮⁸⁶-#ᶜd⁶.pユナナナナナナ²1ᶜ5⁶.⧗れᵉᶜ⁸「\0\0⁸⁶-#ᶜ6⁶.\0\0\0\0  ``⁸⁶-#ᶜ7⁶.\0\0\0\0らら██⁸⁶-#ᶜd⁶.\0\0ヨリ▶⁷゜゜²1ᶜ2⁶.らら███\0\0\0⁸⁶-#ᶜ5⁶.³³\0\0\0█\0\0⁸⁶-#ᶜ6⁶.\0\0\0\0ᶜ0\0\0⁸⁶-#ᶜ7⁶.\0\0\0\0³ᶠ?゜⁸⁶-#ᶜd⁶.、、゜?p@らナ⁶-#ᶜ2⁶.\0\0¹¹³²²³⁸⁶-#ᶜ5⁶.\0\0\0\0\0¹¹\0⁶-#    \n   ⁶-#ᶜ4⁶.▮⁸⁸⁸⁸⁸\0\0⁸⁶-#ᶜ9⁶.ᶜ⁴⁶⁶⁶⁶゛>⁶-#ᶜ1⁶.\0\0@ら██\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0@@█\0⁸⁶-#ᶜ4⁶.@@ \0\0\0\0\0⁸⁶-#ᶜ6⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0²⁴⁴⁸⁶-#ᶜd⁶.\0██\0\0\0\0\0²1ᶜ2⁶.\0\0\0\0\0\0\0¹⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0000ナ⁸⁶-#ᶜ6⁶.³³●ᶜ8\0\0\0⁸⁶-#ᶜ7⁶.ュュx0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0¹れん◜ア「²1ᶜ5⁶.\0\0\0 0、⁶C⁸⁶-#ᶜ6⁶.@▒ら\0\0\0\0\0⁸⁶-#ᶜ7⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.ゆ~?か◆れり█⁶-#ᶜ1⁶.\0▮▮▮0▮\0\0⁸⁶-#ᶜ5⁶.▤☉😐😐L,、「⁸⁶-#ᶜ6⁶.⁷⁷³³⬇️るヌ$⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜd⁶.\0\0\0\0\0¹¹³⁶-#ᶜ1⁶.⁸⁸「「p`\0\0⁸⁶-#ᶜ5⁶.▮1bf😐…ナら⁸⁶-#ᶜ6⁶.\0\0¹¹³ᶠ「0⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0⁷ᶠ⁸⁶-#ᶜd⁶.ナら██\0\0\0\0²1ᶜ5⁶.\0\0\0⁴`x⁸\0⁸⁶-#ᶜ6⁶.fF^z「\0\0¹⁸⁶-#ᶜ7⁶.███\0\0\0\0\0⁸⁶-#ᶜd⁶.」9!▒▒▒¹\0⁶-#ᶜ1⁶.\0\0\0 0??゜⁸⁶-#ᶜ2⁶.\0\0█ららら@`⁸⁶-#ᶜ5⁶.█らp▮⁶\0\0\0⁸⁶-#ᶜ7⁶.ᶠ³¹\0\0\0\0\0⁸⁶-#ᶜd⁶.p<ᵉᶠ	\0\0\0⁶-#ᶜ2⁶.³¹\0\0\0\0\0\0    \n   ᶜ9⁶.◜ュ`\0\0\0\0\0⁶.³³\0\0\0\0\0\0⁶-#ᶜ1⁶.ュュヲナら██\0⁸⁶-#ᶜ2⁶.³²⁴⁸\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0 ``き⁸⁶-#ᶜ6⁶.\0\0\0\0▮\0\0@⁸⁶-#ᶜd⁶.\0\0\0▮\0\0\0\0⁶-#ᶜ1⁶.???!!ppユ⁸⁶-#ᶜ2⁶.\0\0\0▮\0¹\0\0⁸⁶-#ᶜ5⁶.@らら\0\0\0\0\0⁸⁶-#ᶜd⁶.█\0\0ろろ█░\0²5ᶜ6⁶.、、ᶜᶜ\0\0000▮⁸⁶-#ᶜ7⁶.ナナナナら\0\0\0⁸⁶-#ᶜd⁶.³³□■」•ᵇᵇ²5ᶜ6⁶.ユ0000@II⁸⁶-#ᶜ7⁶.ᶠᶠ\r\r⁸\0\0\0⁸⁶-#ᶜd⁶.\0らる🐱♥🐱●●⁶-#ᶜ1⁶.ュュュうᵉ⁷³³⁸⁶-#ᶜ5⁶.\0\0\0¹\0⁸⁴\0⁸⁶-#ᶜ6⁶.³³³²¹\0\0\0⁶-#ᶜ1⁶.。‖ᶜᶜ⁸\0\0\0⁸⁶-#ᶜ2⁶.\"²\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0⁴ᶜᶜ」⁸⁶-#ᶜ6⁶.\0⁸■■■■■\0⁶-#     \n     ⁶-#ᶜ5⁶.き███\0\0\0\0⁸⁶-#ᶜ6⁶.@@@@らら█き⁶-#ᶜ1⁶.ユナ\0\0\0\0\0\0⁶-#⁶.¹¹\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.`b◝みた✽▒▒⁸⁶-#ᶜ6⁶.…\0\0F⁶\"²²⁸⁶-#ᶜd⁶.ᵉう\0\0@@DD⁶-#ᶜ5⁶.\0█Cらら███⁸⁶-#ᶜ6⁶./\0█\0\0\0\0\0⁸⁶-#ᶜd⁶.オ○<、\0\0\0\0⁶-#ᶜ1⁶.³²²\0\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0¹¹¹¹¹³⁸⁶-#ᶜd⁶.\0¹\0²²²²\0⁶-#ᶜ5⁶.「⁸⁸「「「⁸⁸⁸⁶-#ᶜ6⁶.¹■▮\0\0\0▮▮⁶-#     \n     ⁶-#ᶜ5⁶.\0\0█\0\0\0\0@⁸⁶-#ᶜ6⁶.き█\0\0\0\0\0█⁶-#ᶜ5⁶.\0\0\0\0\0▮⁸\0⁸⁶-#ᶜ6⁶.\0\0\0\0\0\0\0フ⁸⁶-#ᶜd⁶.\0\0\0\0\0ナユ「⁶-#ᶜ1⁶.\0\00008「\0\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0 0 \0⁸⁶-#ᶜ5⁶.████▒☉……⁸⁶-#ᶜ6⁶.²²²²²\0\0\0⁸⁶-#ᶜd⁶.DDDDDGOo⁶-#ᶜ1⁶.\0\0◝⁷\0\0\0\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0pヨナ⁸⁶-#ᶜ6⁶.\0\0\0\0\0⁸⁸、⁸⁶-#ᶜd⁶.\0\0\0ヲ◝♥⁶³⁶-#ᶜ6⁶.³³⁷゜○◝◝³⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0\0|⁶-#ᶜ5⁶.\0\0\0▮\0\0\0\0⁸⁶-#ᶜ6⁶.▮▮▮\0\0¹⁷ᶠ⁸⁶-#ᶜ7⁶.\0\0\0\0\0\0\0▮⁶-#     \n  ᶜ1⁶.\0\0\0\0\0\0らユ⁶.\0\0\0\0ユ◝◝◝⁶-#⁶.\0\0\0ᵉ??○\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0◝⁸⁶-#ᶜ5⁶.\0 ▮\0\0@█\0⁸⁶-#ᶜ6⁶.\0ら█▮\0\0\0\0⁸⁶-#ᶜ7⁶.\0\0`ナら█\0\0⁶-#ᶜ5⁶.³\0\0\0\0\0\0¹⁸⁶-#ᶜ6⁶.ュ◝◝◝゛「ユら⁸⁶-#ᶜ7⁶.\0\0\0\0¹⁷ᶠ>⁶-#ᶜ5⁶.\0\0█\0\0゜³ᶜ⁸⁶-#ᶜ6⁶.◝◝qq゜\0、3⁸⁶-#ᶜd⁶.\0\0\0██\0██²5ᶜ6⁶.¹¹\0▮「」il⁸⁶-#ᶜd⁶.^||mフヒ⁶³²5ᶜ2⁶.ナ`0▮\0\0\0\0⁸⁶-#ᶜ6⁶.゛゛ᵉ🅾️\0\0\0\0⁸⁶-#ᶜ7⁶.\0\0\0\0ᶜᶜ⁸「⁸⁶-#ᶜ8⁶.\0█ら`ユユユナ⁸⁶-#ᶜd⁶.\0\0\0\0³²⁶⁴²6ᶜ7⁶.\0\0\0\0\0\0「ヲ⁸⁶-#ᶜ8⁶.ュリニワ◝◝フ⁷⁶-#ᶜ6⁶.⁷⁶⁴\0\0\0\0\0⁸⁶-#ᶜ7⁶.xヲッ◜◜◜◝◝⁸⁶-#ᶜ8⁶.\0¹¹¹¹¹\0\0⁶-#ᶜ1⁶.\0ヲナ█\0\0\0\0⁸⁶-#ᶜ7⁶.\0¹⁷゜○リれ♥⁸⁶-#ᶜ8⁶.\0\0\0\0\0ᶜ<x⁶-#ᶜ1⁶.\0⁷◝◝◜ヲ█\0⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ7⁶.\0\0\0\0\0¹⁷゜⁶-#ᶜ1⁶.\0\0\0⁷゜?○ュ⁸⁶-#ᶜ2⁶.\0\0\0\0\0\0\0³⁶-#  \n ᶜ1⁶.\0\0\0\0██\0\0⁶-#⁶.ュ◜○???○◝⁸⁶-#ᶜ2⁶.\0\0█ららら█\0²1⁶.ヲ◜゜³¹³゜◜⁸⁶-#ᶜ4⁶.\0\0ナ、⁶、ナ\0⁸⁶-#ᶜ9⁶.\0\0\0ナヲナ\0\0²2ᶜ4⁶.\0\0゜◜ヲ◜゜\0⁸⁶-#ᶜ9⁶.\0\0\0¹⁷¹\0\0²2ᶜ4⁶.\0\0\0\0¹\0\0\0⁸⁶-#ᶜ5⁶.²\0⁴⁸\0\0\0\0⁸⁶-#ᶜ6⁶.█⁴⁸\0\0\0\0\0⁸⁶-#ᶜ7⁶.|ヲユナら█\0\0⁸⁶-#ᶜd⁶.\0\0\0▮8|◜◝⁶-#ᶜ5⁶.\0 ら\0\0\0\0\0⁸⁶-#ᶜ6⁶.aP \0\0\0\0\0⁸⁶-#ᶜ7⁶.\0¹゜゜ᶠᶠゆヲ⁸⁶-#ᶜd⁶.██\0\0\0\0¹⁷⁶-#ᶜ1⁶.\0\0██らナユ>⁸⁶-#ᶜ5⁶.█▤A@ ▮⁸\0⁸⁶-#ᶜ6⁶.d`>⁴\0\0\0\0⁸⁶-#ᶜ7⁶.\0\0\0:゜ᶠ⁷¹⁸⁶-#ᶜd⁶.•⁷\0\0\0\0\0ら⁶-#ᶜ1⁶.\0¹³³⁷ᶠ\r⁸⁸⁶-#ᶜ5⁶.³²⁴⁴⁸\0▮ユ⁸⁶-#ᶜ7⁶.ルヲヲユユユ`\0⁸⁶-#ᶜd⁶.⁸\0\0\0\0\0²⁷⁶-#ᶜ1⁶.\0\0\0\0\0\0000⁷⁸⁶-#ᶜ5⁶.\0\0\0\0\0ユ◆`⁸⁶-#ᶜ6⁶.\0らユ\0\0\0\0\0⁸⁶-#ᶜ7⁶.ュ?ᶠ◝◝ᶠ\0\0⁸⁶-#ᶜ8⁶.³\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0@「⁶-#ᶜ1⁶.\0\0\0\0█◜◝◜⁸⁶-#ᶜ5⁶.\0\0\0ら⁶¹\0\0⁸⁶-#ᶜ6⁶.ュᶠ¹\0\0\0\0\0⁸⁶-#ᶜ7⁶.³ユ◜?¹\0\0\0⁶-#ᶜ1⁶.\0\0\0\0\0◝◝◝⁸⁶-#ᶜ2⁶.\0\0\0ヘュ\0\0\0⁸⁶-#ᶜ4⁶.\0\0█\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0█ᶜ\0\0\0\0\0⁸⁶-#ᶜ7⁶.◝○³\0\0\0\0\0⁶-#ᶜ1⁶.\0\0\0\0█◝◝◝⁸⁶-#ᶜ2⁶.█\0\0\0ᶠ\0\0\0⁸⁶-#ᶜ4⁶.\0☉🅾️⁷\0\0\0\0⁸⁶-#ᶜ5⁶.\0¹\0\0\0\0\0\0⁸⁶-#ᶜ7⁶.⁷\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0pヲp\0\0\0⁶-#ᶜ1⁶.ヲユヲ|?゜⁷\0⁸⁶-#ᶜ2⁶.\0⁸⁶³\0\0\0\0⁸⁶-#ᶜ4⁶.\0\0¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.⁷⁷\0\0\0\0\0\0⁶-#ᶜ1⁶.¹¹\0\0\0\0\0\0 \n  ⁶.◜ュユら\0\0\0\0⁶-#⁶.⁷◝◝◝◝ユ\0\0⁸⁶-#ᶜ2⁶.ヲ\0\0\0\0\0\0\0⁶-#ᶜ1⁶.\0\0◝◝◝◝◜\0⁸⁶-#ᶜ2⁶.◝◝\0\0\0\0\0\0⁶-#ᶜ1⁶.\0\0゜◝◝◝◝\0⁸⁶-#ᶜ2⁶.¹⁷\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0 \0\0\0\0\0⁸⁶-#ᶜd⁶.◜ヲら\0\0\0\0\0⁶-#ᶜ1⁶.\0\0\0\0ᶠ?¹\0⁸⁶-#ᶜ5⁶.\0\0\0¹▮█\0\0⁸⁶-#ᶜ6⁶.\0\0\0vナ\0\0\0⁸⁶-#ᶜ7⁶.ユ`\0\0\0\0\0\0⁸⁶-#ᶜd⁶.ᶠか◝☉\0\0\0\0⁶-#ᶜ1⁶.゛⁶\0\0\0\0³゛⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0⁴ ⁸⁶-#ᶜ6⁶.\0\0\0¹◝◝ヲら⁸⁶-#ᶜ7⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.ナン◝◜\0\0\0\0²1ᶜ2⁶.\0\0\0\0█@ナ█⁸⁶-#ᶜ4⁶.\0\0\0\0\0█\0\0⁸⁶-#ᶜ6⁶.\0\0ぬ◜○?ᶠ⁷⁸⁶-#ᶜd⁶.ᶠ◝O¹\0\0\0\0⁶-#ᶜ1⁶.\0\0<◜ナ██ナ⁸⁶-#ᶜ2⁶.\0\0\0\0▮``゜⁸⁶-#ᶜ4⁶.\0\0\0\0ᶠ¹¹\0⁸⁶-#ᶜ5⁶.▮ᶜ²¹\0\0\0\0⁸⁶-#ᶜ6⁶.\0\0¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0\0\0゛゛\0⁸⁶-#ᶜd⁶.ᶠ³\0\0\0\0\0\0⁶-#ᶜ1⁶.ら\0\0¹れワリり⁶.◝\0\0\0゜○○゜⁶.⁷\0\0\0\0\0\0\0   \n        ⁶.ら\0\0\0\0\0\0\0⁶.?\0\0\0\0\0\0\0      \n                "
menu="⁶-b⁶x8⁶y8²1ᶜ2⁶.も89」■CCc⁶.チテおおゆゆゆ~⁶.かエん♥♥⧗39⁶.エo'♥んんリャ⁶.ン◜◝◝◝○??⁶.○○○ᶠ0<かト⁶.◝◝◝◝ユろᵇ゜⁶.リs9「らルヲル⁶.ョ<ら◝◝◝◝◝²1⁶.\0◜○○}。\r⁵⁸⁶-#ᶜ3⁶.\0\0\0██²²\0⁸⁶-#ᶜ4⁶.\0\0\0\0\0`px⁸⁶-#ᶜb⁶.\0\0█\0²\0\0\0²1ᶜ2⁶.ヲ◝◝◝トチらら⁸⁶-#ᶜ3⁶.\0\0\0\0\0  \0⁸⁶-#ᶜ4⁶.\0\0\0\0\0³゜゜⁸⁶-#ᶜb⁶.\0\0\0\0 \0\0\0²2 ²2ᶜ9⁶.\0\0pヲもヲpユ⁸⁶-#ᶜf⁶.\0\0█\0@\0█\0²2ᶜ9⁶.\0\0\0¹³²、¥⁸⁶-#ᶜf⁶.\0\0゜~ュョネハ²2⁶.\0\0\0\0\0¹³³ \n²2ᶜ1⁶.おえよロ◝◝ワメ⁸⁶-#ᶜ3⁶.\0\0\0¹\0\0⁸□²2ᶜ1⁶.⬇️♥かフんoョヨ⁶.を♥³³?ョ▒¹⁶.⁵⁷⁷³²⁶⁷●⁶. 0、アG#3•²2⁶.0「⁘⁙「「「「⁸⁶-#ᶜ4⁶.\0\0\0⁸&dナノ²2ᶜ1⁶.█ら@pぬユヲ|⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0\0³²2ᶜ1⁶.\0\0ニ<ᶠ◝▒\0²2⁶.\0\0\0\0\0¹¹\0⁸⁶-#ᶜ4⁶.\0\0\0\0\0█らナ²2ᶜ1⁶.ををアヲヲナらら⁸⁶-#ᶜ4⁶.893⁷⁶゜?゜⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0 ²1ᶜ4⁶.ウウヒユユュ◜ュ⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0²²2ᶜ4⁶.\0\0りネ◝◝◝◝²2⁶.\0\0「ヨャ◝◝◝⁸⁶-#ᶜ9⁶.ナナナ\0\0\0\0\0²4⁶.'g○♥\0\0\0\0⁸⁶-#ᶜf⁶.ス▤█\0\0\0\0\0²4ᶜ2⁶.ヲヲユユユヲ\0\0⁸⁶-#ᶜ9⁶.\0\0	ᶠᵉ\0\0\0⁸⁶-#ᶜf⁶.⁷⁷⁶\0\0\0\0\0²4ᶜ2⁶.◝◝◝○??><\n²1ᶜ3⁶.2\0■⁙CBFウᶜ2⁶.ᵉᶜᶜ⁸███@⁶.◜◝◜ュ\0▒ヲユ⁶.ss3■█◝◝◝²1⁶.ユヲヘA¹¹\0\0⁸⁶-#ᶜ4⁶.\0\0▮ぬヲヲュ|²1ᶜ2⁶.⁷⁷▮\0@ \0\0⁸⁶-#ᶜ4⁶.ナ ⁷⬇️⬇️りユヲ²1ᶜ2⁶.ヲユナら█\0\0\0⁸⁶-#ᶜ4⁶.¹⁸゛?○◝ョ}²1ᶜ2⁶.○○◝◝○?8「⁸⁶-#ᶜ4⁶.██\0\0█ら\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0██⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0²²2ᶜ4⁶.ユリ◝◝◝◝◝◜⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0¹²1ᶜ4⁶.゜⁷ᶠ⁷⁷⁵⁵⁵⁸⁶-#ᶜ5⁶.\0\0@\0██\0\0⁸⁶-#ᶜ9⁶. \0▮「「⁸⁸⁸⁸⁶-#ᶜd⁶.\0\0\0@@@ら@⁸⁶-#ᶜf⁶.\0\0\0\0\0\0\0█²1ᶜ4⁶.ュユュュヲスオオ⁸⁶-#ᶜ5⁶.\0\0¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.²\0\0\0⁴\0⁸⁸⁸⁶-#ᶜd⁶.\0\0\0¹¹¹¹¹²4ᶜ5⁶.\0\0\0\0\0\0█ら²4ᶜ1⁶.\0\0\0\0\0\0qク⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0 ²4  ᶜ2⁶.80 \0\0\0\0\0\n²1ᶜ3⁶.ウ🅾️ᶜ²&fらら⁸⁶-#ᶜ5⁶.\0\0¹¹¹\0⁶‖²1ᶜ2⁶.@\0\0\0\0\0\0\0⁸⁶-#ᶜ4⁶.⁴\0⁸⁸\0⁸、ᶜ⁸⁶-#ᶜ5⁶.\0\0\0\0█ららら²1ᶜ2⁶.ヲ◜゛\0\0\0\0\0⁸⁶-#ᶜ3⁶.\0\0\0フッュ|⁘⁸⁶-#ᶜ5⁶.\0\0\0\0¹\0█\n²1ᶜ2⁶.○⁴\0\0\0\0\0\0⁸⁶-#ᶜ3⁶.\0\0웃♪⁴²\0\0²1⁶.\0ᶠᶠ³¹\0\0\0⁸⁶-#ᶜ4⁶.>0\0\0\0ナ█☉⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0`p²1ᶜ4⁶.~゜🅾️\0\0レ#⁙⁸⁶-#ᶜ9⁶.\0\0\0\0\0²オナ²1ᶜ4⁶.NG⁷⁴\0⁷⁷³⁸⁶-#ᶜ5⁶.\0\0\0\0⁸▮▮ ⁸⁶-#ᶜ9⁶.\0\0@\0\0\0\0⁴⁸⁶-#ᶜd⁶.\0▮「⁸▮`@\0²1ᶜ4⁶.「\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0²¹¹\0\0\0⁸⁶-#ᶜd⁶.³¹\0\0\0\0\0\0²1ᶜ4⁶.◜>゛ᵉ²\0\0\0⁸⁶-#ᶜ5⁶.¹¹¹\0\0\0\0¹⁸⁶-#ᶜ9⁶.\0らナぬもゆ>v²1ᶜ4⁶.¹¹\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0 0\0▮\0⁸⁶-#ᶜ9⁶.⁴░⁵¹³⁷⁷²⁸⁶-#ᶜa⁶.\0\0\0█\0\0\0\0⁸⁶-#ᶜd⁶.ら@ら@らpら@⁸⁶-#ᶜf⁶.\0\0\0\0\0█\0\0²1ᶜ4⁶.ららららナナ@\0⁸⁶-#ᶜ5⁶.\0\0\0\0⁴\0⁴\0⁸⁶-#ᶜ9⁶.▮▮▮\0\0▮0 ⁸⁶-#ᶜd⁶.¹¹¹³³⁷¹¹²1ᶜ4⁶.?゜゛¥ᵉ⁶⁶⁷⁸⁶-#ᶜ5⁶.@@@\0\0\0\0@⁸⁶-#ᶜ9⁶.\0  $0800²1ᶜ5⁶.\0\0 @@\0\0\0⁸⁶-#ᶜ9⁶.ᶜ\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.`@\0\0\0\0\0\0²1ᶜ4⁶.ンヨユユナナ\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0⁸⁴⁴²⁸⁶-#ᶜ9⁶.\0\0¹\0▮▮ユユ⁸⁶-#ᶜd⁶.\0⁴ᶜ⁸⁴³¹\0²4ᶜ9⁶.\0\0\0\0\0█らナ²4ᶜ3⁶.\0\0\0\0█らユヲ⁸⁶-#ᶜ9⁶.\0\0cめU?ᶠ⁷\n²1ᶜ3⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.⁙#C³³」98²1ᶜ4⁶.⁸⁸\0\0   \0⁸⁶-#ᶜ5⁶.ナナナユPPPユ²1⁶.⁶²\0\0@ナユヲ⁶.「、\0⁸せけのス²1ᶜ3⁶.\0⁶⁷\0▮p █⁸⁶-#ᶜ5⁶.\0\0\0\0¹\0▮⁸⁸⁶-#ᶜ9⁶.ュ「\0\0\0\0\0\0²1ᶜ3⁶.\0\0\0\0⁷、、y⁸⁶-#ᶜ4⁶.³▮█\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0⁶⁸⁶-#ᶜ9⁶.ユナ\0゜8` \0²1ᶜ4⁶.³¹¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.⁴⁶ᵉ゜??>>²1ᶜ5⁶.███@\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0█████⁸⁶-#ᶜd⁶.\0\0\0\0⁵⁴\0\0²1ᶜ5⁶.\0\0\0\0\0█@ ⁸⁶-#ᶜ9⁶.ワワフO\r。\r³²1ᶜ5⁶.(0▮「⁶²¹³⁸⁶-#ᶜ9⁶.\0\0   \0\0\0⁸⁶-#ᶜa⁶.\0\0\0\0\0\0 \0⁸⁶-#ᶜd⁶.@DB\0\0@PP²1ᶜ4⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\n⁶⁵ᶜ0きDd⁸⁶-#ᶜ9⁶.\0██\0\0\0²\0⁸⁶-#ᶜd⁶.¹■ \0\0¹¹¹⁸⁶-#ᶜf⁶.\0\0²²²\0\0\0²1ᶜ4⁶.³\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.███\0\0\0¹²⁸⁶-#ᶜ9⁶.twsセスチスナ²1ᶜ5⁶.\0\0\0¹\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0P▮▮\0²1ᶜ4⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ9⁶.ユユヲュ◜◜◜>²3ᶜ4⁶.|ュュ>◀き\n⁙⁸⁶-#ᶜ9⁶.⬇️³³りホ_ul²3ᶜ5⁶.\0らナユ☉▤ュュ⁸⁶-#ᶜ9⁶.³³¹¹\0\0\0\0\n²1ᶜ5⁶. ▮`881#ᵉ²1ᶜ4⁶. p000▮▮▮⁸⁶-#ᶜ5⁶.ス☉っっっヘヘナ²1ᶜ4⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ5⁶.ヲュュュュュ<ᵉ²1ᶜ4⁶.▮ら`⁸<⁶³\0⁸⁶-#ᶜ5⁶.\r。。5らっユン²1ᶜ3⁶.らスまCり█\0\0⁸⁶-#ᶜ4⁶.\0¹\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.$ F😐&sン}²1ᶜ3⁶.yャャリ♥⁶⁶`⁸⁶-#ᶜ5⁶.⁶⁴\0\0pヨホ◆²1ᶜ3⁶.\0⁴。=}zH@⁸⁶-#ᶜ5⁶.███🐱🐱⁵&.⁸⁶-#ᶜ9⁶.|x`@\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0███²1ᶜ5⁶.\0¹²⁵\0\0¹²⁸⁶-#ᶜ9⁶.█████\0\0\0⁸⁶-#ᶜd⁶.¹²¹²¹\0\0\0²1ᶜ5⁶.\0█@`▮\0\0\0⁸⁶-#ᶜ9⁶.³⁷⁷³¹\0\0\0⁸⁶-#ᶜd⁶.█@ ▮\0@ 0²1ᶜ5⁶.⁙▮0⁘、‖‖5⁸⁶-#ᶜ9⁶.\0\0⁸ ²²²²⁸⁶-#ᶜd⁶.@LBB@@@█⁸⁶-#ᶜf⁶. \0\0\0\0⁸\0\0²1ᶜ5⁶.ノ😐⁶⁘、TTV⁸⁶-#ᶜ9⁶.²\0⁸\0 (  ⁸⁶-#ᶜa⁶.\0\0\0²\0\0\0\0⁸⁶-#ᶜd⁶.¹¹¹¹¹¹¹\0²1ᶜ5⁶.\0¹¹³⁴\0\0\0⁸⁶-#ᶜ9⁶.ナユユナ@\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0¹²⁶²1ᶜ5⁶.█らきオ█\0@ ⁸⁶-#ᶜd⁶.@ @ @███²3ᶜ4⁶.ら█ ら\0\0\0\0⁸⁶-#ᶜ9⁶.?○ト?◝○゜ᶠ²3ᶜ1⁶.\0\0@█████⁸⁶-#ᶜ4⁶.\r⁴\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0⁸⁸⁶-#ᶜ9⁶.r{?ᶠ¹\0\0\0²3ᶜ1⁶.\0\0\0\0⁸▮▮▮⁸⁶-#ᶜ5⁶.██ららユム	を\n²1⁶.><yリネフんれ²1ᶜ4⁶.\0\0\0▮\0\0\0█⁸⁶-#ᶜ5⁶.ユpphx」み}²1ᶜ4⁶.`0「⁸ᶠ⁷³¹⁸⁶-#ᶜ5⁶.★\n⁴⁶ナユ\0²²1⁶.p\0◜゜かフヲユ⁶.x`◝ヲニ♥ᵉn²1ᶜ3⁶.ら░\0き \0\0\0⁸⁶-#ᶜ5⁶.゜Zゆ゜゛¹¹\0²1ᶜ3⁶.\0²\n¥:h` ⁸⁶-#ᶜ5⁶.fdp`@\0█\0⁸⁶-#ᶜd⁶.██████\0\0²1ᶜ5⁶.²²²²⁶⁷³⁷⁸⁶-#ᶜd⁶.¹\0¹\0¹\0\0\0²1⁶.(  ▮⁸\0\0\0²1ᶜ5⁶.⁘「⁸\0`0「ᶜ⁸⁶-#ᶜd⁶.ら@ ▮⁸ᶜ⁶@²1ᶜ5⁶.⁘ᶜ⁸\0³⁶ᶜ「⁸⁶-#ᶜd⁶.¹¹²⁴⁸「0¹²1⁶.\n²²⁴⁸\0\0\0²1ᶜ5⁶.    0pナp⁸⁶-#ᶜd⁶.ら█ら█ら█\0\0²1ᶜ3⁶.ユユヘlモヤエᵉ⁸⁶-#ᶜ5⁶.\0\0\0█\0\0 ナ⁸⁶-#ᶜ9⁶.ᶠᶠ⁷³¹\0\0\0²1ᶜ3⁶.'\0…まめ::¥⁸⁶-#ᶜ5⁶.「?/³\0\0@ ²1ᶜ3⁶.ᶠᶠᶠ⁷³³³\0⁸⁶-#ᶜ5⁶.ナナナ` \0\0³\n²1ᶜ4⁶.\0\0█\0\0 `ぬ⁸⁶-#ᶜ5⁶.▒\0\0\0\0\0█\0²1ᶜ4⁶.ららDD⁶³¹¹⁸⁶-#ᶜ5⁶.=?む:9😐をヒ²1ᶜ4⁶.\0\0\0\0\0ナぬ\0⁸⁶-#ᶜ5⁶.¹\0\0\0=゜ᶠ⁷²1ᶜ4⁶.\0\0\0\0\0³⁷゛⁸⁶-#ᶜ5⁶.ナら█\0\0\0\0\0²1⁶.vdd⁴D⁴▮\0  ⁶.²\0\0\0\0\0\0\0ᶜd⁶.█\0@ ▮▮\0\0²1ᶜ5⁶.⁴\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0@\0\0\0□\0\0⁸⁶-#ᶜd⁶.¹¹\0@@\0\0\0²1ᶜ5⁶.▮\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0¹¹\0\0\0⁸⁶-#ᶜd⁶.らA\0\0\0$\0\0²1ᶜ5⁶.\0\0\0\0\0\0\0▮⁸⁶-#ᶜd⁶.\0\0¹²⁴⁴\0\0²1ᶜ5⁶. \0\0\0\0\0\0\0²1ᶜ3⁶.ᶜᶜᵉ\n\0\0\0\0⁸⁶-#ᶜ5⁶.るるらら@@\0\0²1ᶜ3⁶.\n²²\0\0\0\0\0⁸⁶-#ᶜ5⁶.08▮□⁘▮\0\0²1⁶.³³³³\0\0\0\0\n²1ᶜ4⁶.PP\0⁴\0\0⁘\0⁸⁶-#ᶜ5⁶.██らナユ\0\0H²1⁶.フ{=゜ᶠᶠ⁷⁷⁶.³\0\0\0\0\0\0\0ᶜ4⁶.ユナ`ら█\0\0\0⁶.ᶠ◝█\0¹¹\0\0⁶.\0¹♥_\0\0\0\0⁶.'9\0\0\0\0\0\0  ²1ᶜ8⁶.\0\0\0\0\0█ら@⁸⁶-#ᶜ9⁶.²\0\0\0\0\0\0█⁸⁶-#ᶜd⁶.▮\0\0□█@\0⁸²1ᶜ5⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0¹¹⁸⁶-#ᶜ9⁶. \0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.⁴\0\0$\0¹\0⁸²1ᶜ4⁶.008(.⁶▶ᵇ⁸⁶-#ᶜ5⁶.⁸ᶜ⁴⁶\0¹\0▮²1    \n²1ᶜ4⁶.\0\0\0\0⁸⁸▮ ⁸⁶-#ᶜ5⁶.X「⁘ろららら█²1⁶.²\0¹¹¹\0▒?²1ᶜ4⁶.\0\0█ナ\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0L□.⁷¹\0²1ᶜ4⁶.`<ᶠ¹\0\0\0\0²1ᶜ3⁶.\0\0\0ららナユユ⁸⁶-#ᶜ4⁶.⁷\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0 ▮⁸ᶜ⁸⁶-#ᶜb⁶.\0\0█\0\0\0\0\0²1ᶜ3⁶.\0\0\0?○?\0⁷⁸⁶-#ᶜb⁶.\0~◝ら█ら◝ヲ²1ᶜ3⁶.\0\0\0\0\0000ュ◜⁸⁶-#ᶜb⁶.\0\0ᶠ?◝エ³¹²1ᶜ3⁶.\0\0\0\0\0\0\0¹⁸⁶-#ᶜb⁶.\0\0\0\0\0³⁷ᵉ²1 ²1ᶜ4⁶.\0\0\0@\0@\0█⁸⁶-#ᶜ9⁶.ら\0\0█\0\0\0@⁸⁶-#ᶜa⁶.\0ら\0\0\0█\0\0⁸⁶-#ᶜd⁶.□□\0\0\0\0\0\0²1ᶜ4⁶.ららら█\0\0\0\0⁸⁶-#ᶜ9⁶.¹\0\0\0\0¹\0\0⁸⁶-#ᶜa⁶.\0¹\0¹\0\0\0\0⁸⁶-#ᶜd⁶.$$\0\0\0\0\0\0²1ᶜ4⁶.\r⁷⁙ᶜ¹▮「\0⁸⁶-#ᶜ5⁶.@` 0ᵉ#`8²1    \n²1ᶜ4⁶.\0\0\0 \0\0@ ⁸⁶-#ᶜ5⁶.らら██\0\0\0\0²1⁶.゜ᶠᶠᶠᶠ゜?: ⁶.\0\0\0█ららナユ²1ᶜ3⁶.ヲ<ュュ~◜ヲナ⁸⁶-#ᶜ5⁶.⁶²³³¹¹⁷゜⁸⁶-#ᶜb⁶.\0ら\0\0█\0\0\0²3ᶜ5⁶.\0\0\0\0\0\0「゜⁸⁶-#ᶜb⁶.ュ○゜?g\0\0\0²3⁶.⁷ᵉ、「\0\0\0\0²3ᶜ1⁶.ユナら█\0\0\0\0⁸⁶-#ᶜb⁶.ᶜ「0pナナナら²1⁶.\0\0\0\0\0¹¹¹ᶜ2⁶.\0\0\0\0\0A█ワ²1⁶.\0\0\0\0\0、<s⁸⁶-#ᶜ5⁶.\0\0\0█\0\0\0\0²1ᶜ2⁶.\0\0\0\0\0\0█\0⁸⁶-#ᶜ4⁶.ᶜ⁶⁷⁷\0²²²⁸⁶-#ᶜ5⁶.3	`8゜¹\0 ²1    \n²1ᶜ4⁶.0<゛ᵉ◆ん¹ ⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0らら²1ᶜ4⁶.\0\0\0\0¹\0\0\0⁸⁶-#ᶜ5⁶.ュュゆ?~○ws²1⁶.\0¹³³³³³▒²1ᶜ3⁶.\0らナユx8、⁶⁸⁶-#ᶜ5⁶.ヲ8、ᶜ●をネン²3⁶.◜ュ◜◝◝◝◝◝²3ᶜ1⁶.\0\0\0\0\0²⁴ᶜ⁸⁶-#ᶜ5⁶.⁷ᶠか??ョャリ²3ᶜ1⁶.\0\0\0\0\0\0⁶⁴⁸⁶-#ᶜ5⁶.\0\0\0>◝○ンャ²3⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜb⁶.らららららららら²1ᶜ2⁶.\0@\0█ナらら█⁸⁶-#ᶜb⁶.¹¹¹¹\0\0\0\0⁸⁶-#ᶜe⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜf⁶.\0\0\0\0\0\0²²²1ᶜ2⁶.ナ▤xフか○'●⁶.}ヌ゛「ッ◜◜ン²1⁶.\0███り¹らる⁸⁶-#ᶜ4⁶.⁴⁴⁴⁴⁴⁴⁴⁴⁸⁶-#ᶜ5⁶.        ²1ᶜ2⁶.¹\0\0³⁵\0!Q  ²1ᶜd⁶.\0\0\0\0\0\0\"$⁸⁶-#ᶜf⁶.\0\0\0\0\0³⁘\0\n²1ᶜ4⁶.<ᶠ⁷³\0\0\0\0⁸⁶-#ᶜ5⁶.らユ8もよよよト²1⁶.ンュッャンンンq⁶.りニニニユユヲヲ⁶.◝◝よ○○◝◝◝⁶.◝◝◝◝◜◜◜ッ⁶.ワヤヤハハハa¹⁶.ャャャャャンヲヲ²1ᶜ3⁶.<▮8「\0\0\0\0⁸⁶-#ᶜ5⁶.³ᶠ⁷'?○○○⁸⁶-#ᶜb⁶.@`\0\0\0\0\0\0⁸⁶-#ᶜe⁶.████\0\0\0\0²1ᶜ2⁶.\0\0``「⁸r█⁸⁶-#ᶜe⁶.¹³³\0\0\0\0\0⁸⁶-#ᶜf⁶.⁶⁴\0\0\0\0\0\0²1ᶜ2⁶.█(ロ◆vンヲ◝⁶.■ら>ュヲャ⁷れ²1⁶.れられられれ█⬇️⁸⁶-#ᶜ4⁶.⁴\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶. $$$$$dD²1ᶜ2⁶.Sはれナか?ᶠ?²1⁶.\0\0¹²\0⁸⁴「⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜf⁶.\0\0\0\0\0\0█@²1ᶜ5⁶.\0\0\0\0\0\0\0🐱⁸⁶-#ᶜd⁶.\0\0\0\0\0\0♥¹²1ᶜ5⁶.$6□□\0\0\0¹⁸⁶-#ᶜd⁶.\0\0\0\0\0³³.⁸⁶-#ᶜf⁶.\0\0\0\0\0\0ᶜ▮\n²1ᶜ5⁶.んれらナユp8.⁶.q \0\0\0\0\0\0⁶.ヲュュヲ\0\0\0\0⁶.○゜⁷\0\0\0\0\0⁶.ワみB$\0\0\0\0⁶.²\0\0\0█ららナ⁶.ュュ◜◝◝シ/゜²1⁶.○w{{}}>>⁸⁶-#ᶜ8⁶.███████\0²1ᶜ2⁶.ムナヲヲヲムオユ⁸⁶-#ᶜ8⁶.¹³⁷⁷⁷³²\0²1ᶜ2⁶.◝◝◝xいネ◝⬅️²1⁶.よ{wo゜??>⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜe⁶.\0\0██らら@\0²1ᶜ2⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.@@\0\0\0\0³¹⁸⁶-#ᶜe⁶.\0⁴⁴ᶜ\0¹██⁸⁶-#ᶜf⁶.⁷³れリエを\0\0²1ᶜ2⁶.゜゛ っスナナユ⁸⁶-#ᶜd⁶.\0\0\0\0\0\0⁴⁶⁸⁶-#ᶜe⁶.\0\0²⁶⁶⁷³¹⁸⁶-#ᶜf⁶.\0¹¹¹¹\0\0\0²1ᶜ2⁶.80  !/⁷7⁸⁶-#ᶜ5⁶.\0█らら@\0\0\0⁸⁶-#ᶜd⁶.ら@\0\0\0\0\0\0²1ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0☉\0らユ█⁸⁶-#ᶜf⁶.\0\0\0pヲ>ᵉ\n²1ᶜ5⁶.⁷ᶜ⁸▮\0\0\0⁶⁸⁶-#ᶜd⁶.x@@ ¹²³¹⁸⁶-#ᶜf⁶.\0\0\0\0\0¹\0\0\n²1ᶜ5⁶.&:⁙▶⁷³³¹²1ᶜ3⁶.\0\0\0█らユヲ~⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0█²1ᶜ3⁶.`<?゜゜⁷¹\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0⁸ᵉ⁷²1  ⁶.ユユ\0\0\0\0\0\0⁶.³\0█ら ██\0⁶.よトフヨヲ◝◝◝²2ᶜ3⁶.\0<◝◝◜ュナ\0⁸⁶-#ᶜ5⁶.ᶠ³\0\0¹³゜◝²2ᶜ1⁶.ら\0█\0`ら\0\0⁸⁶-#ᶜ3⁶.\0\0\0¹³⁷゜○⁸⁶-#ᶜ5⁶.\0\0¹🐱う8ナ█²2ᶜ1⁶.ᵉ⁷██らナヨリ⁸⁶-#ᶜ5⁶.ナヲ~○?゜ᵉᶜ²1⁶.\0\0\0\0\0██ら⁸⁶-#ᶜd⁶.\0████\0\0\0⁸⁶-#ᶜe⁶.█\0\0\0\0\0\0\0²1ᶜ2⁶.ュュ◜◜ト8ョ◝⁸⁶-#ᶜd⁶.³³¹¹\0\0\0\0²1ᶜ2⁶.7にに⬇️\0らネネ⁸⁶-#ᶜ5⁶.\0\0\0\0▮⁸⁸ᶜ⁸⁶-#ᶜ6⁶.\0\0\0⁸⁷³\0\0⁸⁶-#ᶜd⁶.\0\0\0p⁸⁴⁴\0²1ᶜ2⁶.\0\0\0\0\0\0▮0⁸⁶-#ᶜ5⁶.ら█p▮😐ᶜ\0\0⁸⁶-#ᶜd⁶.\nᶜᵉ²²²\0\0²1ᶜ5⁶.⁷²\0\0¹¹³¹⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0ᵉ\n²1ᶜ3⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0@ナユユヲュ◜²1ᶜ3⁶.?³\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.らュ?ᶠ⁷³\0\0²1⁶.³¹\0\0\0\0\0\0    ⁶.おxナら\0\0\0\0⁶.◝◜◝ンネウ▤0²3⁶.¹³³⁷??◝◝²1ᶜ2⁶.\0\0\0\0\0█らナ⁸⁶-#ᶜ5⁶.⁵¹¹¹¹¹\0\0²1ᶜ2⁶.⁸ᶜᵉᵉᶠᶠᶠᶠ⁸⁶-#ᶜ4⁶.\0████ららら⁸⁶-#ᶜ5⁶.ら@@`` \0\0²1ᶜ2⁶.◝◝◝0ょ◝◝◝⁶.ネ゜◝◝◝◝◝◝⁶.i}pO゜か◆?²1⁶.\0\0\0\0ᵉᶠ゜ᶠ⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.²²\0\0\0\0\0\0"

__gfx__
77777777eeeeeeee777777777777e77777777777777777777777777777777777777eeee7777777777777777eeeee777777777777eeee7eeeee77777777777777
7777777e00000000ee777777777e0e77eeeeeee77777e777777777777eeeee7777e0000e7777777777777ee00000ee77777777ee0000e00000e7777799799777
777777e0111133bb00e7777777e0d0ee0000000ee77e0e7777777777e00000ee7e0dddd077777777777ee005555500e777777e00dd660677770e777789998777
77777e01111111133b0e77777e00d0e0322222200ee0d0e77777777e02dddd00e0dddddd7777777777e00555555555077777e0ddddd667777670e77788988777
7777e0111111111113b0e777e0dd0e034aaa942240e0d0e77777777e0222ddd00ddd555d777777777e005555dddd55577777e0dddddd66666660e77778887777
7777e011111110011130ee770d1100344aaa9942240d10e777eee7e02112d1100dd5111d77777777e005533333b33dd777770d666ddddddddd660e7777877777
7777e01101311070113000ee01dd003449aa9992241150e77e000ee021121135dd51111d7777777e0055d3bbbb3333d77770dd666dddddddddd600e772227777
7777e0107131107011354a0e05d1003499999a49241510e7e00dd0ee01111335dd5111dd777777e005533bbbdd3b33d777e0dd6ddddddd11dddd0d0e26662777
7777e010711110001135490e011dd1044999aa92221510e7e0d00e77e01333555d111ddd777777e00333333d33b3ddd777e0d6dddddddffdd1d60d0e61116777
7777e0100155100111350eeee01515044499994422110e77e000e777e0333355555555d07777ee0053b111b3333d11177e0dd6d6dd00dff001dd0dcec1c1c777
7777e01005111011133550e7e011150444999a942400e777e0d0e777e03333500055550e777e00003b11001b33d10017ee0dddd6dd0000f000dddd0ec111c777
7777e01151000701113350e77e01110441144a41140e7777e000e77e03d355000005550e777e0011331044013510440e000dddd7dd294ff2901dcd0e1ccc1777
77777e01504440001133300e77e0004441111a11140e7777e0d30eee0dd505070055550e777e01b3133049000100940e0d0ddd7dddfffffff01ddd0e71117777
77777e01507070001113110e777e044441880908840e77777e003000dd5505001d33550e777e01031330290100109207e0ddd67dddfcffefe016c0e772227777
7eee7e01500000011111310e777e044444009940240ee77777e03300d5555001d333500e777e000053300201501020077e06d67ddd5cffffe016dd0e2eee2777
e000ee01500002011111110e77e000494440040024000e77777e00005555555dd335500e7777e0101531000150100017e06ddd67ddd5f88ee0d66c0ee181e777
01110e01500080111111110e7e0f504944430002490550e77777ee0dd55555555552500077777e0011b3113500011137e06dddd67ddd5fee0ddd6c0e88188777
01110e0115500051111111007e0f5001444400024905f0e77777e01d1155252055225000777777e0013bb333000533b7e0616dddd76d55e01ddcc0d081818777
11bb100111555511131311007e0ff501944430249105f0e77777e0011052550115220010777777e00553333350055337e0d16d1ddd6ddd011dccc0d018881777
1bb310011155511113111110e00fff5019443044910f500e7777e0200228804108221110777777e0051551b33555d137e0d16d1d1d666d115dccc00e71117777
11333111dfd1511113111110033fff50124430491055ff007777e0022280014082211110777777e00305b11bbbdd1137e0d16d1551dd6dd15c66c00077777777
0111331dfddd5111155111113330f5f000244044005fff00777e000000019100220511107777eee00305b104090411be0016d113351dddddc6ff6cc077777777
0111131d0d0d1111115515111133ff5f000220201055f03177e0110090914008205dd1107eee00e00b0531000f0010be006dd1bbb3d11ddcc6ffff6077777777
e0111111d0d1111111115555113305f555010001055ff0317e011d114242202205dd5330e00e00ee000113140005001e0ddd13bb31dd15dcc6fffe6077777777
7e0111115d111111117715551113305555010001300003317e0d0d0d082000004dd55030e0000b0ee00103309f5500be0111313331dd15dccceeeec077777777
7e0111155111111111cc11111111110000110001333333117e0000e00800011d1dd50000e0bb0300e001003333500037e0111d1331dd1bd0cccecc0e77777777
77e01115555111111677111111111111111000001111111777e0e0ee0000d01dd50000d1e0330dd00001000055000007e0331d1331d13bd50c3ee0e777777777
7e0011150551111177761117777777777777777777777777777eeeeeeeeedddddddddd110001dd5d0000000000000017e0111dd11dd131d550bff0e777777777
e00111500551111066601177777777777777777777777777777dddddddddddddddddddd7000111555500000005551117e01111ddddd1111550b330e777777777
001110000051117700017777777777777777777777777777777777777777777777777777777777777777777777777777011111111111111550bb30e777777777
7777777ee777ee7eee777777777ccc777777777777777777777777777fffff7777777777777ffffffff777777777777fff77777777777cc77cc77cc77cc7c777
777777e000ee0ee000e7777777c000c7777777777777777777777777f0000f777777777777ff000000f777777777fff000f7777777777cc77cc77cc77cc70777
777777e090e0900aaa0e77777c04450cc7777777777777777777777f00000f77777777777f00000000f77777777f0007660f7777777770077007700770077777
777777e0a0e09900aa0e7777c004a4500cccc77777777777777777f006600f7777777777f000c6d00f77777777f00c766d0f77ffff777ccccccccccccccccc77
77777e0a90e099099a0e7777c049aa4450000c77777777777ff77f0067d00f777777777f0ccc7dd00f777777ff00c76ddd00ff000f777ccccccccccccccccc77
7777e0aa99099999aaa0e777c0499aa4444500c777777777f00ff0067d00f777777777f00c776d00f777777f000c76dddd0000000f7770000000000000000077
77770aa9999dddd99aaa0e770c0499faa999040c7777777f00000067d00f777777777f00cd76d00f777777f000776dd0dd500a900f777ccccccccccccccccc77
77e0aaa99dd6666d99aa90e70c00499aaaaa9900c777777f044006cd00f7777777777f0cdd76d00f777777f00776d00d55505440f7777ccccccccccccccccc77
7e09a99d66667776d9a9a0e77cc0049faaaaa9050c77777f00490cd00f7777777777f007dd7dd0f7777777f0076dd00551115240f77770000000000000000077
7e0994d6666667776099990e7c0500999aaaa9540c777777f009a700f77fffff7777f0c77d7d00f7777777f006dd0d55511d2200f7777ccccccccccccccccc77
7e094466666666776609990ec04450099faaf94000c7777f00929a00f7f0000f777f00777d6d00f77777777f00ddd55111dd51000f777c000000000000000c77
e0940d666666167763d0490ec099445999ff9900490c77f0092209900f00000f777f0077661d00f777777777f00055511dd5115000f77c777777777777777c77
e0940d66661006770130490ec0f9944f999990499990cf00922000400006600f777f0077661100f7777777777ff00011dd511150000f7c77ccc77cc77cc77c77
e0940d666d000d770030490ec0044444f99904990090cf009200f0000067d00f777f00766d1100f777777777777f000dd511555ddd00fc77c007c007c0c77c77
e0940dd6dd000d630030940e0cc00044449004900090cf0000000f00067d00f7777f00766d1100f77777777777f00000511555ddd660fc77ccc7c777c7c77c77
7e040ddddd001d630130920e000ccc0044404900050c0f000000000067d00f77777f0076d11100f7777777777f00550011155dd0d660fc7700c7c777c7c77c77
7e0440ddd3311d1313d0920e000000cc00004400540c0fffff044006cd00f777fff000000000000f77777777f00552200555d00d6660fc77ccc7ccc7ccc77c77
7ee0490d5533d1003350920e77700000ccc0445540c007777f00490cd00f7777f0000000000000000077777f0055220005ddd0066c00fc770007000700077c77
e0002290555dd100550920e777770000000c04400c00777777f009a700f77777f009aaaaa9999994007777f0055220000ddd0d66c00f7c77c7c7cc77cc777c77
011002220055d335002220e7777777000000c00cc00077777f00929a00f77777700499000000094400777f00552200ff00ddd66c00f77c77c7c7c0c7c0c77c77
011000000d00737500000e777777777700000cc000077777f0092209900f77777f004400444004400f77f009a2200f7f00d666000f777c77c7c7c7c7c7c77c77
011110000d0707000eeee77777777777777000000077777f00922000400f777777f0000099400000f77f00944400f777f000000ff7777c77c7c7c7c7c7c77c77
e00022100dd3335000e7777777777777777700000777777f009200f000f77777777f00000000000f777f0554400f77777f0000f777777c770cc7c7c7ccc77c77
7ee0000220ddd350110e777777777777777777777777777f00000f7fff7777777777d000445000d7777f022200f7777777ffff7777777c777007070700077c77
77e00404020000011420e77777777777777777777777777f0000f777777777777777d009a95500d7777f02200f7777777777777777777c77ccc7ccc7c7777c77
7e0024440022110124420e7777777777777777777777777fffff7777777777777777d009aa5400d7777f0000f77777777777777777777c77c0c7c007c7777c77
e00024442200101222420e77777777777777777777777777777777777777777777777d0009400d77777f000f777777777777777777777c77cc07cc77c7777c77
e002244222220112222200e77777777777777777777777777777777777777777777777d00000d777777ffff7777777777777777777777c77c0c7c077c7777c77
00224421122201112221000e77777777777777777777777777777777777777777777777d000d777777777777777777777777777777777c77c7c7ccc7ccc77c77
002222111122011111111000777777ffff77777777777777777777777777777777777777ddd7777777777777777777777777777777777c770707000700077c77
777777f00ff777777777777777777f0000f77777777777777777777777777777777777777777777777777777777777777777777777777c777777777777777c77
77777f00000f7777777777777777f0ff990f7777777777777777777777777777777777777777777777777777777777777777777777777ccccccccccccccccc77
77777f003000f777777777777777f094440f77777777777777777777777777777777777777777771111777777777777777777777777770000000000000000077
77777f003bb00f7777777777777f00094000f7777777777777777777777777777777777777111117777111177777777777777777777777777777777777777777
77777ff033bb0f777777777777f0070000c00f777777777777777777777777777777777771777777777777711117777777777777777777777777777777777777
7777777f033300f77777777777f00d766cd00f777777777777777777777777777777777117777777777777777771177777777777777777777777777777777777
777777f0033300ff77777777777f00000000f7777777777777777777777777771777711777777777777777777777717777777777777777777777777777777777
77777f0008358000ff777777777fff0d10fff7777777777777777777777777717177177777777777777777777777771177777777777777777777777777777777
7777f0088885888000f7777777777f0d10f777777777777777777777777777717711777777777777775777777777777717777777777777777777777777777777
777f088888851888800f77777777f00d500f77777777777777777777777777717717777777577777775777777777777771777777777777777777777777777777
77f0888811111122220f7777777f000d5000f7777777777777777777777777717777777775577777755777777777777571777777777777777777777777777777
7f008881881188822200f77777f000d7cd000f777777777777777777777771117777777755777777757777777777775777177777777777777777777777777777
f008888a9818888821200f777f006dc7cc1500f77777777777777777777717777777777755777777557777777777775757717777777777777777777777777777
f008289a9888888821200f77f00671ddd1c1500f7777777777777777777771777777777755775775557777777777757577771777777777777777777777777777
f002289a8898888221200f7f00676c111cccd500f777777777777777777777177777777755775775557777777777577577771777777777777777777777777777
f00228889888882211200f7f0076c8822eccd500f777777777777777777777177777777755775755577751111777575777771777777777777777777777777777
f00222888888822111200ff0077c8888e286dd500f77777777777777777777177777777755575555777555111117775777771777777777777777777777777777
7f002288882222111200f7f007c7778e2226dd100f77777777777777777777177777777775577755775555111117777777771777777777777777777777777777
7f00222222221111120f77f006c77788226ddc100f77777777777777777777177777711775577777755555511111717777711177777777777777777777777777
77f0022111111112200f77f006c77721116ddc100f77777777777777777777717777155557757777555555511111717177717177777777777777777777777777
777f00022111122000f777f006c8822116ddcc100f77777777777777777777717777155555777775555555777711777177777177777777777777777777777777
7777f00002222000ff77777f00c882111dddcc001677777777777777777777717777115555577755555577555571177177771777777777777777777777777777
77777f000000000f7777777f006c82111ddc61001677777777777777777777771777115551555555555755555117171177771115555555777777777777777777
777777ff000000f777777777d001c882ddd610011677777777777777555555555777771555555551557555511771111177711115555555555555777777777777
77777777ffffff7777777777d1001cccccc100111677777777775555555555555777777155511115575551177111111777711111155555555555557777777777
7777777777777777777777777d100011110001116777777777555555555555555777117715555555575551771111111777111111111555555555555777777777
77777777777777777777777777d110000001111d7777777755555555555555555777111171555775755517771111111777715555111155555555555557777777
777777777777777777777777777dd1111111d6677777777555555555555555115777711117755757551177771111711777711155555115555555555555577777
77777777777777777777777777777dddddddd7777777775555555555555511111177771111711755511777771111717777111111555555555555555555555777
77777777777777777777777777777777777777777777555555555555551111111177777771771177777777771111777711111111155555555555555555555777
77777777777777777777777777777777777777777775555555555555111111111177777777771117777775571111777771111111111555555555555555557777
77777777777777777777777777777777777777777755555555555551111111111177777577771117775775771111777717111111111155555555555557777777
77777777777777777777777777777777777777777777777775555551111111111177777755775517777557771111777771711111111155555555557777777777
77777777777777777777777777777777777777777777777777775511111111111117117777775517777777111511777771711111111111555555777777777777
77777777777777777777777777777777777777777777777777777777777771111777511777715511177111155511777771717111111111555557777777777777
77777777777777777777777777777777777777777777777777777777777777717717755177155551171555555111777777171711111111155777777777777777
77777777777777777777777777777777777777777777777777777777777777777177777177155551771155557117777777717171111111177777777777777777
77777777777777777777777777777777777777777777777777777777777777771117777777755511717115557777777777717171111111177777777777777777
77777777777777777777777777777777777777777777777777777777777777777111777777777771711111777777777777717717111111777777777777777777
77777777777777777777777777777777777777777777777777777777777777777111177777777111711777777777777777771717111117777777777777777777
77777777777777777777777777777777777777777777777777777777777777777711117777711117117771177777777777771717111177777777777777777777
77777777777777777777777777777777777777777777777777777777777777777771117777777777777711777777777777777171111777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777111777177777577111777777777777777111177771177777777777777777
77777777777777777777777777777777777777777777777777777777777777777777111177171557577111777777777777777111177777117777777777777777
77777777777777777777777777777777777777777777777777777777777777777777717777777711177111777777777777777711177777155777777777777777
77777777777777777777777777777777777777777777777777777777777777777777771177711555771117777777777777777777777777115577777777777777
77777777777777777777777777777777777777777777777777777777777777777777777717777777711177777777777777777777777777111557777777777777
77777777777777777777777777777777777777777777777777777777777777777777771177777771111777777777777777777777777777711555777777777777
77777777777777777777777777777777777777777777777777777777777777777777777711771111117777777777777777777777777777711155577777777777
77777777777777777777777777777777777777777777777777777777777777777777777177177111177777777777777777777777777777771115557777777777
77777777777777777777777777777777777777777777777777777777777777777777777771777111177777777777777777777777777777771111557777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777111111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771111111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777111111111111777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771117777771117777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771117777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771117777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771177777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771177777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777771777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
__label__
11222212112221222222211222221122211222222222222122222222221122222122222211111111111222222222222222222222222222222222222222222222
11122211122221222222112222221221122222222222222122222222221122211122221112222222222222222222222222222222222222222222222222222222
2112999112222112222111222221121122222222222222212222222221122211111111222222222b22222222222222222222999ffffff2222222222222222222
211299911222219992919199922991199299929222299199222222991199919192222222222222232222222222222222222999999ffffff22222222222222222
2119999912222219229191992291119292292292119192919111229291991192922222222b22222322222b2222222222229999f999ffffff2222222222222222
22119991122222192299919222219199922922911192929911211192919122999222222223222441442223222222222222299999f9fffffff222222222222222
2211919112222219229192199299229292999219929921929299919911199229222222222322444144444322222222222222999fff999fffff22222222222222
22111221122222212112221122122222222222112222212222222111112122222222222221244441444441222222222222229999f9f99fffff22222222222222
21111999112222212112221112122222222221222222112222222221222222222222222221144411144411442222222222222999999ff9fffff2222222222222
12111921111222999192929991122229922991299291929922299299922992222222222241144411144411442222222222222999999ff99ffff2222222222222
111119211111122911929299111222929291929222991299229292191292211122222222441144111441144442222244222449999999999f9ff9222222222222
31199911111221191199929211222299929992911194929292999119221191222222222244411111111144444422244442224444999444499999222222222224
11199911111222191191912991222292119292199491949992929129119922222222222224411111111144444444444444244444444444444999222222222244
11111111111121121211111121122222112221222241144222221111111111111222222444444111114444444444444444444444444444444442222222222244
11131111121111111222222111122222112211222221144422211111122222211222224444444411144444444444444444444444444444444444444442222244
13113111122211111222222221122221112112222241144444111112222222222222244444444911194444444444444444444444444444444444444444222244
13113311122211111222222222112221111122222221144441122222222222242222444444444911194444444444444444444444444444444444444444422244
11111111112211112222222222112221111222222221141111142222222222244422444444411111111144444444444444444444444444444444444444442244
31113111112211111222222222112211111242224441211114444222222222224444444444449151514444444444444444444444444444444444444444444244
331131111112111111222222211121112111442444111114444444222222222244444444444991d1d14444444444444444444444444444444444444444444444
331111311111111211111111111111122114444444111124444444422222222444444444444991d5d19444444444444444444444444444444444444444444444
131111311111111221111112222222222114444441111244444444442222224444444444414911d5d11441444444444444444444444444444444444444444444
133111311111111211122222222222221144444411114444414444441112221544444444414911ddd11941444444444514441114444444444444444444444444
133311331111112111112222222222221144444111144444414444411d12211554444444414911dfd11941444444445511441d11444444444444444444444444
13331133114111211112222222222221144444111444444114441141dd14411154444444419111ddd11191444444445111991dd1411444444444444444444444
1333111311111111122222221121111133334411444441114441d141d111111154444499419111d9d111914444444951111111d141d144444444444444444444
513311111114111112222111311311133333111114441114444dd1911511111154444999919111ddd1119144144449511111151191dd44444444444499444994
531111111114111133311333313311133311111111111111114d11115111111114449919911115dadd1111441494491111111151111d44444444444499499949
5331131111111115531333331131111131111111111111111115d1115111111114999919991155dddd511444144499111111115111d594444444444494949493
13311331111411551133333313111111111114444941444444415dd111111111199999199991dddfddd194441449991111111111dd5194444444444999999933
155111331144415511333335111111111111199444119499444151d11111111119999911999151ddd15199411441991111111111d15199994444449999993333
515151331144115515353111111111111114999444114999449115111111111159919991191111d1d11119114441995111111111151199994444499999933333
551151131114155515511111111551111199999944119999449111111111111599919999111515d1d51511144491999511111111111199999944444999333333
55111511111415551511111111555111133991111111499949911111111111159991999911d155d1d551d1199991999511111111111199999944444499333355
5511115111111555111111111111111133311111111111144999111111111115999119991d1159d15f511d199911999511111111111999999944444493333555
551111111111555511111111111511111111111199999111999991111111115999991191111559111f5511119119919951111111119999999444449993335555
55111111111154511111115155511515511131113339991199999911d1d1111991991111155119111f115511111991991111d1d1199999999449499933353335
5115511111115451111115551511151511113331113339919999991111d1111991999115151111d1d1111515119991991111d111199999999999949433355335
5115551111115451111155551511551511115311113339111999991111111119919911515111dad1d9511151511991991111d111199999999494999333555555
1115551111115555111555551115515511151113355333311999991111111119991115115511d1d1d15115511511199911111111199999444499499333555555
11111511111554551115555551554111115115333553333111999995d11111199911111d55115fd1d951155511111999111111d5999999444944999333333335
111151111115444511555555515551444113353333533333113999955d111119999111d511dd51d1d15511155111999911111d55999999949949999333333335
11111551111544551155555551555441155333533313333331333995d511111999911d511d1955d1d559111151119999111115d5999994999999991333333355
111555111115445511555555515455113355113533113333353333955d5111199911d5511d5159d1da5151115511199911115d55999999449999333133333355
11155511111544551155555511444455355115333331555335333335d111111991115111195551d1d155591111511191111111d5999999999333333133315555
5111551111154555115555551445115555115553533155555353333d11111111111111d1595f51d1d1595951d11111111111111d999999933333333133551555
5511151111154555115555114411555551155555533515551553153d5111111111111d11595151d1d15159511d1111111111115d999993333333333153351333
1555111111114555155511445115555551555551555513351555153d151111111111dd115951551d155159511dd111111111151d999933333335333135531355
1555551111115555151154451111555111155551555551331551155dd5111111111d1d11115151ddd15151111d1d1111111115dd999933333335531133331555
1155551111115551151544111111111111111551153551531351155d1511111111111d11111551d1d15511111d1111111111151d999933335555551133331555
5115555111115551115441111555555555555555155555151313555dd511111111111d1111151d111d1511111d111111111115dd999313335555351333331555
5511555511154551155411115555511111155555555553131313355d151111111111d1111111d11111d1111111d111111111151d993313355513331333311551
5511155511155551444415555555511551111555155553111313335dd5511111111d1111111d1551551d1111111d1111111155dd933313333313331333111511
5551155551155111444155555551155555511115511111111113133d555111111111111111dd5511155dd111111111111111555d333313331313331133111111
5551115551155515441111111115555515551111511111111111133555111111111111111dd551111155dd111111111111111555333315331313335133111111
551111555155555445111111111155551555155111111111111113115551111111111111115511d1d11551111111111111115551133315551313351155111111
51111115515555445111111111111555155155511111111111111111151111111111111dd1511111111151dd1111111111111511153311551313551155111111
111111115555554411111111111111551151155111111111111111111111111111111111d1111191d11111d11111111111111111153311551315551155111111
1111111415455545111111111111111511511551111111111111111111111111111111d11111111111111111d111111111111111133311551311511155111111
111111111545554111111111111111111151111111111111111111111111111111111d11111111d1911111111d11111111111111131311551511511155111111
11111111544555115155551111111111115111511111111111111111111111111111d111111111d19111111111d1111111111111111111511151511111111111
11111411445511155555544444111111115111111111111111111111111111111111d1111911911111d11d1111d1111111111111111111511111511111111111
11111445455111555555441444411111111151111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11114414455115555551111114444111111111111111111111111111111111111111111111111111111111111111511111111111111111111111111111111111
1111414555511555551111111111444444441111111111114441141111111111111111111911d11111d119111115441111111111111111111111111111111111
11114145551555511111111111111444444444444111111141144411111111111111111111111111111111111155441111111111111111111111111111111111
11111155515555111111111111111441111111144441111411111111111111111111111111111111111111111154441111111111111111111111111111111111
1141155555555111111111111111114411111111444441411111111111111111111111111d11d11111d11d111554141111111111111111111111111111111111
1111555555551111111111111111111441111111111111111111111111111111111111111111111d11111111144414111111cc11cc11cc11cc1c111111111111
111111115555111111111111111111114111111111111111111111111111111111111111111111d8d1111111544111111111cc11cc11cc11cc10111111111111
11414111555111111111111111111111111111111111111111111111111111111111111111111188811111114441411111110011001100110011111111111111
111511515551111111111111111111111111111111111111111111111111111111111111111d1189811d1115441451111111ccccccccccccccccc11111111111
1115515115111111111111111111144144411111111111111111111111111111111111111d11d19991d11d44414411511111ccccccccccccccccc11111111111
11155111111111111111111111444411111111111bbbbbb11111111111111111111111111d11d1aaa1d11d444441155111110000000000000000011111111111
115151115111111111551154444411111111111bbbbbbbbbbbbb111111111111111111111111111111111144441145111111ccccccccccccccccc11111111111
1151115551111111151154444111111111111133333333bbbbbbbb11111111111111111111111149a1111114114455111111ccccccccccccccccc11111111111
11141155511111111555151111111111111115333333333bbbbbbbbb111111111111111111111111111111114555111111110000000000000000011111111111
1114115511111111555111111111111111115333333333bbbbbb33bbbb111111111111111111114a91111111551145111111ccccccccccccccccc11111111111
1111415551111115511111111111111111153333bbbbbbbbbb333333bbb11111111111111111111111111111111445511111c000000000000000c11111111111
1111141555555511111111111111111111553333333bbbbbb33333333bbb1111111111111111119411111111111555111111c111111111111111c11111111111
111111555555511111111111111111111553333333bbbbbbbbb3333333bb1111111111111111111111111111554455111111c11ccc11cc11cc11c11111111111
11111155555511111111111111111111153333bbbbbbbbb33bbb3333333bb111111111111111111111111111544511111111c11c001c001c0c11c11111111111
1111111555551111111111111111111155333333bbbbb33333bbb3333333bb11111111111111111111111111444115511111c11ccc1c111c1c11c11111111111
1111141555551111111111111111111555333333bbbbbb33333bb3333333bbb1111111111111111111111115444555111111c1100c1c111c1c11c11111111111
111111115555111111111111111111555333333bbbb33bb33333333333333bbb111111111111111111111111555551111111c11ccc1ccc1ccc11c11111111111
1111111155555111111111111111115553333333333333333333333333333bbbb11111112111112111222111541111111111c110001000100011c11111111111
1111114155555511111111111111155555533333333553333333333333333bbbb11111111111111211222211141111121111c11c1c1cc11cc111c11111111111
11111411151555111111111111115555555553335555533333333333333333bbb11111112221222222112221141115111111c11c1c1c0c1c0c11c11111111111
11114411115555551111111111155555355555555553333333333333333333bbb11111111111122221222221114115112111c11c1c1c1c1c1c11c11111111111
11444411115555555111111111155533335555555555333333333333333333bbb11111211112211212111222114115121111c11c1c1c1c1c1c11c11111111111
14444111155555155511111111555333355555555555533533333333333333bbb11111111112222112222111114115121111c110cc1c1c1ccc11c11111111111
14441111555555115511111111553333555555555555553335555533333333bbb11111122221122211122111114115122211c111001010100011c11111111111
44441114455555515511111115533335555555555555553355555555333333bb111112222222211212122222214115222121c11ccc1ccc1c1111c11111111111
44411144555555515511111115533355555555555155555555555553533333bbe11111222222222112222222214115111111c11c0c1c001c1111c111ff111111
41111155555155515511111155333555555555555515555551155555533333bbef1111222221121112222222114115222111c21cc01cc11c1111c1111df1fd11
11111455551155515111111553355555555555555511555555155555533333bbef1111121221111221122222124115222111c12c0c1c011c1111c11111d11d11
11444455511555555111115555555555555555555551555555155555553333beeff111111111111221112111224115222211c12c1c1ccc1ccc11c11111511511
4444555511555555511115555555555555555555555515555515555555553bbeeef111111112121111111122115115222211c210101000100011c11115515511
444555111515555551111555555555155555555555551555551555555553331eee1112211221222212222211225115222211c122211111111111c11115115111
445555155515555551111555555555515555555551511555551555555553351e111112212222111211222222115115221111ccccccccccccccccc11115115111
55555515511555551111555555555551155555555151155555155555555555111112211112212221111222222251152222220000000000000000011111111111
555555155115555511115555555555551555555551511555511555555555555111121111211222222212222222511522222222111112111111111111dd111111
555555155115555511155555555555551555555551111551111555555555555112112221111222222221111111511552222211111121111fddd1111dddff1111
55555155511155511115555555555555151555555111111111155555555555511111111222222222221111222251115222222211111221fdd51111155dddfd11
5551115551115551111555555555555155515555151111111155555555555558812212222222222222222212fff1115222222111111222dd51111111555dddd1
5511115511111511115555555555511151155515111111111155555555515558881112222222222222122221ffe11152f2222111111122d511111111115511d1
111111551111111111555555555111111511115111111111155555555515555888822222222222222221222effe111fffe1112111111125511111111111511d1
111115551111111111155555111111111151151111111111555555555515555888822222111222212222122effeefffffee2112211111255111dfffd11115d11
11115ff51fff1f1f11111fff1f1f1ff1111111fffff1111555555555515555588882222222122112222221eeffff11fffee2212221111251111fffffd1111111
11110f5f0f010f0f11110f0f0f0f0f1f11111ff0f0ff115555515155515555588822122222111222222222eeeff111ffeee11222222212111fffffddfd111111
11150f0f0ff10f0f11110ff10f0f0f0f11110fff1fff115555551511155555181811212222222222222222e55511111eeed11222222111111fffdddddd111111
15550f0f0f110fff11110f1f0f0f0f0f11110ff1f0ff155555555111155555111111222222121112122222555111111eedd12222222122111f1f111dd5511111
15510f0f0fff0fff11110f0f01ff0f0f111100fffff1555555111111555555155555222222222211211125551111111edd222222222122111d1d115555511111
15150501000100011133030110010101111110000011555511111111555551555533332222222222111555551111111ddd2222222222121211dd111515111111
55115111111111113333331111111111111111111111111111111115555115553333333352222221255555511111111dd2222222222212121ddd555111111111
55515111111111133333311111111111111111111111111111111155511155553333333335222225555555511111111dd22222222216ddd21d11511111111111
55511111111111333333311111111111111111111111111111111511111555555333333333555115555555111111111d22222122666d51111d55111551111111
5511199919993999393919991199191911991111199919191991111555999995553333333335551155555111111111151112221166d511221d55111151111111
5511090909090903090900911909090919011111090909090919111559900099555553333333355515551111111111152122222222d512221111211155111111
5111099909930995090910910909090909991111099109090909111109959099555555553333333511551111111111552222222222551222111122115ddd1111
1111090309390955099910910909090900091111091909090909111109905099555555555333333351511111111211552222222222111222211212215d111111
1111095309090999009119990991019919911111090901990909111100999991155555555533333351111111112211542222222222222111212222211d111111
11110555050500011011000100111001001111110101100101011111100000555555555555333333511111111222115422222222222222221111222111111111
11115555555511111111111111111111111111111111111111111111111111555115555555533333511111111222155411112211222222222222112111111111
11115555555111111111111111111111111111111111111111111111111111115511155555555533511111112222155422121122222222222222211112221111
11155555551111111111111111111111111111111111111111111111111111111555115555555533511111122222154422222222222222222222211222221111
11555555111111111111111111111111111111111111111111111111111111111115511555555555111111222222114422222222222222222222111222222111
15555555111111111111111111111111111111111111111111111111111111111111551155555555111112222222114422222222222222222222221122221111

__sfx__
01011e20232301943014430104300e4300b3200932008320073200632005310050100501004010030100301003010030100301002010020100201002010020100201002010020100201002010020100201002010
0101000033610306102e6102c6102b6102b6102b6102b6102b6102b6102b6102c6102d6102f61033610386103c610000000000000000000000000000000000000000000000000000000000000000000000000000
01011c2028630216311d6311a63117631146311262111621106210e6210d6210d6110c6110b6110b6110a61109611086110861107611076110661105611056110561104611046110461104611046110461104611
0101000c33600306102e6102c6102b6102b6102b6102b6102b6102b6102b6102c6102d6102f61033610386103c610000000000000000000000000000000000000000000000000000000000000000000000000000
01180000188301883018a3018a3018a2118a1118a3318a30188301883018a3018a3018a2118a1118a3318a30188301883318a3018a3018a2118a1118a3318a30188301883018a3018a3018a2118a1118a3318a33
011800002491024900249100000024910000002491000000249100000024910000002491018910249100000024910000002491000000249100000024910000002491000917249100000024910009172491000917
01180000249100c3032491000000249101891024910000002491000917249100000024910189102491000000249100000024b1024b10249100000024910000002491000917249100000024910009172491000917
010c00202351523515235150050000500005000050000500005000050000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00202351523515235150050000500005000050023515245102451500500005002451024515005000050000500005000050000500005000050000500005000000000000000000000000000000000000000000
010c00202351523515235150050000500005000050023515245102451500500005002451024515005000050026510265112651126515265152651526515265152651526515265152651526510265102651500000
05180000110000c00009000110000c00009000110000c00009000110000c00009000110000c0000900009000110000e00009000110000e00009000110000e00009000110000e00009000110000e0000900009000
05180000110000e0000a000110000e0000a000110000e0000a000110000e0000a000110000e0000a0000a000130000e0000a000130000e0000a000130000e000150000e0000a000150000e0000a0001500013000
011800001f1002110021100211002110021100211002110021100211002110021100221002210022100221001f10021100211002110021100211002110021100211002110021100211001f1001f1001f1001f100
05180000110000e0000a000110000e0000a000110000e0000a000110000e0000a000110000e0000a0000a000130000e0000a000130000e0000a000130000e0000e0000a000090000e0000a000090000e00013000
011800001f100211001f1002110021100211002110021100211002110021100211002210021100221002110024100261002610026100241002410024100241002410024100221002210021100211002110021100
011800001c1001d1001d1001d1001f1001f1001f1001f1001f1001f1001f1001f1001f1001d1001d1001d100211002210022100221001f1001f1001f1001f1002110021100211002110021100211002110021100
011018001120000400004000f40000400004001040000400004000e40000400004001140000400004000f40000400004001040000400004000e40000400004000040000000000000000000000000000000000000
191018000500005000050000700007000070000900009000090000a0000a0000a0000900009000090000700007000070000500005000050000600006000060000000000000000000000000000000000000000000
011018001d3001d300223002430024300283002430024300263002430024300253002630026300243002630026300243002230022300233002430024300203000000000000000000000000000000000000000000
191018000700007000070000a0000a0000a0000e0000e0000e0001300013000130000c0000c0000c0000900009000090000700007000070000600006000060000000000000000000000000000000000000000000
011018001f3001f300243002630026300293002630026300283002630026300273002830028300283002430025300263002730027300273002130022300233000000000000000000000000000000000000000000
011018002430024300223001d30022300263002430024300263002430024300253002630026300243002630026300243002230022300233002430024300203000000000000000000000000000000000000000000
011018001f3001f3002430026300263002930026300263002830026300263002730028300283002830028300283002630024300243002430024300243001f3000000000000000000000000000000000000000000
011018001f3001f300243002630026300293002630026300283002630026300273002830028300283002830028300293002b3002b3002b3002b3002b3002b3000000000000000000000000000000000000000000
091500000420004200042000420004200042000420004200072000720004200092000920004200072000620004200042000420004200042000420004200042000720007200072000920009200042000b20009200
011500001720017200172001720017200172001720017200192001820017200152001520015200132001520017200172001720017200172001720017200172001320013200132001520015200152001320015200
0115000017200172001720017200172001720017200172001920018200172001920019200192001a200192001a2001a2001a2001a2001a2001a2001a2001c2001d2001d2001d2001c2001c2001c2001a20019200
0115000017200172001720017200172001720017200172001920018200172001920019200192001a200192001a2001a2001a2001a2001a2001a2001a2001c2001d2001d2001d2001d2001d2001d2001d2001c200
09150000042000420004200042000420004200042000420007200072000420009200092000420007200092000b2000b2000b2000b2000b2000b2000b2000b2000920009200092000b2000b200092000720006200
01150000000000000000000000000000000000000000000013200132000000015200152000000013200152001a2001a2001a2001a2001a2001a2001a2001c2001d2001d2001d2001d2001d2001d2001d2001c200
011500000000000000000000000000000000000000000000132001320000000152001520000000132001220010200102001020010200000000000000000000001320013200132001520015200152001520015200
011500000000000000000000000000000000000000000000132001320000000152001520000000132001220010200102001020010200000000000000000000001720017200172001920019200192001920019200
011000001000015000180001800018000180001800018000100001500017000170001700017000170001700010000150001a0001a0001a0001a0001a0001a0001000015000170001700017000170001700017000
1910000021500215002150021500215002150021500215001f5001f5001f5001f5001f5001f5001f5001f5001d5001d5001d5001d5001d5001d5001d5001d5001a5001a5001a5001a5001a5001a5001a5001a500
01100000100001500018000180001800018000180001800010000150001700017000170001700017000170000e000100001300013000130001300013000130000e00010000150001500015000150001500015000
191000001d5001d5001d5001d5001d5001d5001d5001d5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001d5001d5001c5001c5001c5001c5001c5001c5001c5001c500
0110000015000180001d0001d0001d0001d0001d0001d00015000180001c0001c0001c0001c0001c0001c00015000180001d0001d0001d0001d0001d0001d00015000180001f0001f0001f0001f0001f0001f000
191000001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001d5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f5001f500
01100000100001500018000180001a0001a0001a0001a000100001500018000180001c0001c0001c0001c00010000150001800018000170001700017000170001000015000180001800013000130000e0000e000
191000001c5001c5001c5001c5001c5001c5001d5001d5001c5001c5001c5001c5001c5001c5001d5001d5001c5001c5001c5001c5001c5001c5001d5001d5001a5001a5001a5001a5001a5001a5001a5001a500
05140000053000530005300113000530005300153001330005300053000530011300053000530015300163000530005300053001130005300053001530016300183000c3000c300183000c3000c3001630015300
011400000c100001000c1000c100000000c100266001a6000c100000000c1000c100000000c100266001a6000c1000c1000c1000c100000000c100266001a6000c100266001a6000c1000c1000c100266001a600
0514000005300053000530011300053000530015300133000530005300053001130005300053000e300103000030000300003000c30000300003000c3000e3000430004300043001030004300043000e30010300
011400001d5001d5001c5001d5001d5001c5001a5001c5001d500000001d5001f5001f5001f5001f500180001d5001d5001c5001d5001d5001c500185001a5001c5001c5001c5001c5001c5001a5001850018500
011400001d5001d5001c5001d5001d5001c5001a5001c5001d500000001d5001f5001f5001f5001f500180001d5001d5001c5001d5001d5001f50022500215001f5001f5001f5001f5001f5001d5001f5001f500
0514000005300053000530011300113001130015300133000530005300053001130011300113000e300103000030000300003000c3000c3000c3000c3000e3000430004300043001030004300043000e30010300
011400000c100001000c1000c100000000c100266001a6000c100000000c1000c100000000c100266001a6000c1000c1000c1000c100000000c100266001a6000c100266001a6000c1000c1000c100266001a600
011400001d5001d5001c5001d5001d5001c5001a5001c5001d500000001d5001f5001f5001f5001f500180001d5001d5001d5001f5001f5001f5001f500180001d5001d5001d50022500215001f5001f5001f500
0911000011100151001610017100151001710015100151001110015100161001710018100131001510015100101001510016100171000e1001510016100171000c10015100161001510013100151001610016100
a5050000080550a05512055120551405518055200552c0553005501055080550f0551705522055270552e05533055350550205504055070550d05512055160551a0551e0552005527055300553a0553d0553f055
010600000067000000006700060000670000000067000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000647003170016700000001670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104000010075100750000500005217751807500005267752307525075115751557512575000050a5750757500005000050000500005000050000500005000050000500005000050000500005000050000500005
0107000001070010700f770000700277000070000700007000070050000500005000080000a0000b0000b000090000d0000000000000000000000000000000000000000000000000000000000000000000000000
110b00002157218572000020977212572207721557205572006720977216702006721477210772006720470203772037020377200672000020067100001000020000200002000020000200002000020000200002
970100002f2701a270000000a1702a270211701617007270006700000000670000000067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400000647103171016710000101671000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001
050200002577128771007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701
9d0400000c56600706006060070604706007060070600706007060070601706007060270600706007060070600706017060070600706007060070600706007060070600706007060070600706007060070600706
010500000b753000030475300003027530050300523145531a5531b553165530955308553335432f5431f53100001000030000300003000030000300003000030000300003000030000300003000030000300003
0101000011070160700f070100701307013000120000b00006000050000500005000080000a0000b0000b000090000d0000000000000000000000000000000000000000000000000000000000000000000000000
000800000044000000016400d70001000030400165001640016400062001740000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700000d05512045037550a745017550e54523045131051f0350d53500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
090400000c13600116021060010600106001060010600106001060010600106001060010600106001060010600106001060010600106001060010600106001060010600106001060010600106001060010600106
__music__
01 04054344
00 04064344
01 04050744
00 04060744
00 04050844
00 04060744
00 48050944
00 04060944
00 04050744
02 044a4b44
03 09044344
00 0b424344
01 0a0c4344
00 0d0e4344
00 0a0c4344
02 0b0f4344
01 10111244
00 10131444
00 10111544
00 10131644
00 10111244
00 10131444
00 10111544
02 10131744
01 18194344
00 181a4344
00 18194344
00 181b4344
00 1c1d4344
00 1c1d4344
00 181e4344
02 181f4344
01 20214344
00 22234344
00 20214344
00 24254344
00 20214344
00 22234344
00 20214344
02 26274344
01 28294344
00 2a294344
00 28294344
00 2a294344
00 28292b44
00 2a292c44
00 28292b44
02 2d2e2f44
01 30313244
00 33343244
00 30313244
00 33353644
00 30313244
00 33343244
00 30313644
02 37354e44
01 38394a44
00 38393a44
00 38493a44
02 3b493a44
01 3c3d4344
00 3e3d4344
00 3c3d4344
02 3e3f4344

