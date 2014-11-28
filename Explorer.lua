Explorer = class("Explorer", Strategy)

function Explorer:getPowerup(c)
	function isPickupType(t)
		for i,validType in ipairs(MapTools.pickupTypes) do
			if t == validType then return true end
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
	
	print_r(Game.Map:entities_in(marine.Bounds.X, marine.Bounds.Y,10,10))
	if ( currentEntity ~= nil and not Strategy:recentlyVisited(marine.Bounds) ) then
		print_r(Strategy.recentPositions)
		Strategy.recentPositions = { marine.Bounds }
		return { Command = "pickup" }
	end
	
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearItems(marine.Bounds, marine.MovePoints)
	
	math.randomseed(12323131231212312)
	local nextPosition = nil
	local headToPickup = false
	
	if (#possibleItems > 0) then
		local r = math.random(1, #possibleItems)
		nextPosition = possibleItems[r][1]
		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
		headToPickup = true
	elseif(#possibleCells > 0) then
		local r = math.random(1, #possibleCells)
		nextPosition = possibleCells[r]
	else
		return { Command = "done" }
	end
	
	--[[print("")
	print("Next position:")
	print_r(nextPosition)
	print(" ")]]--
	
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	return {
		Command= "move",
		Path= path
	}

end
