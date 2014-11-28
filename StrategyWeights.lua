function strategyWeights(marine)
    local weights = {
        Explorer =  { Health=1.1 ,Armor=0.0, CanDodge=0.0, Invisible=0.0, Wounds=0.0, AttackPoints=0.0, Accuracy=0.0, Deadly=0.0, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.0, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 },
        Camper =    { Health=0.1, Armor=0.0, CanDodge=0.0, Invisible=0.0, Wounds=0.0, AttackPoints=0.0, Accuracy=0.0, Deadly=0.0, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.0, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 },
        Aggressive ={ Health=0.1, Armor=0.0, CanDodge=0.0, Invisible=0.0, Wounds=0.0, AttackPoints=0.0, Accuracy=0.0, Deadly=0.0, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.0, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 }
    }
    
    
    local values = { Explorer = 0.0, Camper = 0.0, Aggressive = 0.0 }
    
    for w_key, w_value in pairs(weights) do
		for key, value in pairs(w_value) do
			local marine_value = marine[key]
			
			if (key == "Invisible" or key == "CanDodge" or key == "IgnoresFailedDices" or key == "IgnoresSight" or key == "CanDoAimed" or key == "IgnoresCollisions") then
				if (marine_value == true) then
					marine_value = 1
				else
					marine_value = 0
				end
			end
			values[w_key] = values[w_key] + (value * marine_value)
		end
	end

    return values
end