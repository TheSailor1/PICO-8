function ini_cursor()
	curX = {20, 40, 60}
	curY = 63
	curSel = 1
end

function drw_cursor()
	rrectfill(curX[curSel], curY, 5, 5, 0, 8)
end
