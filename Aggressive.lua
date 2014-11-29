Aggressive = class("Aggressive", Strategy)

function Aggressive:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleItems = MapTools:getNearEnemies(marine.Bounds, nil)
	local nextPosition = nil
	
	math.randomseed(22323131231212312)
	
	
	if (#possibleItems > 0) then
		local r = math.random(1, #possibleItems)
		
		nextPosition = possibleItems[r][1]
		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
		
		local los = Game.Map:entity_has_los(marine.Id, nextPosition.X, nextPosition.Y)
		
		print("Targeted enemy (" .. possibleItems[r][1].Id .. ") at" .. nextPosition.X .. ", " .. nextPosition.Y)
		print(los)
		if (los) then
			print("Attacking enemy")
			return { Command = "attack", Aimed = true, Target = { X = nextPosition.X, Y = nextPosition.Y } }
		end
	elseif(#possibleCells > 0) then
		local r = math.random(1, #possibleCells)
		nextPosition = possibleCells[r]
	else
		return { Command = "done" }
	end
		
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	return {
		Command= "move",
		Path= path
	}
end
