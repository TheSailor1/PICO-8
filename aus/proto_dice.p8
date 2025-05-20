pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--notes

-- aus game
-------------


-->8
--main

function _init()
	ini_dice()
	sel=1
	phase="reveal"
	_upd=upd_game
	_drw=drw_game
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	print(phase,2,2,8)
	print("c:"..c,2,8,8)
	print(rollt,2,14,8)
end
-->8
--draws
function drw_game()
	cls()
	drw_dice()
	drw_cursor()
end

function drw_dice()
	for i=1,#alldice do
		rect(
			alldice[i].x,
			alldice[i].y,
			alldice[i].x+dicesize,
			alldice[i].y+dicesize,
			8)
			
		print(
			alldice[i].val,
			alldice[i].x+9,
			alldice[i].y+8,
			8)
	end
	
	function drw_cursor()
		circfill(
			alldice[sel].x+10,
			alldice[sel].y-8,
			3,6)
	end
end
-->8
--updates
function upd_game()
	upd_cursor()
	upd_dice()
end

function upd_cursor()
	if btnp(⬅️) and sel>1 then
		sel-=1
	end
	if btnp(➡️) and sel<numdice then
		sel+=1
	end
	
	if btnp(❎) then
		if alldice[sel].chosen then
			alldice[sel].chosen=false
			c-=1
else
			alldice[sel].chosen=true
			c+=1
		end
	end
end

function upd_dice()
	for d in all(alldice) do
		if d.chosen then 
			d.y=32
		else
			d.y=64
		end
	end
	
	if c>0 then
		phase="choice"
	else
		phase="reveal"
	end
end
-->8
--dice
function ini_dice()
	alldice={}
	numdice=3
	c=0
	rollt=0
	
	dicesize=20
	new_dice()
end

function new_dice()
	for i=1,numdice do
		add(alldice,{
			x=30+((i-1)*5)+((i-1)*dicesize),
			y=62,
			val=1+flr(rnd(6)),
			chosen=false
		}) 
	end
end

function roll_dice()
	for d in all(alldice) do
		if d.chosen then
			d.val=1+flr(rnd(6))
			d.chosen=false
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
