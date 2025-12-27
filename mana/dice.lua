function ini_dice(num)
	for i = 1, num do
		local randomNum = 1 + flr(rnd(6))
		dices[i] = {number = randomNum, hold = false}
	end
end

function drw_dice()
	for i = 1, #dices do
		print(dices[i].number, 2 + (i - 1) * 20, 2, 8)
	end
end
