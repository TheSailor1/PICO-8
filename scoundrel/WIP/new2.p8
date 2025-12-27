pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	hand={}
	hand[1]={act=true,suit="hrt",rank=3}
	hand[2]={act=true,suit="dmd",rank=4}
	hand[3]={act=true,suit="dmd",rank=5}
	hand[4]={act=true,suit="spd",rank=6}
	
	deck={}
	deck[1]={act=true,suit="hrt",rank=3}
	deck[2]={act=true,suit="dmd",rank=4}
	deck[3]={act=true,suit="dmd",rank=5}
	deck[4]={act=true,suit="spd",rank=6}
	deck[5]={act=true,suit="clb",rank=7}
	
	cardpos={
		{x=10,y=10},
		{x=30,y=10},
		{x=10,y=30},
		{x=30,y=30}
	}
	
	activecardpos={unpack(cardpos)}
	
	fleepos={x=50,y=20}
	add(activecardpos,{
		x=fleepos.x,
		y=fleepos.y
	})
	
	curpos=1
	
end

function _update()
	if (btnp(⬅️)) curpos-=1
	if (btnp(➡️)) curpos+=1
	
	local offset=#activecardpos==5 and 1 or 0
	--keep cursor on act cards
	curpos=mid(1,curpos,#activecardpos)
	
	if btnp(❎) then
		--on card
		if curpos!=#activecardpos then
			hand[curpos].act=false
		end
	end
	
	
	--empty list first
	if (#activecardpos>0) activecardpos={}
	for i=1,#hand do
		if hand[i].act==true then
			add(activecardpos,{
					x=cardpos[i].x,
					y=cardpos[i].y
			})
		end
	end
	add(activecardpos,{
		x=fleepos.x,
		y=fleepos.y
	})
	
end

function _draw()
	cls()
	
	? "curpos:"..curpos,80,10,10
	? "actpos:"..#activecardpos,80,16,9
	? "hand:"..#hand,80,22,12
	
	for i=#hand,1,-1 do
		local c=13
		if (hand[i].suit=="hrt") c=8
		if (hand[i].suit=="dmd") c=9
		if hand[i].act==true then
			print(
				hand[i].suit,
				cardpos[i].x,
				cardpos[i].y,
				c)
			print(
				hand[i].rank,
				cardpos[i].x,
				cardpos[i].y+6,
				c)
		end --/hand.act
	
		--flee butt
		print(
			"flee",
			fleepos.x,
			fleepos.y,
			3)
	
		--cursor
		circfill(
			activecardpos[curpos].x-5, 
			activecardpos[curpos].y+3,
			1,7) 
			
	end -- /#hand
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
