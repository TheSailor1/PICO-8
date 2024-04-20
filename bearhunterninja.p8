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
		local i
		for i=1,#debug do
			print(debug[i],2,2+(i*6),7)
		end--for
	end--if
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
	cls()
	cprint("bear hunter ninja",64,13)
	cprint("press 🅾️ to start",80,1)
end

function upd_game()
	selcards()
end

function drw_game()
	cls(1)
	
	drw_cards()
end
-->8
--tools

function cprint(_t,_y,_c)
	print(_t,64-(#_t*2),_y,_c)
end
-->8
--gameplay

function ini_game()
	choices={"bear","hunter","ninja"}
	cardpos={
		{x=42,y=40},
		{x=70,y=10},
		{x=15,y=10}
	}
	
	cardsel=3
	cardw=40
	cardh=50
	c1c=7
	c2c=2
	c3c=13
end

function drw_cards()
	local backl,backr
	if cardsel==1 then
		backl=2
		backr=3
	elseif cardsel==2 then
		backl=3
		backr=1
	else
		backl=1
		backr=2
	end
	
	rectfill(cardpos[backl].x,cardpos[backl].y,cardpos[backl].x+cardw,cardpos[backl].y+cardh,c3c)
	rectfill(cardpos[backr].x,cardpos[backr].y,cardpos[backr].x+cardw,cardpos[backr].y+cardh,c2c)
	
	rectfill(cardpos[cardsel].x,cardpos[cardsel].y,cardpos[cardsel].x+cardw,cardpos[cardsel].y+cardh,c1c)
end

function selcards()
	if btnp(⬅️) then
		if cardsel>1 then
			cardsel-=1
		else
			cardsel=#cardpos
		end
	end
	
	if btnp(➡️) then
		if cardsel<#cardpos then
			cardsel+=1
		else
			cardsel=1
		end
	end
	
	debug[1]=cardsel
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
