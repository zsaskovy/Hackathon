Aggressive = class("Aggressive", Strategy)

Aggressive.nextEnemy = nil

--function Aggressive:nextMove(marine)
--	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
--	local possibleEnemies = MapTools:getNearEnemies(marine.Bounds, nil)
--	local nextPosition = nil
--	
--
--	if (#possibleEnemies > 0) then
--		local r = math.random(1, #possibleEnemies)
--		
--		nextPosition = possibleEnemies[r][1]
--		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
--		
--		local los = Game.Map:entity_has_los(marine.Id, nextPosition.X, nextPosition.Y)
--		
--		print("Targeted enemy (" .. possibleEnemies[r][1].Id .. ") at" .. nextPosition.X .. ", " .. nextPosition.Y)
--		print(los)
--		if (los) then
--			print("Attacking enemy")
--			return { 
--				{ Command = "select_weapon", Weapon = Aggressive:selectBestWeapon(marine) },
--				{ Command = "attack", Aimed = marine.CanDoAimed, Target = { X = nextPosition.X, Y = nextPosition.Y } }
--			}
--			
--		end
--	elseif(#possibleCells > 0) then
--		local r = math.random(1, #possibleCells)
--		nextPosition = possibleCells[r]
--	else
--		return { { Command = "done" } }
--	end
--		
--	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
--	return {
--		{ Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
--	}
--end
--
--


function Aggressive:areWeAtDestination(marine)
	local treshold = 5
	
	if Aggressive.nextEnemy == nil then return false end
	
	local los = Game.Map:entity_has_los(marine.Id, Aggressive.nextEnemy.Bounds.X, Aggressive.nextEnemy.Bounds.Y)
	local ap = Game.Map:get_attack_path(marine.Id, Aggressive.nextEnemy.Bounds.X, Aggressive.nextEnemy.Bounds.Y)


	return (los == true and treshold > #ap)
end

function Aggressive:getNextEnemy(marine)
--	function getPossibleNextItem()
--		local possibleWeapons = Game.Map:get_entities("w_")
--		local possibleItems = Game.Map:get_entities("i_")
--		local possibleAmmo = Game.Map:get_entities("ammo_")
--		local possibleEnv = Game.Map:get_entities("env_")
--		
--		local possibleAllItems = TableConcat(possibleWeapons,
--			TableConcat(possibleAmmo,
--			TableConcat(PossibleEnv, PossibleItems)
--		))
--		return (possibleAllItems[math.random(1,#possibleItems)])
--	end
--	
--	local possibleNextItem = getPossibleNextItem()
--
--	return coord(possibleNextItem.Bounds.X, possibleNextItem.Bounds.Y)
	local possibleEnemies = MapTools:getNearEnemies(marine.Bounds, nil)
	-- print_r(possibleEnemies)
	local r = math.random(1, #possibleEnemies)
	--print("r: " .. r)
	--print(#possibleEnemies)
	--print_r(possibleEnemies[r][1])
		
	return possibleEnemies[r][1]
end

function Aggressive:nextMove(marine)
		
	if (Aggressive.nextEnemy == nil) then
		Aggressive.nextEnemy = Aggressive:getNextEnemy(marine)
	end
	
	if (Aggressive:areWeAtDestination(marine) ) then
		--we reached our target position, attack
		return Aggressive:attackEnemy(marine)
	end
	
	print("[" .. marine.Id .. "] Chasing enemy (" .. Aggressive.nextEnemy.Id .. ") at: " .. Aggressive.nextEnemy.Bounds.X .. ", " .. Aggressive.nextEnemy.Bounds.Y)
	local path = Game.Map:get_move_path(marine.Id, Aggressive.nextEnemy.Bounds.X, Aggressive.nextEnemy.Bounds.Y)
	print_r(path)
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		{Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}

end

function Aggressive:attackEnemy(marine)
	print("[" .. marine.Id .. "] Attacking enemy")
	return { 
		{ Command = "select_weapon", Weapon = Aggressive:selectBestWeapon(marine) },
		{ Command = "attack", Aimed = marine.CanDoAimed, Target = { X = Aggressive.nextEnemy.Bounds.X, Y = Aggressive.nextEnemy.Bounds.Y } }
	}
end


function Aggressive:selectBestWeapon(marine)
	return "w_pistol"
end