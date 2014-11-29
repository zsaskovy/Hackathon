Explorer = class("Explorer", Strategy)

Explorer.nextPosition = nil

--can be: nil, weapons, health, ammo
Explorer.priority = "weapons"

function isPickupType(t)
	return (MapTools.pickupTypes[t] ~= nil)
end

function isWeaponType(t)
	return (MapTools.weaponTypes[t] ~= nil)
end


function Explorer:areWeAtDestination(marine)
	local ret = (
		Explorer.nextPosition ~= nil 
		and Explorer.nextPosition.X == marine.Bounds.X
		and Explorer.nextPosition.Y == marine.Bounds.Y 
	)

	return ret
end

function Explorer:getNextTargetPosition(marine)
	function getPossibleNextItem()
	
		local possibleWeapons = Game.Map:get_entities("w_")
		local possibleItems = Game.Map:get_entities("i_")
		local possibleAmmo = Game.Map:get_entities("ammo_")
		local possibleEnv = Game.Map:get_entities("env_")
		local possibleAllItems = {}
		
		--possible items based on priority
		if (Explorer.priority == "ammo" and possibleAmmo ~= nil) then
			for i=1,#possibleAmmo do
				if (MapTools:hasPath(marine.Id, possibleAmmo[i].Bounds.X, possibleAmmo[i].Bounds.Y)) then
					possibleAllItems[#possibleAllItems+1] = possibleAmmo[i]
				end
			end
		elseif (Explorer.priority == "weapons" and possibleWeapons ~= nil) then
			for i=1,#possibleWeapons do
				if (MapTools:hasPath(marine.Id, possibleWeapons[i].Bounds.X, possibleWeapons[i].Bounds.Y)) then
					possibleAllItems[#possibleAllItems+1] = possibleWeapons[i]
				end
			end
		elseif (Explorer.priority == "health" and possibleItems ~= nil) then
			print_r(possibleItems)
			for i=1,#possibleItems do
				if (isTypeHealth(possibleItems[i].Type) and MapTools:hasPath(marine.Id, possibleItems[i].Bounds.X, possibleItems[i].Bounds.Y)) then 
					possibleAllItems[#possibleAllItems+1]=possibleItems[i] 
				end
			end
		end
		
		--if there's no priority, or there are no priority items, go back to default mode 
		if (#possibleAllItems == 0) then
			possibleAllItems = TableConcat(possibleWeapons,
				TableConcat(possibleAmmo,
				TableConcat(PossibleEnv, PossibleItems)
			))
		end
		print_r(possibleAllItems)
		return (possibleAllItems[math.random(1,#possibleItems)])
	end
	
	local possibleNextItem = getPossibleNextItem()

	return coord(possibleNextItem.Bounds.X, possibleNextItem.Bounds.Y)
end

function Explorer:nextMove(marine)
	--[[pick up if we're on powerup
	local currentEntity = Explorer:getPowerup(marine.Bounds)
		
	if ( currentEntity ~= nil ) then -- and (not Strategy:recentlyVisited(marine.Bounds)) ) then
		if (isWeaponType(currentEntity.Type)) then
			Marvin.weapons[currentEntity.Type] = true
		end
		
		print("Picket up: " .. currentEntity.Type)
		
		return { Command = "pickup" }
	end
	Strategy:visit(coord(marine.Bounds.X, marine.Bounds.Y))
	]]--
	
	--print("CURRENT INVENTORY")
	--print_r(Game.Map:get_entity(marine.Id).Inventory)
		
	if (Explorer.nextPosition == nil) then
		Explorer.nextPosition = Explorer:getNextTargetPosition(marine)
	end
	
	if (Explorer:areWeAtDestination(marine) ) then
		--we reached our target position, pickup
		Explorer.nextPosition = Explorer:getNextTargetPosition(marine)
		print("Picking up item:")
		return { { Command = "pickup" } }
	end
	
	local path = Game.Map:get_move_path(marine.Id, Explorer.nextPosition.X, Explorer.nextPosition.Y)
	
	print("PATH FROM " .. marine.Bounds.X .. "," .. marine.Bounds.Y .. " to " .. Explorer.nextPosition.X .. "," .. Explorer.nextPosition.Y)
	print_r(path)
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		{Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}

end
