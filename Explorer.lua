Explorer = class("Explorer", Strategy)

function Explorer:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearItems(marine.Bounds, marine.MovePoints)
	
	print_r(possibleItems)
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
	
	print("")
	print("Next position:")
	print_r(nextPosition)
	print(" ")
	
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	return {
		Command= "move",
		Path= path
	}

end
