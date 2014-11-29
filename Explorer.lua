Explorer = class("Explorer", Strategy)

Explorer.nextPosition = nil

function isPickupType(t)
	return (MapTools.pickupTypes[t] ~= nil)
end

function isWeaponType(t)
	return (MapTools.weaponTypes[t] ~= nil)
end


function Explorer:areWeAtDestination(marine)
	return (
		Explorer.nextPosition ~= nil 
		and coord(Explorer.nextPosition.X, Explorer.nextPosition.Y) == coord(marine.Bounds.X,marine.Bounds.Y) 
	)
end

function Explorer:getNextTargetPosition()
	function getPossibleNextItem()
		local possibleWeapons = Game.Map:get_entities("w_")
		local possibleItems = Game.Map:get_entities("i_")
		local possibleAmmo = Game.Map:get_entities("ammo_")
		local possibleEnv = Game.Map:get_entities("env_")
		
		local possibleAllItems = TableConcat(possibleWeapons,
			TableConcat(possibleAmmo,
			TableConcat(PossibleEnv, PossibleItems)
		))
		return (possibleAllItems[math.random(1,#possibleItems)])
	end
	
	local possibleNextItem = getPossibleNextItem()
	print "heading for item:"
	print_r(possibleNextItem)
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
	
	
	math.randomseed(12323131231212312)
		
	if (Explorer.nextPosition == nil) then
		Explorer.nextPosition = Explorer:getNextTargetPosition()
	end
	if (Explorer:areWeAtDestination(marine) ) then
		--we reached our target position, pickup
		Explorer.nextPosition = Explorer:getNextTargetPosition()
		return { Command = "pickup" }
	end
	
	local path = Game.Map:get_move_path(marine.Id, Explorer.nextPosition.X, Explorer.nextPosition.Y)
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		Command= "move",
		Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount)
	}

end
