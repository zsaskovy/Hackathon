Marvin = class( "Marvin", DeathMatchMarine )

local affinity = "Explorer"

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	if (prev) then return nil end
	local marine,err = Game.Map:get_entity("marine-1")

	local strategy = determineStrategy(marine, affinity)
	local command = {}
	
	if (strategy == "Explorer") then
		command = Explorer:nextMove(marine)
		
	elseif (strategy == "Aggressive") then
		command = Aggressive:nextMove(marine)
		
	elseif (strategy == "Camper") then
		command = Camper:nextMove(marine)
	end

	print_r(command)
	return { 
		command,
		{ Command = "done" } 
	}
end

