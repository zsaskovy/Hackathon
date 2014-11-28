Marvin = class( "Marvin", DeathMatchMarine )

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")

	--local command = Strategy:strategy(marine)
	local c = MapTools:getMyLocation(marine)
	getNearItems(marine)

	return { 
--		command,
		{ Command = "done" } 
	}
end

