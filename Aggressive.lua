Aggressive = class("Aggressive", Strategy)

Aggressive.nextEnemy = nil


function Aggressive:areWeAtDestination(marine)
	local treshold = 7
	
	if Aggressive.nextEnemy == nil then return false end
	
	local enemy = Game.Map:get_entity(Aggressive.nextEnemy)
	local los = Game.Map:entity_has_los(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
	local ap = Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)

	print("line of sight: " .. tostring(los) .. ", ap: " .. #ap)

	return (los == true and treshold > #ap)
end

function Aggressive:getNextEnemy(marine)
	local ret = nil
	local possibleEnemies = MapTools:getNearEnemies(marine.Bounds, nil)

	if (#possibleEnemies > 0) then
		local r = math.random(1, #possibleEnemies)
		ret = possibleEnemies[r][1].Id
	end
	
	return ret
end

function Aggressive:nextMove(marine)
	if (Aggressive.nextEnemy == nil) then
		Aggressive.nextEnemy = Aggressive:getNextEnemy(marine)
		
		if (Aggressive.nextEnemy == nil) then
			return Explorer:nextMove(marine)
		end
	end
	
	if (Aggressive:areWeAtDestination(marine) ) then
		--we reached our target position, attack
		return Aggressive:attackEnemy(marine)
	end
	
	local enemy = Game.Map:get_entity(Aggressive.nextEnemy)
	print("[" .. marine.Id .. "] Chasing enemy (" .. enemy.Id .. ") at: " .. enemy.Bounds.X .. ", " .. enemy.Bounds.Y)
	
	local path = Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)

	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		{Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}

end

function Aggressive:attackEnemy(marine)
	print("[" .. marine.Id .. "] Attacking enemy")
	local enemy = Game.Map:get_entity(Aggressive.nextEnemy)
	
	return { 
		{ Command = "select_weapon", Weapon = Aggressive:selectBestWeapon(marine) },
		{ Command = "attack", Aimed = marine.CanDoAimed, Target = { X = enemy.Bounds.X, Y = enemy.Bounds.Y } }
	}
end


function Aggressive:selectBestWeapon(marine)
	return "w_pistol"
end