function _init()
	dices = {}
	ini_dice(3)
	ini_cursor()
end

function _update60()
	if btnp(4) then
		ini_dice(3)
	end
	if btnp(0) then
		if curSel > 1 then
			curSel -= 1
		else
			curSel = #dices
		end
	end

	if btnp(1) then
		if curSel < #dices then
			curSel += 1
		else
			curSel = 1
		end
	end
end

function _draw()
	cls(0)
	drw_dice()
	drw_cursor()
end
