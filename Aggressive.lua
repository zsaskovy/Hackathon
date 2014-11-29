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
	
	--local path = Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
    local path = Aggressive:getAttackPath(marine, enemy)
    --print_r(path)
    
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		{Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}

end

function Aggressive:getAttackPath(marine, enemy)
    local path = nil
    local minPathStep = 99999
    for x_i = -1,1,1 do
        for y_i = -1,1,1 do
            local e_x = enemy.Bounds.X + x_i
            local e_y = enemy.Bounds.Y + y_i
            local e_p = Game.Map:get_move_path(marine.Id, e_x, e_y)
            if (#e_p > 0 and #e_p < minPathStep) then
                path = e_p
            end
        end
    end
--    local path = Game.Map:get_move_path(marine.Id, 1000, 1000)
--    print("++++++++++++++")
--    print_r(path)
--    print("--------------")
    return path
--    return Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
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
	local weapons = {
		w_pistol = 1,
		w_shotgun = 2, 
		w_chaingun = 3, 
		w_rocket_launcher = 12, 
		w_chainsaw = 2, 
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

	return max_weapon
end