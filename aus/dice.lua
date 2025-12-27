--dice
function new_roll(tbl)
	for i=1,3 do
		add(tbl.hand,1+flr(rnd(6)))
	end
end

function sort(a)
	for i=1,#a do
		local j = i
		while j > 1 and a[j-1] > a[j] do
			a[j],a[j-1] = a[j-1],a[j]
			j = j - 1
		end
	end

	local newtbl={}
	for j=#a,1,-1 do
		add(newtbl,a[j])
	end
	
	return newtbl

end
