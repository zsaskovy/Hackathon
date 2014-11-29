Aggressive = class("Aggressive", Strategy)

Aggressive.nextEnemy = nil


function Aggressive:areWeAtDestination(marine)
	local weaponRanges = {
		w_pistol = 2,
		w_shotgun = 0, 
		w_chaingun = 2, 
		w_rocket_launcher = 4, 
		w_chainsaw = -2, 
		w_plasma = 4, 
		w_bfg = 4, 
		w_machinegun = 3, 
		w_grenade = 3
	}
	
	--local treshold = 6
	local treshold = 4 + weaponRanges[ Aggressive:selectBestWeapon(marine)]
	
	if UnderAttack == nil then return false end
	
	local enemy = Game.Map:get_entity(UnderAttack)
	if enemy == nil then return false end
	local los = Game.Map:entity_has_los(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
	local ap = Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)

	--print("line of sight: " .. tostring(los) .. ", ap: " .. #ap)

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
	print("[" .. marine.Id .. "] Enemy name (" .. tostring(UnderAttack) .. ")")

	if (UnderAttack == nil) then
		UnderAttack = Aggressive:getNextEnemy(marine)
		
		if (UnderAttack == nil) then
			return Explorer:nextMove(marine)
		end
	end
	
	if (Aggressive:areWeAtDestination(marine) and marine.AttackPoints > 0 ) then
		--we reached our target position, attack
		return Aggressive:attackEnemy(marine)
	end
	
	local enemy = Game.Map:get_entity(UnderAttack)
	if (enemy == nil) then return Explorer:nextMove(marine) end
	
	print("[" .. marine.Id .. "] Chasing enemy (" .. enemy.Id .. ") at: " .. enemy.Bounds.X .. ", " .. enemy.Bounds.Y)
	
	--local path = Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
    local path = Aggressive:getAttackPath(marine, enemy)
    --print_r(path)
    
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		{Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}

end

function Aggressive:areWeReadyToUnload(marine)
    return marine ~= nil and UnderAttacky ~= nil and Aggressive:areWeAtDestination(marine)
end

function Aggressive:getAttackPath(marine, enemy)
    local path = nil
    local minPathStep = 99999
    for x_i = -1,1,1 do
        for y_i = -1,1,1 do
            local e_x = enemy.Bounds.X + x_i
            local e_y = enemy.Bounds.Y + y_i
            local e_p = Game.Map:get_move_path(marine.Id, e_x, e_y)
            if (e_p == nil) then e_p = {} end
            if (#e_p > 0 and #e_p < minPathStep) then
                path = e_p
            end
        end
    end

    return path
--    return Game.Map:get_attack_path(marine.Id, enemy.Bounds.X, enemy.Bounds.Y)
end

function Aggressive:attackEnemy(marine)
	print("[" .. marine.Id .. "] Attacking enemy")
	local enemy = Game.Map:get_entity(UnderAttack)
	
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