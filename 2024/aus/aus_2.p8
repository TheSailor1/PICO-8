pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--aus
--the sailor

--------------
-- notes
--------------
-->8
--main
function _init()
	ini_menu()
end

function _update60()
	_upd()
end

function _draw()
	_drw()
end

------------------
function ini_menu()
	_upd=upd_menu
	_drw=drw_menu
end

function ini_game()
	ini_dice(3)
	dicecol=1
	_upd=upd_game
	_drw=drw_game
end
-->8
--draws
function drw_menu()
	cls()
	cprint("aus",64,7)
	cprint("press [z]",84,1)
end

function drw_game()
	cls(6)
	print("game",2,2,13)
	drw_dice()
	drw_cursor()
end

function drw_dice()
	local col,off
	for d=1,#alldice do
		if alldice[d].picked then
			col=8
			off=8
		else
			col=13
			off=0
		end
		
		rectfill(
			alldice[d].x,
			alldice[d].y-off,
			alldice[d].x+dsize,
			(alldice[d].y+dsize)-off,
			7
		)
		
		print(
			alldice[d].val,
			alldice[d].x+5,
			(alldice[d].y+4)-off,
			col)
	end
end

function drw_cursor()
	circfill(
		alldice[dicecol].x+6,
		alldice[dicecol].y+18,
		2,13
	)
end
-->8
--updates
function upd_menu()
	if btnp(4) then
		ini_game()
	end
end

function upd_game()
	upd_cursor()
end

------------
function upd_cursor()
	mov_cursor()
	pickdice()
end

function mov_cursor()
		if btnp(0) then
		if dicecol>1 then
			dicecol-=1
		else
			dicecol=#alldice
		end
	end
	if btnp(1) then
		if dicecol<#alldice then
			dicecol+=1
		else
			dicecol=1
		end
	end
end

function pickdice()
	if btnp(5) then
		if not alldice[dicecol].picked then
			alldice[dicecol].picked=true
		else
			alldice[dicecol].picked=false
		end
	end
end


-->8
--tools
function cprint(_s,_y,_c)
	print(_s,64 - (#_s*2),_y,_c)
end

function ini_dice(_n)
	alldice={}
	dsize=12
	dpad=4
	
	for d=1,_n do
		add(alldice,{
			val=1+flr(rnd(6)),
			x=10+(d*dpad)+(d*dsize),
			y=20,
			picked=false
		})
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
