Explorer = class("Explorer", Strategy)

Explorer.static.nextPosition = nil

function isPickupType(t)
	return (MapTools.pickupTypes[t] ~= nil)
end
function isWeaponType(t)
	return (MapTools.weaponTypes[t] ~= nil)
end

function Explorer:getPowerup(c)	
	for i,e in pairs(currentEntities) do
		if (isPickupType(e.Type)) then 
			return e
		end
	end
	return nil
end

function Explorer:areWeAtDestination()
	return (
		Explorer.nextPosition ~= nil 
		and coord(Explorer.nextPosition.X, Explorer.nextPosition.Y) == coord(marine.Bounds.X,marine.Bounds.Y) 
	)
end

function Explorer:getNextTargetPosition()




function Explorer:nextMove(marine)
	--pick up if we're on powerup
	local currentEntity = Explorer:getPowerup(marine.Bounds)
	
	if ( currentEntity ~= nil ) then -- and (not Strategy:recentlyVisited(marine.Bounds)) ) then
		print("PICKUP!")
		if (isWeaponType(currentEntity.Type)) then
			Marvin.weapons[currentEntity.Type] = true
		end
		
		print("Picket up: " .. currentEntity.Type)
		
		return { Command = "pickup" }
	end
	Strategy:visit(coord(marine.Bounds.X, marine.Bounds.Y))
	
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearItems(marine.Bounds, 100)
	
	math.randomseed(12323131231212312)
		
	if (Explorer:areWeAtDestination() ) then
		--we reached our target position, pickup
		Explorer.nextPosition = nil
		return { Command = "pickup" }
	elseif (#possibleItems > 0) then
		local r = math.random(1, #possibleItems)
		nextPosition = possibleItems[r][1]
		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
	elseif(#possibleCells > 0) then
		local r = math.random(1, #possibleCells)
		nextPosition = possibleCells[r]
	else
		return { Command = "done" }
	end
	
	print("Next position:")
	print_r(nextPosition)
	
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	for i,p in ipairs(path) do Strategy:visit(p) end
	return {
		Command= "move",
		Path= path
	}

end
