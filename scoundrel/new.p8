pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	routines={}
	debug={}
	
	ini_cards()
	
	_upd=upd_game
	_drw=drw_game
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	drw_routines()
	
	if #debug>0 then
		for i=1,#debug do
			print(
				"\#8"..debug[i],
				80,
				2+(i-1)*6,
				0
			)
		end
	end
end
-->8
--draws
function drw_game()
	cls()
	

	drw_hand()
	drw_cursor()
	drw_flee()
	
	
	? "deck "..#deck,10,66,13
	? "shfdeck "..#shfdeck,10,72,13
	? "hand "..#hand,10,78,9
	
	if #hand>0 and cursel!=5 then
	? hand[cursel].suit.." "..hand[cursel].rank,10,84,9
	end
	
	? "ablepos:"..#ablepos,10,110,1
	? "cursel:"..cursel.." prev:"..prevcur,10,116,1
end

function drw_hand()
	if #hand>0 then
		if #ablepos==5 then
			lmt=4 
		elseif #ablepos<5 then 
		 lmt=#ablepos
		end
		for i=1,lmt do
			local c=13
			if (hand[i].suit=="hrt") c=8
			if (hand[i].suit=="dmd") c=9
			
			local j=ablepos[i] 
			? hand[i].suit,pos[j].x,pos[j].y,c
			? hand[i].rank,pos[j].x,pos[j].y+6,c
		end
	end
end

function drw_cursor()
	if #hand>0 then
	local i=ablepos[cursel]
	circfill(
		pos[i].x-4,
		pos[i].y+4,
		1,11)
	end
end

function drw_flee()
	if canflee==true then
		? "flee",pos[5].x,pos[5].y,5
	end
end
-->8
--updates
function upd_game()
	upd_cursor()
	
	--hand down to 1 card
	if (#hand==1) then
		dealcards(3)
	end
end

function upd_cursor()
	
	if btnp(⬅️) then
		cursel-=1
	end
	if btnp(➡️) then
		cursel+=1
	end
	
	--select
	if btnp(❎) then
		if cursel==5 then
			canflee=false
			for i=#hand,1,-1 do
				add(shfdeck,hand[i])
				deli(hand,i)
			end
			dealcards(4)
			return
		end
		
		if canflee==true then
			deli(ablepos)
			canflee=false
		end
		
		prevcur=cursel
		deli(ablepos,prevcur)
		pos[prevcur].able=false
		
		discard(prevcur)
		cursel=ablepos[1]
		
		for d=1,#ablepos do
			debug[d]=ablepos[d]
		end
	end
	
	--keep with bounds
	cursel=mid(1,cursel,#ablepos)
end
-->8
--cards
function ini_cards()
	deck={}
	deckcpy={}
	hand={}
	suits={"dmd","hrt","spd","clb"}
	
	mk_deck()
	shuffle()
	async(function()
		ani_deal(4)
	end)
	
	--hand positions
	pos={}
	pos[1]={x=10,y=10,able=true}
	pos[2]={x=30,y=10,able=true}
	pos[3]={x=10,y=30,able=true}
	pos[4]={x=30,y=30,able=true}
	pos[5]={x=50,y=30,able=true}
	
	cursel=1
	prevcur=1
	ablepos={1,2,3,4,5}
	canflee=true
	
end

function mk_deck()
	for s=1,#suits do
		for r=2,14 do
			add(deck,{
				suit=suits[s],
				rank=r,
				inhand=false,
				visible=false,
			})
		end
	end
	
	rm_facecards()
	shuffle()
end

function rm_facecards()
	--remove red face cards
	for card in all (deck) do
		if card.suit=="hrt" or
					card.suit=="dmd" then
						if card.rank>10 then
							del(deck,card)
						end
					end
	end
end

function shuffle()
	--make a copy
	for card in all(deck) do
		add(deckcpy,card)
	end
	
	--copy random card into new
	--deck and del from copy
	shfdeck={}
	for i=#deckcpy,1,-1 do
		local rcard=1+rnd(#deckcpy)
		add(shfdeck,deli(deckcpy,rcard))
	end
end

function dealcards(n)
	if (n==4) hand={}
	for i=1,n do
		add(hand,deli(shfdeck,1))
	end
	ablepos={1,2,3,4,5}
	canflee=true
end

function discard(i)
	deli(hand,i)
end


-->8
--routines
function async(func)
	add(routines,cocreate(func))
end

function drw_routines()
	for r in all(routines) do
		if costatus(r)!="dead" then
			assert(coresume(r))
		end
	end
end

function wait(f)
	for i=1,f do
		yield()
	end
end

function ani_deal(v)
	for i=1,20 do
		yield()
	end
	dealcards(v)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
