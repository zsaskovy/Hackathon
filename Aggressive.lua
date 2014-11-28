Aggressive = class("Aggressive", Strategy)

function Aggressive:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearEnemies(marine.Bounds, nil)
	
	--print_r(possibleItems)
	math.randomseed(22323131231212312)
	local nextPosition = nil
	if (#possibleItems > 0) then
		local r = math.random(1, #possibleItems)
		nextPosition = possibleItems[r][1]
		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
		print("Targeted enemy (" .. possibleItems[r][1].Id .. ") at" .. nextPosition.X .. ", " .. nextPosition.Y)
	elseif(#possibleCells > 0) then
		local r = math.random(1, #possibleCells)
		nextPosition = possibleCells[r]
	else
		return { Command = "done" }
	end
	
--	print("")
--	print("Next position:")
--	print_r(nextPosition)
--	print(" ")
	
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	return {
		Command= "move",
		Path= path
	}
end
