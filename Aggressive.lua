Aggressive = class("Aggressive", Strategy)

function Aggressive:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, marine.MovePoints)
	local possibleEnemies = MapTools:getNearEnemies(marine.Bounds, nil)
	local nextPosition = nil
	

	if (#possibleEnemies > 0) then
		local r = math.random(1, #possibleEnemies)
		
		nextPosition = possibleEnemies[r][1]
		nextPosition = coord(nextPosition.Bounds.X, nextPosition.Bounds.Y)
		
		local los = Game.Map:entity_has_los(marine.Id, nextPosition.X, nextPosition.Y)
		
		print("Targeted enemy (" .. possibleEnemies[r][1].Id .. ") at" .. nextPosition.X .. ", " .. nextPosition.Y)
		print(los)
		if (los) then
			print("Attacking enemy")
			return { 
				{ Command = "select_weapon", Weapon = "w_pistol" },
				{ Command = "attack", Aimed = marine.CanDoAimed, Target = { X = nextPosition.X, Y = nextPosition.Y } }
			}
			
		end
	elseif(#possibleCells > 0) then
		local r = math.random(1, #possibleCells)
		nextPosition = possibleCells[r]
	else
		return { { Command = "done" } }
	end
		
	local path = Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
	return {
		{ Command= "move", Path= TableFirstNElements(path, marine.MovePoints - marine.MoveCount) }
	}
end
