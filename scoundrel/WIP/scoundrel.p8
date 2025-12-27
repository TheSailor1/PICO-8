pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	shake=0
	develop=0
	devspeed=0
	
	_upd=upd_menu
	_drw=drw_menu
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
	for r in all(routines) do
		if costatus(r)=="dead" then
			del(routines,r)
		else
			coresume(r)
		end
	end
	
	
end

--★
function deckcheck()
	for i=1,#deck do
		? "\#0\f2"..deck[i].rank.." "..deck[i].suit,60,2+(i-1)*6
	end

		for i=1,#shfdeck do
		? "\#0"..shfdeck[i].rank.." "..shfdeck[i].suit,100,2+(i-1)*6
	end
	for i=1,#shfdeck2 do
		? "\#0\f9"..shfdeck2[i].rank.." "..shfdeck2[i].suit,80,2+(i-1)*6
	end
end

function drw_chkdeck(tbl,x,y,col)
	if #tbl>0 then
		for c=1,#tbl do
			? "\#0"..tbl[c].suit.."."..tbl[c].rank,x,y+((c-1)*6),col
		end
	else
		? "\#0[-x-]",x,y,col
	end
end

function ini_game()
	deck={}
	deckcopy={}
	shfdeck={}
	shfdeckcopy={}
	hand={}
	handcopy={}
	suits={"hrt","dmd","clb","spd"}
	discards={}
	
	newdeck=true
	dwpn=false
	pullcard=true
	handpos={
		{x=10,y=8},
		{x=52,y=8},
		{x=10,y=46},
		{x=52,y=46},
		{x=84,y=40}
	}
	handpos2={
		{x=10,y=8},
		{x=52,y=8},
		{x=10,y=46},
		{x=52,y=46},
		{x=84,y=40}
	}
	maxhand=4
	hasrun=false
	hp=20
	maxhp=20
	dmg=0
	hasweapon=nil
	room=1
	roomcol={1,1,1,2,2,2,3,3,3,5,5,5,4,4,11,11,8,8,9,9,13,13,12,12,10,10}
	cursel=1
	prevcur=nil
	waitfr=0
	
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
	
	--test deck
--	shfdeckcopy={
--		{rank=2,suit="hrt",remcard=false},
--		{rank=3,suit="hrt",remcard=false},
--		{rank=4,suit="hrt",remcard=false},
--		{rank=14,suit="spd",remcard=false},
--		{rank=2,suit="spd",remcard=false},
--	}
	
	dealcards(4)
	
	
	--ani
	routines={}
	hitx,hity,hitf,hitp=0,0,0,0
	async(deckani)
	shake=0
	shakex=0
	shakey=0
	
	bgx,bgy=0,20
	
	_upd=upd_game
	_drw=drw_game
	
end
-->8
--draws
function drw_menu()
	fadepal((100-develop)/100)
	
	?castle,0,0
	? ":THESAILOR_DEV:",2,2,9
	? "new run ❎",81,116+sin(time()/4)*2,0
	? "new run ❎",79,116+sin(time()/4)*2,0
	? "new run ❎",80,116+sin(time()/4)*2,0
	? "new run ❎",80,114+sin(time()/4)*2,0
	? "new run ❎",81,114+sin(time()/4)*2,0
	? "new run ❎",79,114+sin(time()/4)*2,0
	? "new run ❎",80,115+sin(time()/4)*2,10
end

function drw_game()
	fadepal((100-develop)/100)
	
	cls()
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
	
	--ui
	drw_hline(0,82,5)
	drw_vline(60,82,5)
	
	if not newdeck then
		drw_deck(10,88)
	end
	drw_hand()
	
	if dwpn then
		drw_weapon(70,90,83,88)
	end
	
	rect(
		handpos[5].x+10,
		handpos[5].y+13,
		handpos[5].x+10+22,
		handpos[5].y+13+18,
		1)
		
	if not hasrun and #hand==4 then
		? "flee",handpos[5].x+14,handpos[5].y+16,12
		? "room",handpos[5].x+14,handpos[5].y+24,12
	end
	
	
	
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
		sspr(119,0,6,5,newx+1,newy)
		palt()
		newx+=6
	end
	
	
	if not newdeck then
	palt(0,false)
	drw_cursor()
	end
	
	if #routines==0 and
					cursel!=5 then
		drw_icos(handpos[cursel].x,
											handpos[cursel].y,
											hand[cursel])
	end
	
	palt()
	--frame
	for i=0,2 do
		rect(0+i,0+i,127-i,127-i,6)
	end
	
	--★ testing
	--drw_chkdeck(deck,20,2,1)
	--drw_chkdeck(shfdeck,40,2,2)
	--drw_chkdeck(shfdeckcopy,70,2,9)
	drw_chkdeck(handcopy,100,2,3)
	?
end

function drw_deck(_x,_y)
	drw_bcard(_x,_y)
	? "_..",_x+36,(_y+22)-(room*2),roomcol[room]
	? #shfdeckcopy,_x+36,(_y+28)-(room*2),roomcol[room]
	? "_..",_x+36,(_y+30)-(room*2),roomcol[room]
--	? "room:"..room,_x+8,_y+26,7
end

function drw_hand()
	if pullcard==false and
				#discards==0 then
		for i=1,#hand do
			if hand[i].remcard==false then
			? i,90,90+(i*6),8
			drw_fcard(
				handpos[i].x,
				handpos[i].y,
				hand[i].rank,
				hand[i].suit
				)
			end
		end
	end
end

function drw_cursor()
	local movy
	if #routines==0 then
		movy=sin(time()/1.2)*0.2
	else
		movy=0
	end
	
	palt(7,true)
	sspr(
		24,27,
		21,22
		,handpos2[cursel].x+22,
		handpos2[cursel].y+20+movy)
	palt()
end

function drw_weapon(_x1,_y1,_x2,_y2)
	if hasweapon!=nil then
		drw_fcard(_x1,_y1,hasweapon.lmt,hasweapon.lmtsuit)
		line(81,88,81,118,0)
		pset(82,119,0)
		pset(83,120,0)
		line(84,121,101,121,0)
		drw_fcard(_x2,_y2,hasweapon.rank,hasweapon.suit)
	end
end

function drw_gameover()
	cls(5)
	? "game over!",32,32,9
	? "rooms cleared: "..room,32,40,7
	
	? "new run - ❎",32,100,0
end
-->8
--updates
function upd_menu()
	fadeeff(.2)
	
	if btnp(❎) then
		resetdev()
		ini_game()
	end
end

function upd_game()
	fadeeff(.4)
	
	if develop==100 and #routines==0 then
		
		if btnp(❎) then
			if cursel==5 and #hand==4 then
				--flee room
				if (hasrun==false) flee()
				
			elseif hand[cursel].suit=="spd" or
				hand[cursel].suit=="clb" then
				--punch with fists
				oldcursel=cursel
				atkpunch()
			elseif hand[cursel].suit=="hrt" then
				--drink potion
				usepotion()
			elseif hand[cursel].suit=="dmd" then
				--take weapon
				pckweapon()
			end
			
			--refill hand
			if #hand==1 then
				pullcard=true
				room+=1
				async(carddeal)
				if #shfdeckcopy<3 then
					dealcards(#shfdeckcopy)
				else
					dealcards(#shfdeck)
				end
			end
		end
	
		if btnp(🅾️) then
			if cursel!=5 then
				--if hand[cursel].suit=="spd" or
						--hand[cursel].suit=="clb" then
							--oldcursel=cursel
							
							--if (hasweapon) and
									--	hand[cursel].rank<=hasweapon.lmt then
									--	atkstab()
							--end
				--end
			end
			
			--refill hand
--			if #shfdeckcopy<3 then
--				dealcards(#shfdeckcopy)
--			else
--				dealcards(#shfdeckcopy)
--			end
		end
	
		
		
		upd_cursor()
	end
end

function upd_cursor()
	local current=cursel
	

	if (btnp(➡️)) cursel+=1
	if (btnp(⬅️)) cursel-=1
	
	local n
	if (#hand<4) n=#hand
	if (#hand==4) n=5
	cursel=mid(1,cursel,n)
	
	if current!=cursel then
		sfx(63)
	end
	
end

function upd_gameover()
	if btnp(❎) then
		sfx(57)
		_init()
	end
	
	if btnp(🅾️) then
		sfx(57)
		
	end
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

function dealcards(v,ran)
	totcards=v
	async(carddeal)
	for i=1,v do
		add(hand,shfdeckcopy[1])
		deli(shfdeckcopy,1)
	end
	
	if #handcopy==0 then
		copy(hand,handcopy)
	end
	
	if ran then
		hasrun=true
	else
		hasrun=false
	end
end

function discard(c)
	hand[c].remcard=true
	
	--add(hand[c],{})
	--deli(handpos2,c)
	
	deli(hand,c)
	--handcopy={}
	--copy(hand,handcopy)
end

function newroom()
	if #hand==1 then
		dealcards(3,false)
	end
end

function flee()
	sfx(58)
	for i=#hand,1,-1 do
			add(shfdeckcopy,hand[i])
			deli(hand,i)
	end
	
	hasrun=true
	cursel=1
	async(carddeal)
	newhand=true
	
	dealcards(4,true)
	
end

function usepotion()
	sfx(59)
	oldcursel=cursel
	heal=hand[oldcursel].rank
	async(gethp)
	if (hp>maxhp) hp=maxhp
	
	discard(oldcursel)
	mk_discard()
	--cursel=1
end

function pckweapon()
	sfx(62)
	hasweapon=hand[cursel]
	hasweapon.x=handpos[cursel].x
	hasweapon.y=handpos[cursel].y
	hasweapon.lmt=14
	hasweapon.lmtsuit="clb"
	dwpn=false
	async(cardslide)
	discard(cursel)
end

function atkpunch()
	sfx(61)
	shake=3
	bleed=hand[cursel].rank
	mk_discard()
	oldcursel=cursel
	async(loshp)
	async(redflash)
	async(dmgflash)
	for i=1,hand[cursel].rank do
		del(hearts)
	end
	discard(cursel)
	cursel=1
end

function atkstab()
	if hasweapon then
		--weapon lmt
		if hasweapon.lmt>=hand[cursel].rank then
			--calc dmg
			if hand[cursel].rank>hasweapon.rank then
				dmg=hand[cursel].rank-hasweapon.rank
			else
				dmg=0
			end
			sfx(55)
			shake=3
			if (dmg<0) dmg*=-1
			bleed=dmg
			hasweapon.lmt=hand[cursel].rank
			async(redflash)
			async(loshp)
			async(dmgflash)
			async(monsterlmt)
			discard(cursel)
			for i=1,dmg do
				del(hearts)
			end
		end
	end
	cursel=1
end
-->8
--ui
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
			sspr(72,0,23,27,_x+9,_y+4)
		elseif _rank==13 then
			sspr(24,0,23,27,_x+9,_y+4)
		elseif _rank==12 then
			sspr(95,0,23,27,_x+9,_y+4)
		elseif _rank==11 then
			sspr(0,29,23,27,_x+9,_y+4)
		elseif _rank==10 or 
									_rank==9 or
									_rank==8 or 
									_rank==7 or
									_rank==6 then
			sspr(0,0,23,27,_x+9,_y+4)
		elseif _rank==5 or
									_rank==4 or
									_rank==3 or
									_rank==2 then
			sspr(48,0,23,27,_x+9,_y+4 )
		end
	end
	if _suit=="dmd" then
		if _rank==10 or
					_rank==9 or
					_rank==8 then
			sspr(84,29,23,27,_x+9,_y+4)
		elseif _rank==7 or
									_rank==6 or
									_rank==5 or
									_rank==4 then
			sspr(65,29,18,28,_x+11,_y+2)
		elseif _rank==3 or
									_rank==2 then
			sspr(45,29,18,28,_x+11,_y+2)
		end
	end
	if _suit=="hrt" then
		if _rank>5 then
			sspr(22,58,20,30,_x+8,_y+1)
		else
			sspr(0,58,20,30,_x+8,_y+1)
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
				sspr(119,5,6,7,_x-3,_y+13)
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
		sspr(119,12,6,7,_x-3,_y+22)
		pal()
	elseif _tbl.suit=="hrt" then
		rectfill(
			_x,_y+22,
			_x+16,_y+28,2
		)
		line(_x,_y+29,_x+16,_y+29,1)
		? "use",_x+5,_y+23,14
		
		palt(7,true)
		pal(9,2)
		sspr(119,12,6,7,_x-3,_y+22)
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
		sspr(119,12,6,7,_x-3,_y+22)
		pal()
	end
end

function async(_func)
	add(routines,cocreate(_func))
end

function wait(f)
	local f=f or 90
	for i=1,f do
		yield()
	end
end

function dmgflash()
	local movx=0
	local w=12
	if (dmg<10) w=8
	for i=1,50 do
		movx+=1.7
		--dmg sign
		local c1,c2=8,7
		if (i>5) c1,c2=2,8
		rectfill(
			handpos[oldcursel].x+22+movx,
			handpos[oldcursel].y,
			handpos[oldcursel].x+22+w+movx,
			handpos[oldcursel].y+6,
			c1)
			
		print(
			"-"..dmg,
			handpos[oldcursel].x+23+movx,
			handpos[oldcursel].y+1,
			c2)
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
	async(carddeal)
	wait(38)
	newdeck=false
end

function cardslide()
local fr=50
local _x,_y=-20,128
local cnt
	for i=1,fr do
		hasweapon.x=lerp(hasweapon.x,83,easeinovershoot(i/30))
		hasweapon.y=lerp(hasweapon.y,88,easeinovershoot(i/30))
		drw_hand()
		palt(0,false)
		drw_cursor()
		drw_deck(10,88)
		if (i>30) _x,_y=70,90
		drw_weapon(_x,_y,hasweapon.x,hasweapon.y)
		if invlerp(hasweapon.y,88,easeinovershoot(i/30))<-32 then
			dwpn=true
		end
		
		yield()
	end
	cursel=1
end

function carddeal()
local fr=40
local _x1,_x2,_x3,_x4=10,10,10,10
local _y1,_y2,_y3,_y4=88,88,88,88
local cnt
	for i=1,fr do
		drw_deck(10,88)
	
	if totcards==4 then
		_x4=lerp(_x4,handpos[4].x,easeinovershoot(i/30))
		_y4=lerp(_y4,handpos[4].y,easeinovershoot(i/30))
		drw_bcard(_x4,_y4)

		_x3=lerp(_x3,handpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,handpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)

		_x2=lerp(_x2,handpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,handpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)

		_x1=lerp(_x1,handpos[1].x,easeinovershoot(i/20))
		_y1=lerp(_y1,handpos[1].y,easeinovershoot(i/20))
		drw_bcard(_x1,_y1)
	end
	
		if totcards==3 then
			drw_fcard(handpos[1].x,handpos[1].y,hand[1].rank,hand[1].suit)
		
		
		_x4=lerp(_x4,handpos[4].x,easeinovershoot(i/30))
		_y4=lerp(_y4,handpos[4].y,easeinovershoot(i/30))
		drw_bcard(_x4,_y4)

		_x3=lerp(_x3,handpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,handpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)

		_x2=lerp(_x2,handpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,handpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
	end
	
		if totcards==2 then
			drw_fcard(handpos[1].x,handpos[1].y,hand[1].rank,hand[1].suit)
		
		_x3=lerp(_x3,handpos[3].x,easeinovershoot(i/30))
		_y3=lerp(_y3,handpos[3].y,easeinovershoot(i/30))
		drw_bcard(_x3,_y3)

		_x2=lerp(_x2,handpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,handpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
		end
	
		if totcards==1 then
			drw_fcard(handpos[1].x,handpos[1].y,hand[1].rank,hand[1].suit)
		
		_x2=lerp(_x2,handpos[2].x,easeinovershoot(i/20))
		_y2=lerp(_y2,handpos[2].y,easeinovershoot(i/20))
		drw_bcard(_x2,_y2)
		end
		yield()
	end
	
	
	pullcard=false
end

function monsterlmt()
	local x,y,r
	x=handpos[oldcursel].x
	y=handpos[oldcursel].y
	r=5
	for i=1,30 do
		r-=0.14
		x=lerp(x,70,easeinovershoot(i/26))
		y=lerp(y,88,easeinovershoot(i/26))
		circfill(x,y,r+1,9)
		circfill(x-6,y-6,r+0,9)
		circfill(x-8,y-8,r,9)
		yield()
	end
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

function discardani()
	local randx=rnd({-90,-60,-30,0,30,60,90})
	for i=1,40 do
		discards.x=lerp(
			discards.x,randx,
			easeinovershoot(i/30))
		discards.y=lerp(
			discards.y,-32,
			easeinovershoot(i/30))
			
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

function mk_discard()
	discards.rank=hand[cursel].rank
	discards.suit=hand[cursel].suit
	discards.x=handpos[cursel].x
	discards.y=handpos[cursel].y
	async(discardani)
end

function redflash()
	for i=1,3 do
		cls(8)
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
	if hp==0 then
		sfx(54)
		wait(10)
		_upd=upd_gameover
		_drw=drw_gameover
	end
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
--animation
function lerp(a,b,t)
	return a+(b-a)*t
end

function easeinovershoot(t)
	return 1.7*t*t*t-.7*t*t
end

function easeoutovershoot(t)
	t-=1
	return 1+1.7*t*t*t+.7*t*t
end

function easeoutbounce(t)
    local n1=7.5625
    local d1=2.75
   
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
castle="⁶-b⁶x8⁶y8²1ᶜ2⁶.も89」■CCc⁶.チテおおゆゆゆ~⁶.かエん♥♥⧗39⁶.エo'♥んんリャ⁶.ン◜◝◝◝○??⁶.○○○ᶠ0<かト⁶.◝◝◝◝ユろᵇ゜⁶.リs9「らルヲル⁶.ョ<ら◝◝◝◝◝²1⁶.\0◜○○}。\r⁵⁸⁶-#ᶜ3⁶.\0\0\0██²²\0⁸⁶-#ᶜ4⁶.\0\0\0\0\0`px⁸⁶-#ᶜb⁶.\0\0█\0²\0\0\0²1ᶜ2⁶.ヲ◝◝◝トチらら⁸⁶-#ᶜ3⁶.\0\0\0\0\0  \0⁸⁶-#ᶜ4⁶.\0\0\0\0\0³゜゜⁸⁶-#ᶜb⁶.\0\0\0\0 \0\0\0²2 ²2ᶜ9⁶.\0\0pヲもヲpユ⁸⁶-#ᶜf⁶.\0\0█\0@\0█\0²2ᶜ9⁶.\0\0\0¹³²、¥⁸⁶-#ᶜf⁶.\0\0゜~ュョネハ²2⁶.\0\0\0\0\0¹³³ \n²2ᶜ1⁶.おえよロ◝◝ワメ⁸⁶-#ᶜ3⁶.\0\0\0¹\0\0⁸□²2ᶜ1⁶.⬇️♥かフんoョヨ⁶.を♥³³?ョ▒¹⁶.⁵⁷⁷³²⁶⁷●⁶. 0、アG#3•²2⁶.0「⁘⁙「「「「⁸⁶-#ᶜ4⁶.\0\0\0⁸&dナノ²2ᶜ1⁶.█ら@pぬユヲ|⁸⁶-#ᶜ4⁶.\0\0\0\0\0\0\0³²2ᶜ1⁶.\0\0ニ<ᶠ◝▒\0²2⁶.\0\0\0\0\0¹¹\0⁸⁶-#ᶜ4⁶.\0\0\0\0\0█らナ²2ᶜ1⁶.ををアヲヲナらら⁸⁶-#ᶜ4⁶.893⁷⁶゜?゜⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0 ²1ᶜ4⁶.ウウヒユユュ◜ュ⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0\0²²2ᶜ4⁶.\0\0りネ◝◝◝◝²2⁶.\0\0「ヨャ◝◝◝⁸⁶-#ᶜ9⁶.ナナナ\0\0\0\0\0²4⁶.'g○♥\0\0\0\0⁸⁶-#ᶜf⁶.ス▤█\0\0\0\0\0²4ᶜ2⁶.ヲヲユユユヲ\0\0⁸⁶-#ᶜ9⁶.\0\0	ᶠᵉ\0\0\0⁸⁶-#ᶜf⁶.⁷⁷⁶\0\0\0\0\0²4ᶜ2⁶.◝◝◝○??><\n²1ᶜ3⁶.2\0■⁙CBFウᶜ2⁶.ᵉᶜᶜ⁸███@⁶.◜◝◜ュ\0▒ヲユ⁶.ss3■█◝◝◝²1⁶.ユヲヘA¹¹\0\0⁸⁶-#ᶜ4⁶.\0\0▮ぬヲヲュ|²1ᶜ2⁶.⁷⁷▮\0@ \0\0⁸⁶-#ᶜ4⁶.ナ ⁷⬇️⬇️りユヲ²1ᶜ2⁶.ヲユナら█\0\0\0⁸⁶-#ᶜ4⁶.¹⁸゛?○◝ョ}²1ᶜ2⁶.○○◝◝○?8「⁸⁶-#ᶜ4⁶.██\0\0█ら\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0██⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0²²2ᶜ4⁶.ユリ◝◝◝◝◝◜⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0¹²1ᶜ4⁶.゜⁷ᶠ⁷⁷⁵⁵⁵⁸⁶-#ᶜ5⁶.\0\0@\0██\0\0⁸⁶-#ᶜ9⁶. \0▮「「⁸⁸⁸⁸⁶-#ᶜd⁶.\0\0\0@@@ら@⁸⁶-#ᶜf⁶.\0\0\0\0\0\0\0█²1ᶜ4⁶.ュユュュヲスオオ⁸⁶-#ᶜ5⁶.\0\0¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.²\0\0\0⁴\0⁸⁸⁸⁶-#ᶜd⁶.\0\0\0¹¹¹¹¹²4ᶜ5⁶.\0\0\0\0\0\0█ら²4ᶜ1⁶.\0\0\0\0\0\0qク⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0 ²4  ᶜ2⁶.80 \0\0\0\0\0\n²1ᶜ3⁶.ウ🅾️ᶜ²&fらら⁸⁶-#ᶜ5⁶.\0\0¹¹¹\0⁶‖²1ᶜ2⁶.@\0\0\0\0\0\0\0⁸⁶-#ᶜ4⁶.⁴\0⁸⁸\0⁸、ᶜ⁸⁶-#ᶜ5⁶.\0\0\0\0█ららら²1ᶜ2⁶.ヲ◜゛\0\0\0\0\0⁸⁶-#ᶜ3⁶.\0\0\0フッュ|⁘⁸⁶-#ᶜ5⁶.\0\0\0\0¹\0█\n²1ᶜ2⁶.○⁴\0\0\0\0\0\0⁸⁶-#ᶜ3⁶.\0\0웃♪⁴²\0\0²1⁶.\0ᶠᶠ³¹\0\0\0⁸⁶-#ᶜ4⁶.>0\0\0\0ナ█☉⁸⁶-#ᶜ9⁶.\0\0\0\0\0\0`p²1ᶜ4⁶.~゜🅾️\0\0レ#⁙⁸⁶-#ᶜ9⁶.\0\0\0\0\0²オナ²1ᶜ4⁶.NG⁷⁴\0⁷⁷³⁸⁶-#ᶜ5⁶.\0\0\0\0⁸▮▮ ⁸⁶-#ᶜ9⁶.\0\0@\0\0\0\0⁴⁸⁶-#ᶜd⁶.\0▮「⁸▮`@\0²1ᶜ4⁶.「\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0²¹¹\0\0\0⁸⁶-#ᶜd⁶.³¹\0\0\0\0\0\0²1ᶜ4⁶.◜>゛ᵉ²\0\0\0⁸⁶-#ᶜ5⁶.¹¹¹\0\0\0\0¹⁸⁶-#ᶜ9⁶.\0らナぬもゆ>v²1ᶜ4⁶.¹¹\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0 0\0▮\0⁸⁶-#ᶜ9⁶.⁴░⁵¹³⁷⁷²⁸⁶-#ᶜa⁶.\0\0\0█\0\0\0\0⁸⁶-#ᶜd⁶.ら@ら@らpら@⁸⁶-#ᶜf⁶.\0\0\0\0\0█\0\0²1ᶜ4⁶.ららららナナ@\0⁸⁶-#ᶜ5⁶.\0\0\0\0⁴\0⁴\0⁸⁶-#ᶜ9⁶.▮▮▮\0\0▮0 ⁸⁶-#ᶜd⁶.¹¹¹³³⁷¹¹²1ᶜ4⁶.?゜゛¥ᵉ⁶⁶⁷⁸⁶-#ᶜ5⁶.@@@\0\0\0\0@⁸⁶-#ᶜ9⁶.\0  $0800²1ᶜ5⁶.\0\0 @@\0\0\0⁸⁶-#ᶜ9⁶.ᶜ\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.`@\0\0\0\0\0\0²1ᶜ4⁶.ンヨユユナナ\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0⁸⁴⁴²⁸⁶-#ᶜ9⁶.\0\0¹\0▮▮ユユ⁸⁶-#ᶜd⁶.\0⁴ᶜ⁸⁴³¹\0²4ᶜ9⁶.\0\0\0\0\0█らナ²4ᶜ3⁶.\0\0\0\0█らユヲ⁸⁶-#ᶜ9⁶.\0\0cめU?ᶠ⁷\n²1ᶜ3⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.⁙#C³³」98²1ᶜ4⁶.⁸⁸\0\0   \0⁸⁶-#ᶜ5⁶.ナナナユPPPユ²1⁶.⁶²\0\0@ナユヲ⁶.「、\0⁸せけのス²1ᶜ3⁶.\0⁶⁷\0▮p █⁸⁶-#ᶜ5⁶.\0\0\0\0¹\0▮⁸⁸⁶-#ᶜ9⁶.ュ「\0\0\0\0\0\0²1ᶜ3⁶.\0\0\0\0⁷、、y⁸⁶-#ᶜ4⁶.³▮█\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0⁶⁸⁶-#ᶜ9⁶.ユナ\0゜8` \0²1ᶜ4⁶.³¹¹\0\0\0\0\0⁸⁶-#ᶜ9⁶.⁴⁶ᵉ゜??>>²1ᶜ5⁶.███@\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0█████⁸⁶-#ᶜd⁶.\0\0\0\0⁵⁴\0\0²1ᶜ5⁶.\0\0\0\0\0█@ ⁸⁶-#ᶜ9⁶.ワワフO\r。\r³²1ᶜ5⁶.(0▮「⁶²¹³⁸⁶-#ᶜ9⁶.\0\0   \0\0\0⁸⁶-#ᶜa⁶.\0\0\0\0\0\0 \0⁸⁶-#ᶜd⁶.@DB\0\0@PP²1ᶜ4⁶.█\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\n⁶⁵ᶜ0きDd⁸⁶-#ᶜ9⁶.\0██\0\0\0²\0⁸⁶-#ᶜd⁶.¹■ \0\0¹¹¹⁸⁶-#ᶜf⁶.\0\0²²²\0\0\0²1ᶜ4⁶.³\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.███\0\0\0¹²⁸⁶-#ᶜ9⁶.twsセスチスナ²1ᶜ5⁶.\0\0\0¹\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0P▮▮\0²1ᶜ4⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ9⁶.ユユヲュ◜◜◜>²3ᶜ4⁶.|ュュ>◀き\n⁙⁸⁶-#ᶜ9⁶.⬇️³³りホ_ul²3ᶜ5⁶.\0らナユ☉▤ュュ⁸⁶-#ᶜ9⁶.³³¹¹\0\0\0\0\n²1ᶜ5⁶. ▮`881#ᵉ²1ᶜ4⁶. p000▮▮▮⁸⁶-#ᶜ5⁶.ス☉っっっヘヘナ²1ᶜ4⁶.\0\0\0\0\0\0\0ら⁸⁶-#ᶜ5⁶.ヲュュュュュ<ᵉ²1ᶜ4⁶.▮ら`⁸<⁶³\0⁸⁶-#ᶜ5⁶.\r。。5らっユン²1ᶜ3⁶.らスまCり█\0\0⁸⁶-#ᶜ4⁶.\0¹\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.$ F😐&sン}²1ᶜ3⁶.yャャリ♥⁶⁶`⁸⁶-#ᶜ5⁶.⁶⁴\0\0pヨホ◆²1ᶜ3⁶.\0⁴。=}zH@⁸⁶-#ᶜ5⁶.███🐱🐱⁵&.⁸⁶-#ᶜ9⁶.|x`@\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0███²1ᶜ5⁶.\0¹²⁵\0\0¹²⁸⁶-#ᶜ9⁶.█████\0\0\0⁸⁶-#ᶜd⁶.¹²¹²¹\0\0\0²1ᶜ5⁶.\0█@`▮\0\0\0⁸⁶-#ᶜ9⁶.³⁷⁷³¹\0\0\0⁸⁶-#ᶜd⁶.█@ ▮\0@ 0²1ᶜ5⁶.⁙▮0⁘、‖‖5⁸⁶-#ᶜ9⁶.\0\0⁸ ²²²²⁸⁶-#ᶜd⁶.@LBB@@@█⁸⁶-#ᶜf⁶. \0\0\0\0⁸\0\0²1ᶜ5⁶.ノ😐⁶⁘、TTV⁸⁶-#ᶜ9⁶.²\0⁸\0 (  ⁸⁶-#ᶜa⁶.\0\0\0²\0\0\0\0⁸⁶-#ᶜd⁶.¹¹¹¹¹¹¹\0²1ᶜ5⁶.\0¹¹³⁴\0\0\0⁸⁶-#ᶜ9⁶.ナユユナ@\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0¹²⁶²1ᶜ5⁶.█らきオ█\0@ ⁸⁶-#ᶜd⁶.@ @ @███²3ᶜ4⁶.ら█ ら\0\0\0\0⁸⁶-#ᶜ9⁶.?○ト?◝○゜ᶠ²3ᶜ1⁶.\0\0@█████⁸⁶-#ᶜ4⁶.\r⁴\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0⁸⁸⁶-#ᶜ9⁶.r{?ᶠ¹\0\0\0²3ᶜ1⁶.\0\0\0\0⁸▮▮▮⁸⁶-#ᶜ5⁶.██ららユム	を\n²1⁶.><yリネフんれ²1ᶜ4⁶.\0\0\0▮\0\0\0█⁸⁶-#ᶜ5⁶.ユpphx」み}²1ᶜ4⁶.`0「⁸ᶠ⁷³¹⁸⁶-#ᶜ5⁶.★\n⁴⁶ナユ\0²²1⁶.p\0◜゜かフヲユ⁶.x`◝ヲニ♥ᵉn²1ᶜ3⁶.ら░\0き \0\0\0⁸⁶-#ᶜ5⁶.゜Zゆ゜゛¹¹\0²1ᶜ3⁶.\0²\n¥:h` ⁸⁶-#ᶜ5⁶.fdp`@\0█\0⁸⁶-#ᶜd⁶.██████\0\0²1ᶜ5⁶.²²²²⁶⁷³⁷⁸⁶-#ᶜd⁶.¹\0¹\0¹\0\0\0²1⁶.(  ▮⁸\0\0\0²1ᶜ5⁶.⁘「⁸\0`0「ᶜ⁸⁶-#ᶜd⁶.ら@ ▮⁸ᶜ⁶@²1ᶜ5⁶.⁘ᶜ⁸\0³⁶ᶜ「⁸⁶-#ᶜd⁶.¹¹²⁴⁸「0¹²1⁶.\n²²⁴⁸\0\0\0²1ᶜ5⁶.    0pナp⁸⁶-#ᶜd⁶.ら█ら█ら█\0\0²1ᶜ3⁶.ユユヘlモヤエᵉ⁸⁶-#ᶜ5⁶.\0\0\0█\0\0 ナ⁸⁶-#ᶜ9⁶.ᶠᶠ⁷³¹\0\0\0²1ᶜ3⁶.'\0…まめ::¥⁸⁶-#ᶜ5⁶.「?/³\0\0@ ²1ᶜ3⁶.ᶠᶠᶠ⁷³³³\0⁸⁶-#ᶜ5⁶.ナナナ` \0\0³\n²1ᶜ4⁶.\0\0█\0\0 `ぬ⁸⁶-#ᶜ5⁶.▒\0\0\0\0\0█\0²1ᶜ4⁶.ららDD⁶³¹¹⁸⁶-#ᶜ5⁶.=?む:9😐をヒ²1ᶜ4⁶.\0\0\0\0\0ナぬ\0⁸⁶-#ᶜ5⁶.¹\0\0\0=゜ᶠ⁷²1ᶜ4⁶.\0\0\0\0\0³⁷゛⁸⁶-#ᶜ5⁶.ナら█\0\0\0\0\0²1⁶.vdd⁴D⁴▮\0  ⁶.²\0\0\0\0\0\0\0ᶜd⁶.█\0@ ▮▮\0\0²1ᶜ5⁶.⁴\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0@\0\0\0□\0\0⁸⁶-#ᶜd⁶.¹¹\0@@\0\0\0²1ᶜ5⁶.▮\0\0\0\0\0\0\0⁸⁶-#ᶜ9⁶.\0\0\0¹¹\0\0\0⁸⁶-#ᶜd⁶.らA\0\0\0$\0\0²1ᶜ5⁶.\0\0\0\0\0\0\0▮⁸⁶-#ᶜd⁶.\0\0¹²⁴⁴\0\0²1ᶜ5⁶. \0\0\0\0\0\0\0²1ᶜ3⁶.ᶜᶜᵉ\n\0\0\0\0⁸⁶-#ᶜ5⁶.るるらら@@\0\0²1ᶜ3⁶.\n²²\0\0\0\0\0⁸⁶-#ᶜ5⁶.08▮□⁘▮\0\0²1⁶.³³³³\0\0\0\0\n²1ᶜ4⁶.PP\0⁴\0\0⁘\0⁸⁶-#ᶜ5⁶.██らナユ\0\0H²1⁶.フ{=゜ᶠᶠ⁷⁷⁶.³\0\0\0\0\0\0\0ᶜ4⁶.ユナ`ら█\0\0\0⁶.ᶠ◝█\0¹¹\0\0⁶.\0¹♥_\0\0\0\0⁶.'9\0\0\0\0\0\0  ²1ᶜ8⁶.\0\0\0\0\0█ら@⁸⁶-#ᶜ9⁶.²\0\0\0\0\0\0█⁸⁶-#ᶜd⁶.▮\0\0□█@\0⁸²1ᶜ5⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜ8⁶.\0\0\0\0\0\0¹¹⁸⁶-#ᶜ9⁶. \0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.⁴\0\0$\0¹\0⁸²1ᶜ4⁶.008(.⁶▶ᵇ⁸⁶-#ᶜ5⁶.⁸ᶜ⁴⁶\0¹\0▮²1ᶜc⁶.\0\0\0``\0ナナ⁶.\0\0\0ff\0◝◝⁶.\0\0\0◀⁶\0?? \n²1ᶜ4⁶.\0\0\0\0⁸⁸▮ ⁸⁶-#ᶜ5⁶.X「⁘ろららら█²1⁶.²\0¹¹¹\0▒?²1ᶜ4⁶.\0\0█ナ\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0L□.⁷¹\0²1ᶜ4⁶.`<ᶠ¹\0\0\0\0²1ᶜ3⁶.\0\0\0ららナユユ⁸⁶-#ᶜ4⁶.⁷\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0\0\0\0 ▮⁸ᶜ⁸⁶-#ᶜb⁶.\0\0█\0\0\0\0\0²1ᶜ3⁶.\0\0\0?○?\0⁷⁸⁶-#ᶜb⁶.\0~◝ら█ら◝ヲ²1ᶜ3⁶.\0\0\0\0\0000ュ◜⁸⁶-#ᶜb⁶.\0\0ᶠ?◝エ³¹²1ᶜ3⁶.\0\0\0\0\0\0\0¹⁸⁶-#ᶜb⁶.\0\0\0\0\0³⁷ᵉ²1 ²1ᶜ4⁶.\0\0\0@\0@\0█⁸⁶-#ᶜ9⁶.ら\0\0█\0\0\0@⁸⁶-#ᶜa⁶.\0ら\0\0\0█\0\0⁸⁶-#ᶜd⁶.□□\0\0\0\0\0\0²1ᶜ4⁶.ららら█\0\0\0\0⁸⁶-#ᶜ9⁶.¹\0\0\0\0¹\0\0⁸⁶-#ᶜa⁶.\0¹\0¹\0\0\0\0⁸⁶-#ᶜd⁶.$$\0\0\0\0\0\0²1ᶜ4⁶.\r⁷⁙ᶜ¹▮「\0⁸⁶-#ᶜ5⁶.@` 0ᵉ#`8²1ᶜc⁶.\0ナナ\0ナ   ⁶.\0◝◝\0◝\0\0g⁶.\0??\0?  & \n²1ᶜ4⁶.\0\0\0 \0\0@ ⁸⁶-#ᶜ5⁶.らら██\0\0\0\0²1⁶.゜ᶠᶠᶠᶠ゜?: ⁶.\0\0\0█ららナユ²1ᶜ3⁶.ヲ<ュュ~◜ヲナ⁸⁶-#ᶜ5⁶.⁶²³³¹¹⁷゜⁸⁶-#ᶜb⁶.\0ら\0\0█\0\0\0²3ᶜ5⁶.\0\0\0\0\0\0「゜⁸⁶-#ᶜb⁶.ュ○゜?g\0\0\0²3⁶.⁷ᵉ、「\0\0\0\0²3ᶜ1⁶.ユナら█\0\0\0\0⁸⁶-#ᶜb⁶.ᶜ「0pナナナら²1⁶.\0\0\0\0\0¹¹¹ᶜ2⁶.\0\0\0\0\0A█ワ²1⁶.\0\0\0\0\0、<s⁸⁶-#ᶜ5⁶.\0\0\0█\0\0\0\0²1ᶜ2⁶.\0\0\0\0\0\0█\0⁸⁶-#ᶜ4⁶.ᶜ⁶⁷⁷\0²²²⁸⁶-#ᶜ5⁶.3	`8゜¹\0 ²1ᶜc⁶.        ⁶.■▶⁘w\0005UU⁶.%%%' #%% \n²1ᶜ4⁶.0<゛ᵉ◆ん¹ ⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0らら²1ᶜ4⁶.\0\0\0\0¹\0\0\0⁸⁶-#ᶜ5⁶.ュュゆ?~○ws²1⁶.\0¹³³³³³▒²1ᶜ3⁶.\0らナユx8、⁶⁸⁶-#ᶜ5⁶.ヲ8、ᶜ●をネン²3⁶.◜ュ◜◝◝◝◝◝²3ᶜ1⁶.\0\0\0\0\0²⁴ᶜ⁸⁶-#ᶜ5⁶.⁷ᶠか??ョャリ²3ᶜ1⁶.\0\0\0\0\0\0⁶⁴⁸⁶-#ᶜ5⁶.\0\0\0>◝○ンャ²3⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜb⁶.らららららららら²1ᶜ2⁶.\0@\0█ナらら█⁸⁶-#ᶜb⁶.¹¹¹¹\0\0\0\0⁸⁶-#ᶜe⁶.\0\0\0\0\0¹¹¹⁸⁶-#ᶜf⁶.\0\0\0\0\0\0²²²1ᶜ2⁶.ナ▤xフか○'●⁶.}ヌ゛「ッ◜◜ン²1⁶.\0███り¹らる⁸⁶-#ᶜ4⁶.⁴⁴⁴⁴⁴⁴⁴⁴⁸⁶-#ᶜ5⁶.        ²1ᶜ2⁶.¹\0\0³⁵\0¹Q⁸⁶-#ᶜc⁶.        ²1⁶.UV\0w‖3‖u⁶.%' !!!!'²1ᶜd⁶.\0\0\0\0\0\0\"$⁸⁶-#ᶜf⁶.\0\0\0\0\0³⁘\0\n²1ᶜ4⁶.<ᶠ⁷³\0\0\0\0⁸⁶-#ᶜ5⁶.らユ8もよよよト²1⁶.ンュッャンンンq⁶.りニニニユユヲヲ⁶.◝◝よ○○◝◝◝⁶.◝◝◝◝◜◜◜ッ⁶.ワヤヤハハハa¹⁶.ャャャャャンヲヲ²1ᶜ3⁶.<▮8「\0\0\0\0⁸⁶-#ᶜ5⁶.³ᶠ⁷'?○○○⁸⁶-#ᶜb⁶.@`\0\0\0\0\0\0⁸⁶-#ᶜe⁶.████\0\0\0\0²1ᶜ2⁶.\0\0``「⁸r█⁸⁶-#ᶜe⁶.¹³³\0\0\0\0\0⁸⁶-#ᶜf⁶.⁶⁴\0\0\0\0\0\0²1ᶜ2⁶.█(ロ◆vンヲ◝⁶.■ら>ュヲャ⁷れ²1⁶.れられられれ█⬇️⁸⁶-#ᶜ4⁶.⁴\0\0\0\0\0\0\0⁸⁶-#ᶜ5⁶. $$$$$dD²1ᶜ2⁶.S⧗³ナか?ᶠ?⁸⁶-#ᶜc⁶.  ナ\0\0\0\0\0²1ᶜ2⁶.\0\0\0²\0⁸⁴「⁸⁶-#ᶜc⁶.\0\0◝\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜf⁶.\0\0\0\0\0\0█@²1ᶜ5⁶.\0\0\0\0\0\0\0🐱⁸⁶-#ᶜc⁶.  ?\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0\0\0\0♥¹²1ᶜ5⁶.$6□□\0\0\0¹⁸⁶-#ᶜd⁶.\0\0\0\0\0³³.⁸⁶-#ᶜf⁶.\0\0\0\0\0\0ᶜ▮\n²1ᶜ5⁶.んれらナユp8.⁶.q \0\0\0\0\0\0⁶.ヲュュヲ\0\0\0\0⁶.○゜⁷\0\0\0\0\0⁶.ワみB$\0\0\0\0⁶.²\0\0\0█ららナ⁶.ュュ◜◝◝シ/゜²1⁶.○w{{}}>>⁸⁶-#ᶜ8⁶.███████\0²1ᶜ2⁶.ムナヲヲヲムオユ⁸⁶-#ᶜ8⁶.¹³⁷⁷⁷³²\0²1ᶜ2⁶.◝◝◝xいネ◝⬅️²1⁶.よ{wo゜??>⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0█ら⁸⁶-#ᶜe⁶.\0\0██らら@\0²1ᶜ2⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.@@\0\0\0\0³¹⁸⁶-#ᶜe⁶.\0⁴⁴ᶜ\0¹██⁸⁶-#ᶜf⁶.⁷³れリエを\0\0²1ᶜ2⁶.゜゛ っスナナユ⁸⁶-#ᶜd⁶.\0\0\0\0\0\0⁴⁶⁸⁶-#ᶜe⁶.\0\0²⁶⁶⁷³¹⁸⁶-#ᶜf⁶.\0¹¹¹¹\0\0\0²1ᶜ2⁶.80  !/⁷7⁸⁶-#ᶜ5⁶.\0█らら@\0\0\0⁸⁶-#ᶜd⁶.ら@\0\0\0\0\0\0²1ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.\0\0\0☉\0らユ█⁸⁶-#ᶜf⁶.\0\0\0pヲ>ᵉ\n²1ᶜ5⁶.⁷ᶜ⁸▮\0\0\0⁶⁸⁶-#ᶜd⁶.x@@ ¹²³¹⁸⁶-#ᶜf⁶.\0\0\0\0\0¹\0\0\n²1ᶜ5⁶.&:⁙▶⁷³³¹²1ᶜ3⁶.\0\0\0█らユヲ~⁸⁶-#ᶜ5⁶.\0\0\0\0\0\0\0█²1ᶜ3⁶.`<?゜゜⁷¹\0⁸⁶-#ᶜ5⁶.\0\0\0\0\0⁸ᵉ⁷²1  ⁶.ユユ\0\0\0\0\0\0⁶.³\0█ら ██\0⁶.よトフヨヲ◝◝◝²2ᶜ3⁶.\0<◝◝◜ュナ\0⁸⁶-#ᶜ5⁶.ᶠ³\0\0¹³゜◝²2ᶜ1⁶.ら\0█\0`ら\0\0⁸⁶-#ᶜ3⁶.\0\0\0¹³⁷゜○⁸⁶-#ᶜ5⁶.\0\0¹🐱う8ナ█²2ᶜ1⁶.ᵉ⁷██らナヨリ⁸⁶-#ᶜ5⁶.ナヲ~○?゜ᵉᶜ²1⁶.\0\0\0\0\0██ら⁸⁶-#ᶜd⁶.\0████\0\0\0⁸⁶-#ᶜe⁶.█\0\0\0\0\0\0\0²1ᶜ2⁶.ュュ◜◜ト8ョ◝⁸⁶-#ᶜd⁶.³³¹¹\0\0\0\0²1ᶜ2⁶.7にに⬇️\0らネネ⁸⁶-#ᶜ5⁶.\0\0\0\0▮⁸⁸ᶜ⁸⁶-#ᶜ6⁶.\0\0\0⁸⁷³\0\0⁸⁶-#ᶜd⁶.\0\0\0p⁸⁴⁴\0²1ᶜ2⁶.\0\0\0\0\0\0▮0⁸⁶-#ᶜ5⁶.ら█p▮😐ᶜ\0\0⁸⁶-#ᶜd⁶.\nᶜᵉ²²²\0\0²1ᶜ5⁶.⁷²\0\0¹¹³¹⁸⁶-#ᶜd⁶.\0\0\0\0\0\0\0ᵉ\n²1ᶜ3⁶.██\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.\0@ナユユヲュ◜²1ᶜ3⁶.?³\0\0\0\0\0\0⁸⁶-#ᶜ5⁶.らュ?ᶠ⁷³\0\0²1⁶.³¹\0\0\0\0\0\0    ⁶.おxナら\0\0\0\0⁶.◝◜◝ンネウ▤0²3⁶.¹³³⁷??◝◝²1ᶜ2⁶.\0\0\0\0\0█らナ⁸⁶-#ᶜ5⁶.⁵¹¹¹¹¹\0\0²1ᶜ2⁶.⁸ᶜᵉᵉᶠᶠᶠᶠ⁸⁶-#ᶜ4⁶.\0████ららら⁸⁶-#ᶜ5⁶.ら@@`` \0\0²1ᶜ2⁶.◝◝◝0ょ◝◝◝⁶.ネ゜◝◝◝◝◝◝⁶.i}pO゜か◆?²1⁶.\0\0\0\0ᵉᶠ゜ᶠ⁸⁶-#ᶜ5⁶.¹\0\0\0\0\0\0\0⁸⁶-#ᶜd⁶.²²\0\0\0\0\0\0"

__gfx__
7777777e00000000ee7777777777e77777777777777777777777777777777777777eeee7777777777777777eeeee777777777ee0dd0e00000e77777997997777
777777e0111133bb00e77777777e0e77eeeeeee77777e777777777777eeeee7777e0000e7777777777777ee00000ee777777e00dd660677770e7777899987777
77777e01111111133b0e777777e0d0ee0000000ee77e0e7777777777e00000ee7e0dddd077777777777ee005555500e7777e0ddddd667777670e777889887777
7777e0111111111113b0e7777e00d0e0322222200ee0d0e77777777e02dddd00e0dddddd7777777777e0055555555507777e0dddddd66666660e777788877777
7777e011111110011130ee77e0dd0e034aaa942240e0d0e77777777e0222ddd00ddd555d777777777e005555dddd55577770d666ddddddddd660e77778777777
7777e01101311070113000ee0d1100344aaa9942240d10e777eee7e02112d1100dd5111d77777777e005533333b33dd7770dd666dddddddddd600e7722277777
7777e0107131107011354a0e01dd003449aa9992241150e77e000ee021121135dd51111d7777777e0055d3bbbb3333d77e0dd6ddddddd11dddd0d0e266627777
7777e010711110001135490e05d1003499999a49241510e7e00dd0ee01111335dd5111dd777777e005533bbbdd3b33d77e0d6dddddddffdd1d60d0e611167777
7777e0100155100111350eee011dd1044999aa92221510e7e0d00e77e01333555d111ddd777777e00333333d33b3ddd7e0dd6d6dd00dff001dd0dcec1c1c7777
7777e01005111011133550e7e01515044499994422110e77e000e777e0333355555555d07777ee0053b111b3333d111ee0dddd6dd0000f000dddd0ec111c7777
7777e01151000701113350e7e011150444999a942400e777e0d0e777e03333500055550e777e00003b11001b33d1001000dddd7dd294ff2901dcd0e1ccc17777
77777e01504440001133300e7e01110441144a41140e7777e000e77e03d355000005550e777e00113310440135104400d0ddd7dddfffffff01ddd0e711177777
77777e01507070001113110e77e0004441111a11140e7777e0d30eee0dd505070055550e777e01b3133049000100940e0ddd67dddfcffefe016c0e7722277777
7eee7e01500000011111310e777e044441880908840e77777e003000dd5505001d33550e777e01031330290100109207e06d67ddd5cffffe016dd0e2eee27777
e000ee01500002011111110e777e044444009940240ee77777e03300d5555001d333500e777e0000533002015010200e06ddd67ddd5f88ee0d66c0ee181e7777
01110e01500080111111110e77e000494440040024000e77777e00005555555dd335500e7777e010153100015010001e06dddd67ddd5fee0ddd6c0e881887777
01110e0115500051111111007e0f504944430002490550e77777ee0dd55555555552500077777e0011b311350001113e0616dddd76d55e01ddcc0d0818187777
11bb100111555511131311007e0f5001444400024905f0e77777e01d1155252055225000777777e0013bb333000533be0d16d1ddd6ddd011dccc0d0188817777
1bb3100111555111131111107e0ff501944430249105f0e77777e0011052550115220010777777e0055333335005533e0d16d1d1d666d115dccc00e711177777
11333111dfd1511113111110e00fff5019443044910f500e7777e0200228804108221110777777e0051551b33555d13e0d16d1551dd6dd15c66c000777777777
0111331dfddd511115511111033fff50124430491055ff007777e0022280014082211110777777e00305b11bbbdd1130016d113351dddddc6ff6cc0777777777
0111131d0d0d1111115515113330f5f000244044005fff00777e000000019100220511107777eee00305b104090411bd06dd1bbb3d11ddcc6ffff60777777777
e0111111d0d11111111155551133ff5f000220201055f03177e0110090914008205dd1107eee00e00b0531000f0010bdddd13bb31dd15dcc6fffe60777777777
7e0111115d11111111771555113305f555010001055ff0317e011d114242202205dd5330e00e00ee0001131400050010111313331dd15dccceeeec0777777777
7e0111155111111111cc11111113305555010001300003317e0d0d0d082000004dd55030e0000b0ee00103309f5500be0111d1331dd1bd0cccecc0e777777777
77e0111555511111167711111111110000110001333333117e0000e00800011d1dd50000e0bb0300e00100333350003e0331d1331d13bd50c3ee0e7777777777
7e001115055111117776111711111111111000001111111777e0e0ee0000d01dd50000d1e0330dd0000100005500000e0111dd11dd131d550bff0e7777777777
e00111500551111066601177777ccc777777777777777777777eeeeeeeeedddddddddd110001dd5d000000000000001e01111ddddd1111550b330e7777777777
00111000005111770001777777c000c77777777777777777777dddddddddddddddddddd700011155550000000555111011111111111111550bb30e7777777777
7777770990ee0ee000e777777c04450cc777777777777777777777777fffff7777777777777ffffffff777777777777fff777777777777777777777777777777
777777e090e0900aaa0e7777c004a4500cccc7777777777777777777f0000f777777777777ff000000f777777777fff000f77777777777777777777777777777
777777e0a0e09900aa0e7777c049aa4450000c77777777777777777f00000f77777777777f00000000f77777777f0007660f7777777777777777777777777777
77777e0a90e099099a0e7777c0499aa4444500c777777777777777f006600f7777777777f000c6d00f77777777f00c766d0f77ffff7777777777777777777777
7777e0aa99099999aaa0e7770c0499faa999040c777777777ff77f0067d00f777777777f0ccc7dd00f777777ff00c76ddd00ff000f7777777777777777777777
77770aa9999dddd99aaa0e770c00499aaaaa9900c7777777f00ff0067d00f777777777f00c776d00f777777f000c76dddd0000000f7777777777777777777777
77e0aaa99dd6666d99aa90e77cc0049faaaaa9050c77777f00000067d00f777777777f00cd76d00f777777f000776dd0dd500a900f7777777777777777777777
7e09a99d66667776d9a9a0e77c0500999aaaa9540c77777f044006cd00f7777777777f0cdd76d00f777777f00776d00d55505440f77777777777777777777777
7e0994d6666667776099990ec04450099faaf94000c7777f00490cd00f7777777777f007dd7dd0f7777777f0076dd00551115240f77777777777777777777777
7e094466666666776609990ec099445999ff9900490c7777f009a700f77fffff7777f0c77d7d00f7777777f006dd0d55511d2200f77777777777777777777777
e0940d666666167763d0490ec0f9944f999990499990c77f00929a00f7f0000f777f00777d6d00f77777777f00ddd55111dd51000f7777777777777777777777
e0940d66661006770130490ec0044444f99904990090c7f0092209900f00000f777f0077661d00f777777777f00055511dd5115000f777777777777777777777
e0940d666d000d770030490e0cc00044449004900090cf00922000400006600f777f0077661100f7777777777ff00011dd511150000f77777777777777777777
e0940dd6dd000d630030940e000ccc0044404900050c0f009200f0000067d00f777f00766d1100f777777777777f000dd511555ddd0077777777777777777777
7e040ddddd001d630130920e000000cc00004400540c0f0000000f00067d00f7777f00766d1100f77777777777f00000511555ddd66077777777777777777777
7e0440ddd3311d1313d0920e77700000ccc0445540c00f000000000067d00f77777f0076d11100f7777777777f00550011155dd0d66077777777777777777777
7ee0490d5533d1003350920e77770000000c04400c007fffff044006cd00f777fff000000000000f77777777f00552200555d00d666077777777777777777777
e0002290555dd100550920e7777777000000c00cc00077777f00490cd00f7777f0000000000000000077777f0055220005ddd0066c0077777777777777777777
011002220055d335002220e77777777700000cc00007777777f009a700f77777f009aaaaa9999994007777f0055220000ddd0d66c00f77777777777777777777
011000000d00737500000e777777777777700000007777777f00929a00f77777700499000000094400777f00552200ff00ddd66c00f777777777777777777777
011110000d0707000eeee777777777777777000007777777f0092209900f77777f004400444004400f77f009a2200f7f00d666000f7777777777777777777777
e00022100dd3335000e7777777777777777777777777777f00922000400f777777f0000099400000f77f00944400f777f000000ff77777777777777777777777
7ee0000220ddd350110e777777777777777777777777777f009200f000f77777777f00000000000f777f0554400f77777f0000f7777777777777777777777777
77e00404020000011420e77777777777777777777777777f00000f7fff7777777777d000445000d7777f022200f7777777ffff77777777777777777777777777
7e0024440022110124420e7777777777777777777777777f0000f777777777777777d009a95500d7777f02200f77777777777777777777777777777777777777
e00024442200101222420e7777777777777777777777777fffff7777777777777777d009aa5400d7777f0000f777777777777777777777777777777777777777
e002244222220112222200e7777777777777777777777777777777777777777777777d0009400d77777f000f7777777777777777777777777777777777777777
00224421122201112221000e7777777777777777777777777777777777777777777777d00000d777777ffff77777777777777777777777777777777777777777
00222211112201111111100077777777777777777777777777777777777777777777777d000d7777777777777777777777777777777777777777777777777777
7777777ff777777777777777777777ffff77777777777777777777777777777777777777ddd77777777777777777777777777777777777777777777777777777
777777f00ff777777777777777777f0000f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777f00000f7777777777777777f0ff990f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777f003000f777777777777777f094440f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777f003bb00f7777777777777f00094000f7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777ff033bb0f777777777777f0070000c00f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777f033300f77777777777f00d766cd00f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777f0033300ff77777777777f00000000f7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777f0008358000ff777777777fff0d10fff7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777f0088885888000f7777777777f0d10f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777f088888851888800f77777777f00d500f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77f0888811111122220f7777777f000d5000f7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7f008881881188822200f77777f000d7cd000f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
f008888a9818888821200f777f006dc7cc1500f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
f008289a9888888821200f77f00671ddd1c1500f7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
f002289a8898888221200f7f00676c111cccd500f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
f00228889888882211200f7f0076c8822eccd500f777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
f00222888888822111200ff0077c8888e286dd500f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7f002288882222111200f7f007c7778e2226dd100f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7f00222222221111120f77f006c77788226ddc100f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77f0022111111112200f77f006c77721116ddc100f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777f00022111122000f777f006c8822116ddcc100f77777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777f00002222000ff7777f700c882111dddcc001677777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777f000000000f7777777f006c82111ddc61001677777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777ff000000f777777777d001c882ddd610011677777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777ffffff7777777777d1001cccccc100111677777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777d100011110001116777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777d110000001111d7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777dd1111111d6677777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777dddddddd7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
__label__
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000eeeeeeeeeaaaaaaaaaaa9999999999000000000000555555555aaaaaaaaaaa9999999999000000000000000000000000000000000000000000666
6660000000a88888888877777777777777777777790000000000a000000000777777777777777777777900000000000000000000000000000000000000000666
666000000a78887778887777777777777777777777900000000a7000999000777777777777777777777790000000000000000000000000000000000000000666
666000000a78888878887777777777777777777777900000000a7000909000777777777777777777777790000000000000000000000000000000000000000666
666000000a788888788877777777777ffffffff777900000000a7000999000777777777777777777777790000000080808880000000000000888000000000666
666000000a78888878887777777777ff000000f777900000000a7000909000777777777777777777777790000000080808080000000000000808000000000666
666000000a7888887888777777777f00000000f777900000000a700090900077777777777777eeeee77790000000088808880000000000000888000000000666
666000000a788888888877777777f000c6d00f7777900000000a7000000000777777777777ee00000ee790000000080808000000000000000808000000000666
666000000a7eeeee77777777777f0ccc7dd00f7777900000000a7ddddd77777777777777ee005555500e90000000080808000888088808880888000000000666
666000000a7e77ee7777777777f00c776d00f77777900000000a7dd77d7777777777777e00555555555090000000000000000000000000000000000000000666
666000000a7e7e7e777777777f00cd76d00f777777900000000a7d7ddd777777777777e005555dddd55590000000000000000000000000000000000000000666
666000000a7e7e7e777777777f0cdd76d00f777777900000000a7d7ddd77777777777e005533333b33dd90000000000000000000000000000000000000000666
666000000a7e7e7e77777777f007dd7dd0f7777777900000000a7d7ddd7777777777e0055d3bbbb3333d90000000000990990990990990990990990000000666
666000000a7e777e77777777f0c77d7d00f7777777900000000a7dd77d777777777e005533bbbdd3b33d90000000000899980899980899980899980000000666
66600000097eeeee7777777f00777d6d00f777777740000000097ddddd777777777e00333333d33b3ddd40000000000889880889880889880889880000000666
66600000097e777e7777777f0077661d00f777777740000000097d7ddd7777777ee0053b111b3333d11140000000000088800088800088800088800000000666
66600000097e777e7777777f0077661100f777777740000000097d7ddd777777e00003b11001b33d100140000000000008000008000008000008000000000666
66600000097e7e7e7777777f00766d1100f777777740000000097d7ddd777777e001133104401351044040000000000000000000000000000000000000000666
66600000097e7e7e7777777f00766d1100f777777740000000097d7ddd777777e01b313304900010094040000000000990990990990990990990990000000666
66600000097e7e7e7777777f0076d11100f777777740000000097d777d777777e010313302901001092040000000000899980899980899980899980000000666
66600000097eeeee77777ff000000000000f77777740000000097ddddd777777e000053300201501020040000000000889880889880889880889880000000666
66600000097e77ee7777700000000000000000777740000000097d777d7777777e01015310001501000140000000000088800088800088800088800000000666
66600000097e7e7e77777009aaaaa999999ccc777740000000097d7d7d77777777e0011b31135000111340000000000008000008000008000008000000000666
66600000097e7e7e777770049900000009c000c77740000000097d77dd777777777e0013bb333000533b40000000000000000000000000000000000000000666
666000003333333333333333333044400c04450cc740000000097d7d7d777777777e005533333500553340000000000dd0dd0dd0dd0dd0dd0dd0dd0000000666
66600003eee3333bbb33bb3b3b309940c004a4500cccc00000097d777d777777777e0051551b33555d1340000000000ddddd0ddddd0ddddd0ddddd0000000666
6660000e181e333b3b3b333b3b300000c049aa4450000c00000d7ddddd777777777e00305b11bbbdd113d0000000000ddddd0ddddd0ddddd0ddddd0000000666
666000088188333bbb3b333bb3304450c0499aa4444500c0000d6ddddd6767676eee00305b104090411bd00000000000ddd000ddd000ddd000ddd00000000666
666000081818333b333b333b3b39a9550c0499faa999040c000d7ddddd7777eee00e00b0531000f0010bd000000000000d00000d00000d00000d000000000666
666000018881333b3333bb3b3b39aa540c00499aaaaa9900c00d7ddddd777e00e00ee000113140005001d0000000000000000000000000000000000000000666
666000001113333333333333333009400cc0049faaaaa9050c0d6ddddd676e0000b0ee00103309f5500bd0000000000dd0dd0dd0dd0dd0dd0dd0dd0000000666
666000000d1111111111111111100000dc0500999aaaa9540c0d7ddddd767e0bb0300e00100333350003d0000000000ddddd0ddddd0ddddd0ddddd0000000666
666000000d6888886767676767676767c04450099faaf94000cd655555676e0330dd0000100005500000d0000000000ddddd0ddddd0ddddd0ddddd0000000666
6660000000d188816666666666666666c099445999ff9900490cd155516666666666666666666666666d000000000000ddd000ddd000ddd000ddd00000000666
66600000000d181dddddddddddddddddc0f9944f999990499990cd151dddddddddddddddddddddddddd00000000000000d00000d00000d00000d000000000666
66600000000000000000000000000000c0044444f99904990090c000000000000000000000000000000000000000000000000000000000000000000000000666
666000000000000000000000000000000cc00044449004900090c000000000000000000000000000000000000000000dd0dd0dd0dd0dd0dd0dd0dd0000000666
66600000000000000000000000000000000ccc0044404900050c0000000000000000000000000000000000000000000ddddd0ddddd0ddddd0ddddd0000000666
66600000000555555555aaaaaaaaaaa9000000cc00004400540c0555555555aaaaaaaaaaa9999999999000000000000ddddd0ddddd0ddddd0ddddd0000000666
6660000000a00000000077777777777777700000ccc0445540c000000000007777777777777777777779000000000000ddd000ddd000ddd000ddd00000000666
666000000a700090000077777777777777770000000c04400c00700090900077777777777777777777779000000000000d00000d00000d00000d000000000666
666000000a7000900000777777777777777777000000c00cc0007000909000777777777777777777777790000000000000000000000000000000000000000666
666000000a70009990007777777777777777777700000cc0000a7000990000777777777777777777777790000000000000000000000000000000000000000666
666000000a70009090007777777777777777777777900000000a7000909000777777777777777777777790000000000000000000000000000000000000000666
666000000a7000999000777777e00000000ee77777900000000a7000909000777e77777777777777777790000000000000000000000000000000000000000666
666000000a700000000077777e0111133bb00e7777900000000a700000000077e0e77eeeeeee77777e7790000000000000000000000000000000000000000666
666000000a7ddddd77777777e01111111133b0e777900000000a7ddddd77777e0d0ee0000000ee77e0e790000000000000000000000000000000000000000666
666000000a7dd77d7777777e0111111111113b0e77900000000a7dd77d7777e00d0e0322222200ee0d0e90000000001111111111111111111111100000000666
666000000a7d7ddd7777777e011111110011130ee7900000000a7d7ddd777e0dd0e034aaa942240e0d0e90000000001000000000000000000000100000000666
666000000a7d777d7777777e01101311070113000e900000000a7d777d7770d1100344aaa9942240d10e90000000001000000000000000000000100000000666
666000000a7ddd7d7777777e0107131107011354a0900000000a7ddd7d77701dd003449aa9992241150e90000000001000ccc0c000ccc0ccc000100000000666
666000000a7d77dd7777777e010711110001135490900000000a7d77dd77705d1003499999a49241510e90000000001000c000c000c000c00000100000000666
66600000097ddddd7777777e0100155100111350ee40000000097ddddd777011dd1044999aa92221510e40000000001000cc00c000cc00cc0000100000000666
66600000097d777d7777777e01005111011133550e40000000097d777d777e01515044499994422110e740000000001000c000c000c000c00000100000000666
66600000097d7d7d7777777e01151000701113350e40000000097d7d7d777e011150444999a942400e7740000000001000c000ccc0ccc0ccc000100000000666
66600000097d777d77777777e0150444000113330040000000097d777d7777e01110441144a41140e77740000000001000000000000000000000100000000666
66600000097d7ddd77777777e0150707000111311040000000097d7ddd77777e0004441111a11140e77740000000001000000000000000000000100000000666
66600000097d7ddd7777eee7e0150000001111131040000000097d7ddd777777e044441880908840e77740000000001000000000000000000000100000000666
66600000097ddddd777e000ee0150000201111111040000000097ddddd777777e044444009940240ee7740000000001000ccc00cc00cc0ccc000100000000666
66600000097d77dd77701110e0150008011111111040000000097d77dd77777e000494440040024000e740000000001000c0c0c0c0c0c0ccc000100000000666
66600000097d7d7d77701110e0115500051111111040000000097d7d7d7777e0f504944430002490550e40000000001000cc00c0c0c0c0c0c000100000000666
66600000097d7d7d77711bb100111555511131311040000000097d7d7d7777e0f5001444400024905f0e40000000001000c0c0c0c0c0c0c0c000100000000666
66600000097d7d7d7771bb3100111555111131111140000000097d7d7d7777e0ff501944430249105f0e40000000001000c0c0cc00cc00c0c000100000000666
66600000096d777d67611333111dfd15111131111140000000096d777d676e00fff5019443044910f50040000000001000000000000000000000100000000666
666000000d7ddddd7770111331dfddd51111551111d00000000d7ddddd777033fff50124430491055ff0d0000000001000000000000000000000100000000666
666000000d7ddddd7770111131d0d0d11111155151d00000000d7ddddd7773330f5f000244044005fff0d0000000001111111111111111111111100000000666
666000000d7ddddd777e0111111d0d111111111555d00000000d7ddddd7771133ff5f000220201055f03d0000000000000000000000000000000000000000666
666000000d6ddddd6767e0111115d1111111176155d00000000d6ddddd676113305f555010001055ff03d0000000000000000000000000000000000000000666
666000000d6ddddd6767e0111155111111111cc111d00000000d6ddddd67611133055550100013000033d0000000000000000000000000000000000000000666
666000000d7ddddd76767e01115555111111667111d00000000d7ddddd76711111100001100013333331d0000000000000000000000000000000000000000666
666000000d6555556767e001115055111117676111d00000000d65555567611111111111000001111111d0000000000000000000000000000000000000000666
6660000000d155516666666666666666666666666d0000000000d155516666666666666666666666666d00000000000000000000000000000000000000000666
66600000000d151dddddddddddddddddddddddddd000000000000d151dddddddddddddddddddddddddd000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66605000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
6660000000066666666666666666666cccccccccc0000000000000000000500000000000000000000000eeeeeeeeeaaaaaaaaaaa999999999900000000000666
66600000006111111111111111111111111111111c00000000000000000000000000000000000000000a88888888877777777777777777777790000000000666
666000000611111111111111111111111111111111c0000000000000000000000000000555555555a0a788877788877777777777777777777779000000000666
666000000611111111111111111111111111111111c000000000000000000000000000a00000000070a788888788877777777777777777777779000000000666
666000000611111111111111111111111111111111c00000000000000000500000000a700099900070a78887778887777777777777fffff77779000000000666
666000000611111111111111111111111111111111c00000000000000000000000000a700090900070a7888788888777777777777f0000f77779000000000666
666000000611111661166116611111111111111111c00000000000000000000000000a700099900070a788877788877777777777f00000f77779000000000666
666000000611116111611161611111111111111111c00000000000000000000000000a700000900070a78888888887777777777f006600f77779000000000666
666000000611116661611161611111111111111111c00000000000000000500000000a700000900070a7eeeee777777777ff77f0067d00f77779000000000666
666000000611111161611161611111111111111111c00000000000000000000000000a700000000070a7e77ee77777777f00ff0067d00f777779000000000666
666000000611116611166166111111111111111111c00000000000000000000000000a7ddddd777770a7e7e7e7777777f00000067d00f7777779000000000666
666000000611111111111111111111111111111111c00000000000000000000000000a7dd77d777770a7e7e7e7777777f044006cd00f77777779000000000666
666000000611116161661166111111111111111111c00000000000000000500000000a7d7ddd777770a7e7e7e7777777f00490cd00f777777779000000000666
666000000611116161616161611111111111111111c00000000000000000000000000a7d7ddd777770a7e777e77777777f009a700f77ffff7779000000000666
666000000c11116161616161611111111111111111d00000000000000000000000000a7d7ddd77777097eeeee7777777f00929a00f7f00007774000000000666
666000000c11116161616161611111111111111111d00000000000000000000000000a7dd77d77777097e777e777777f0092209900f000007774000000000666
666000000c11111661616166611111111111111111d0000000000000000050000000097ddddd77777097e777e77777f009220004000066007774000000000666
666000000c11111111111111111111111111111111d0000000000000000000000000097d7ddd77777097e7e7e77777f009200f0000067d007774000000000666
666000000c11116661666161111111111111111111d0000000000000000000000000097d7ddd77777097e7e7e77777f0000000f00067d00f7774000000000666
666000000c11116161611161111111111111111111d0000000000000000000000000097d7ddd77777097e7e7e77777f000000000067d00f77774000000000666
666000000c11116611661161111111111111111111d0000000000000000050000000097d7ddd77777097eeeee77777fffff044006cd00f777774000000000666
666000000c11116161611161111111111111111111d0000000000000000000000000097d777d7777e097e77ee777777777f00490cd00f7777774000000000666
666000000c11116161666166611111111111111111d000ccc0ccc000000000000000097ddddd777e0097e7e7e7777777777f009a700f77777774000000000666
666000000c11111111111111111111111111111111d00000c000c000000000000000097d777d77701097e7e7e777777777f00929a00f77777774000000000666
666000000c11111111111111111111111111111111d000ccc0ccc000000050000000097d7d7d77701097e7e7e77777777f0092209900f7777774000000000666
666000000c10101010101010101010101010101010d000c000c00000000000000000097d77dd77711097e777e7777777f00922000400f7777774000000000666
6660000005010101010101010101010101010101015000ccc0ccc000000000000000097d7d7d7771b0d7eeeee7777777f009200f000f7777777d000000000666
66600000051010101010101010101010101010101050000000000000000000000000096d777d676110d7eeeee7676767f00000f7fff76767676d000000000666
666000000500000000000000000000000000000000500000000000000000500000000d7ddddd777010d7eeeee7777777f0000f7777777777777d000000000666
666000000500000000000000000000000000000000500000000000000000000000000d7ddddd777010d7eeeee7777777fffff77777777777777d000000000666
666000000500000000000000000000000000000000500000000000000000000000000d7ddddd777e00d7eeeee76767676767676767676767676d000000000666
666000000500000000000000000000000000000000500000000000000000000000000d6ddddd6767e0d6eeeee67676767676767676767676767d000000000666
666000000500000000000000000000000000000000500000000000000000500000000d6ddddd6767e0d78888876767676767676767676767676d000000000666
666000000050000000000000000000000000000005000000000000000000000000000d7ddddd76767e0d188816666666666666666666666666d0000000000666
666000000005555555555555555555555555555550000000000000000000000000000d6555556767e000d181dddddddddddddddddddddddddd00000000000666
6660000000000000000000000000000000000000000000000000000000000000000000d155516666666600000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000050000000000d151dddddddddddddddddddddddddd000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666

__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
000b00002155018550000000975012550207501555005550006500975016700006501475010750006500470003750037000371000610000000061000000000000000000000000000000000000000000000000000
000100002f2501a250000000a1502a250211501615007250006500000000650000000065000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000642003120016100000001610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002505028050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000173000700025300070005530007000073000700007000070001700007000270000700007000070000700017000070000700007000070000700007000070000700007000070000700007000070000700
000500000b750000000475000000027500050000520145101a5201b510165100952008520335202f5201f52000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000011050160500f050100501305013000120000b00006000050000500005000080000a0000b0000b000090000d0000000000000000000000000000000000000000000000000000000000000000000000000
000800000042000000016200d70001000030100163001610016100062001710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000700000d02012010037500a720017500e52023010131001f0100d51000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000372000010025000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
