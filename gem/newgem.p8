pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--notes

--notes taken from reviews and comments
--------------------------------------

-- bugs
--========

-- 1 you trigger a fight and win
--   the round. a battle begins
--   the next round



--newgrounds
--==========

-- 1 the tutorial isn't that 
--   informative

-- 2 opening a tile does seem
--   jarring, almost as if 
--   something when wrong.

-- 3 when in a battle you don't
--   get feedback as to how the
--   gems help.

-- 4 the battle system seems 
--   gimmicky. right now it's a
--   punishment for playing badly.
--   if you're good at the game
--   you wouldn't see a battle
--   which then loses the games 
--   appeal from being different
--   to minesweeper.

--spitballing
--============

-- 1 gems can be alive? 
--   like pokemonesk?

-- 2 improve the gameloop 
--   feedbacks

-- 3 levels/stages can be tied
--   to diver class
--   - class 1 (beach diving)
--   - class 2 (current diving)
--   - class 3 (deeper water. bigger/stronger monsters)

-- 4 stage maps can be in a 
--   variety of shapes

-- 5 add items/shop to game
-->8
--main
function _init()
	--init tools
	multi_circfill=multi(circfill)
	multi_rectfill=multi(rectfill)
	multi_line=multi(line)
	multi_sspr=multi(sspr)
	multi_pset=multi(pset)
--	multi_rrect=multi(rrect)
	
	
	ini_screen(upd_splash,drw_splash)
end

function _update60()
	upd()
end

function _draw()
	drw()
end
-->8
--tools
function ini_screen(_u,_d)
	upd=_u
	drw=_d
end

function cprint(_s,_y,_c)
	print(_s,64-(#_s*2),_y,_c)
end

-- returns a multi call function
	function multi(f)
	return 
		function(s)
			local a=split(s,"\n")
			local i
			for i=1,#a do
			 f(unpack(split(a[i])))
		end
	end
end

function callfromstring(l)
	for s in all(split(l,"/")) do
		s=split(s)
		for i,si in inext,s do
		--retrieving the value in env if it exists,
		--keeping the original value otherwise
			s[i]=_env[si] or si
		end
		deli(s,1)(unpack(s))
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

function inctimer()
	if t>30000 then
		t=0
	else
		t+=1
	end
end

-->8
--draws
function drw_splash()
	cls()
	fadepal((100-develop)/100)
	
	drw_bkg(0,0,127,127,0)
	
	cprint("praeberi fari",100,1)
	?sp_logo,40,40
end

function drw_menu()
	cls(6)
	
	multi_circfill
	[[5,60,6,7
	14,60,8,7
	25,60,4,7
	65,60,4,7
	75,60,8,7
	83,60,6,7
	90,60,6,7
	98,60,4,7
	102,60,4,7
	110,60,8,7
	120,60,8,7]]

	cprint("gemstone dredging",64,13)
	cprint("bubble trouble",72,7)
end

function drw_game()
	cls(6)
	cprint("game",22,13)
end
-->8
--updates
function upd_splash()
	inctimer()
	
	fadeeff(1)
	
	if t>=120 or btnp"5" or btnp"4" then
		resetdev()
		ly,sy,float,sf,t,wait,co,cx,cpass,gy=-50,100,true,true,0,-1,0,0,0,-70
		
		ini_screen(upd_menu,drw_menu)
	end
end

function upd_menu()
	if btnp(4) then
		ini_screen(upd_game,drw_game)
	end
end

function upd_game()
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
