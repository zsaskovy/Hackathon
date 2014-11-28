Marvin = class( "Marvin", DeathMatchMarine )

local baseStrategy = "Explorer"

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")

	local strategy = determineStrategy(marine, baseStrategy)
	local command = {}
	
	if (strategy == "Explorer") then
		command = Explorer:nextMove(marine)
		
	elseif (strategy == "Aggressive") then
		command = Aggressive:nextMove(marine)
		
	elseif (strategy == "Camper") then
		command = Camper:nextMove(marine)
	end

	return { 
		command,
		{ Command = "done" } 
	}
end

