Marvin = class( "Marvin", DeathMatchMarine )

Marvin.weapons = {}
local affinity = "Explorer"

math.randomseed(12323132231212312)

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	if (prev) then return nil end
	local marine,err = Game.Map:get_entity(self.marine_id)

	print("I'm at: " .. marine.Bounds.X .. ", " .. marine.Bounds.Y)
	
	local strategy = determineStrategy(marine, affinity)
	local command = {}
	
	if (strategy == "Explorer") then
		print("Next move in Explorer mode")
		Explorer.priority = "health"
		command = Explorer:nextMove(marine)
		
	elseif (strategy == "Aggressive") then
		print("Next move in Aggressive mode")
		command = Aggressive:nextMove(marine)
		
	elseif (strategy == "Camper") then
		print("Next move in Camper mode")
		command = Camper:nextMove(marine)
	end

	--print_r(command)
	return 
		command
		--,{ Command = "done" } 
	
end

