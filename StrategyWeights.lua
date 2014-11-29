function strategyWeights(marine)
    local weights = {
        Explorer =  { HasWeapon = 1, EnemyNear = 1, Health=0.9 ,Armor=0.1, CanDodge=0.0, Invisible=0.0, Wounds=0.1, AttackPoints=0.1, Accuracy=0.0, Deadly=0.0, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.0, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 },
        Camper =    { HasWeapon = 1, EnemyNear = 1, Health=0.0, Armor=0.0, CanDodge=0.0, Invisible=0.0, Wounds=0.0, AttackPoints=0.0, Accuracy=0.0, Deadly=0.0, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.0, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 },
        Aggressive ={ HasWeapon = 5, EnemyNear = 5, Health=0.1, Armor=0.9, CanDodge=0.0, Invisible=3.0, Wounds=0.1, AttackPoints=0.9, Accuracy=0.0, Deadly=0.9, MaxRange=0.0, IgnoresSight=0.0, IgnoresFailedDices=0.0, CanDoAimed=0.0, AttackCount=0.9, MovePoints=0.0, IgnoresCollisions=0.0, MoveCount=0.0 }
    }
    
    local values = { Explorer = 0.0, Camper = 0.0, Aggressive = 0.0 }
    
    for w_key, w_value in pairs(weights) do
		for key, value in pairs(w_value) do
			local marine_value = 0
			
			if (key == "HasWeapon") then
				marine_value = 2
			elseif (key ~= "EnemyNear") then
				local nearEnemies = MapTools:getNearEnemies(marine.Bounds, 4)

				if (#nearEnemies > 0) then
					marine_value = 1
				end

			elseif (key == "Invisible" or key == "CanDodge" or key == "IgnoresFailedDices" or key == "IgnoresSight" or key == "CanDoAimed" or key == "IgnoresCollisions") then
				if (marine[key] == true) then
					marine_value = 1
				else
					marine_value = 0
				end
			else
				marine_value = marine[key]
			end

			if (marine_value ~= nil) then 
				values[w_key] = values[w_key] + (value * marine_value)
			end
		end
	end

    return values
end