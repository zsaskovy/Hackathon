Marvin = class( "Marvin", DeathMatchMarine )

Marvin.weapons = {}
Marvin.mode = "advance"
local affinity = "Explorer"

math.randomseed(1234567890)

function Marvin:select_mode()
	return Marvin.mode
end

function Marvin:provide_steps(prev)
	if (prev) then return nil end
	local marine,err = Game.Map:get_entity(self.marine_id)

--	print("[" .. marine.Id .. "] I'm at: " .. marine.Bounds.X .. ", " .. marine.Bounds.Y)
	
	local strategy = determineStrategy(marine, affinity)
	local command = {}
	Explorer.priority = nil
	
	if (marine.Health - marine.Wounds < 1) then
		print("[" .. marine.Id .. "] I'm at: " .. marine.Bounds.X .. ", " .. marine.Bounds.Y .. " Next move in Getaway mode")
		Explorer.priority = "health"
		Explorer.forceClosest = true
		Marvin.mode = "sprint"
		command = Explorer:nextMove(marine)
			
	elseif (strategy == "Explorer") then
		print("[" .. marine.Id .. "] I'm at: " .. marine.Bounds.X .. ", " .. marine.Bounds.Y .. " Next move in Explorer mode")
		Explorer.priority = "weapons"
		Explorer.forceClosest = true
		Marvin.mode = "sprint"
		command = Explorer:nextMove(marine)
		
	elseif (strategy == "Aggressive") then
		print("[" .. marine.Id .. "] I'm at: " .. marine.Bounds.X .. ", " .. marine.Bounds.Y .. " Next move in Aggressive mode")
        if (Aggressive:areWeReadyToUnload(marine)) then
            Marvin.mode = "unload"
        else
            Marvin.mode = "advance"
        end
		command = Aggressive:nextMove(marine)

	end

	return 
		command
end

