--aus
--thesailor

function _init()
	plr={
		x=10,
		y=100,
		hand={},
		mana=20
	}

	enem={
	x=100,
	y=10,
	hand={},
	mana=20
	}

	new_roll(plr)
	new_roll(enem)

	_upd=upd_game
	_drw=drw_game
end

function _update60()
	_upd()
end

function _draw()
	_drw()
end
