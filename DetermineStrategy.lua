local affinities = {
	Explorer   = { Explorer = 1, Aggressive = 1, Camper = 1 },
	Aggressive = { Explorer = 1, Aggressive = 1, Camper = 1 },
	Camper     = { Explorer = 1, Aggressive = 1, Camper = 1 }
}

function determineStrategy(marine, affinity)
	local points = strategyWeights(marine)
	local max = points["Explorer"]
	local choosenStrategy = "Explorer"
	
	for strategy, point in pairs(points) do
		points[strategy] = points[strategy] * affinities[affinity][strategy]
	end
	
	--print_r(points)
	
	for strategy, point in pairs(points) do
		if (point > max) then
			max = point
			choosenStrategy = strategy
		end
	end
	
	--return "Explorer"
	local weapons = {
		w_shotgun = 2, 
		w_chaingun = 3, 
		w_rocket_launcher = 12, 
		--w_chainsaw = 2, 
		w_plasma = 12, 
		w_bfg = 12, 
		w_machinegun = 7, 
		w_grenade = 8
	}
	
	local max = 0
	local max_weapon = "w_pistol"
	local numberOfWeapons = 0
	
	for weapon, strength in pairs(weapons) do
		if (marine.Inventory[weapon] ~= nil) then
			numberOfWeapons = numberOfWeapons + 1
			
			if (marine.Inventory[weapon] > max) then
				max = marine.Inventory[weapon]
				max_weapon = weapon
			end
		end
	end

	if (max_weapon == "w_pistol") then
		return "Explorer"
	else
		return "Aggressive"
	end
	
	return choosenStrategy
end