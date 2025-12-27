pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	suits={"hrt","dmd","spd","clb"}
	deck={}
	deckcopy={}
	shfdeck={}
	shfdeckcopy={}
	hand={}
	
	posx={124,124,124,124}
	posy={2,8,14,20}
	cursel=1
	
	
	mk_deck()
	rm_faces()
	copy(deck,deckcopy)
	shuffle(deckcopy,shfdeck)
	copy(shfdeck,shfdeckcopy)
	dealcards(4)
end

function _update()
	--check for 1 card left
	newroom()
	
	if btnp(❎) then
		dealcards(4)
	end
	
	if btnp(🅾️) then
		discard(cursel)
	end
	
	if btnp(⬆️) and cursel>1 then
		cursel-=1
	end
	if btnp(⬇️) and cursel<#hand then
		cursel+=1
	end 
end

function _draw()
	cls()
	drw_deck(deckcopy,20,2,2)
	drw_deck(deck,2,2,8)
	drw_deck(shfdeck,40,2,8)
	drw_deck(shfdeckcopy,70,2,3)
	drw_deck(hand,96,2,9)
	
	circfill(posx[cursel],posy[cursel],2,10)
end

function mk_deck()
	for s=1,4 do
		for r=2,14 do
			add(deck,{
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

function drw_deck(tbl,x,y,col)
	if #tbl>0 then
		for c=1,#tbl do
			? tbl[c].suit.."."..tbl[c].rank,x,y+((c-1)*6),col
		end
	else
		? "[-x-]",x,y,col
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

function newroom()
	if #hand==1 then
		dealcards(3)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
