Marvin = class( "Marvin", DeathMatchMarine )

local dx, dy

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")

	local command = Strategy:strategy(marine)

	return { 
		command,
		{ Command = "done" } 
	}
end

