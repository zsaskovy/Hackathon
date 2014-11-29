Explorer = class("Explorer", Strategy)

Explorer.static.nextPosition = nil

function Explorer:getPowerup(c)
	function isPickupType(t)
		if (t==nil)then return false end
		print("ispickup " .. t)
		for i,validType in ipairs(MapTools.pickupTypes) do
			if string_starts(t,validType) then return true end
		end
		return false
	end
	
	local currentEntities = Game.Map:entities_at(c.X, c.Y)
	if (currentEntities == nil) then 
		return nil 
	end
	for i,e in ipairs(currentEntities) do
		if (isPickupType(e.type)) then 
			return e
		end
	end
	return nil
end

function Explorer:nextMove(marine)
	--pick up if we're on powerup
	local currentEntity = Explorer:getPowerup(marine.Bounds)
	
	if ( currentEntity ~= nil ) then -- and (not Strategy:recentlyVisited(marine.Bounds)) ) then
		print("PICKUP!")
		return { Command = "pickup" }
	end
	Strategy:visit(coord(marine.Bounds.X, marine.Bounds.Y))
	
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearItems(marine.Bounds, 100)
	
	math.randomseed(12323131231212312)
		
	if (Explorer.nextPosition ~= nil 
		and coord(Explorer.nextPosition.X, Explorer.nextPosition.Y) == coord(marine.Bounds.X,marine.Bounds.Y) ) then
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
