--screens
function drw_game()
	cls(8)
	drw_dice(plrhand,10,90)
	drw_dice(enemhand,90,20)
end

function drw_dice(tbl,x,y)
	for i=1,#tbl do
		?tbl[i],x+((i-1)*8),y,7
	end
end
