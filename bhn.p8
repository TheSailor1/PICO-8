pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--main

function _init()
	_upd=upd_menu
	_drw=drw_menu
	
	debug={}
end

function _update60()
	_upd()
end

function _draw()
	_drw()
	
	if #debug>0 then
		local d
		for d=1,#debug do
			print(debug[d],2,2+(d*6),7)
		end
	end
end
-->8
--screens

function upd_menu()
	if btnp(🅾️) then
		ini_game()
		_upd=upd_game
		_drw=drw_game
	end
end

function drw_menu()
	cls(5)
	cprint("bear hunter ninja",64,12)
	cprint("press 🅾️ to begin",90,15)
end

function upd_game()
	selcard()
end

function drw_game()
	cls(12)
	--drwcards()
	
end
-->8
--tools

function cprint(_t,_y,_c)
	print(_t, 64-(#_t*2),_y,_c)
end
-->8
--gameplay

function ini_game()
	choices={"bear","hunter","ninja"}
	pos={
		{10,20},
		{45,20},
		{70,45}
	}
	
	cardsel=1
end

function drwcards()
	debug[1]=cardsel
	
	if cardsel==3 then
		ctwo=2
		cthree=1
	elseif cardsel==2 then
		ctwo=1
		cthree=3
	else
		ctwo=3
		cthree=2
	end
	
	local x1,y1=pos[cardsel][1],pos[cardsel][2]
	
	
	print(
		choices[1],
		x1,
		y1,
		7)
		print(
		choices[2],
		pos[ctwo][1],
		pos[ctwo][2],
		7)
		print(
		choices[3],
		pos[cthree][1],
		pos[cthree][2],
		7)
end

function selcard()
	if btnp(⬅️) then
		if cardsel>1 then
			cardsel-=1
		else
			cardsel=#choices
		end
	end
	
	if btnp(➡️) then
		if cardsel<#choices then
			cardsel+=1
		else
			cardsel=1
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
