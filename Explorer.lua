Explorer = class("Explorer", "Strategy")

function Explorer:nextMove(marine)
	local possibleCells = MapTools.getPassableCells()
	local possibleItems = MapTools.getNearItems(marine.Bounds, 4)
	
	math.randomseed(12323131231212312)
	local nextPosition = {}
	if (#possibleItems > 0) then
		nextPosition = possibleItems[math.random(1, #possibleItems)]
	else
		nextPosition = possibleCells[math.random(1, #possibleCells)]
	end
	
	return Game.Map:get_move_path(marine.Id, nextPosition.X, nextPosition.Y)
end

--[[Explorer = class( "Explorer", DeathMatchMarine )

function Explorer:select_mode()
	return "advance"
end

function Explorer:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")
	
	local direction = MapTools.top
	local newDirection = MapTools.top
	
	--where to move
	function tryMove()
		local nextCoord = MapTools:addCoordinate(marine.Bounds, MapTools:turnDirection(direction, newDirection))
		local tmpCoord = MapTools:turnDirection(direction, newDirection)
		print("nextcoord " .. tmpCoord.X .. tmpCoord.Y)
		return MapTools:isPassable(nextCoord)
	end
	
	while not tryMove() do
		newDirection = MapTools:nextDirection(direction)
		print ("attempt direction" .. direction.X .. direction.Y)
		
	end
	
	newOffset = {X = marine.Bounds.X + newDirection.X, Y = marine.Bounds.Y + newDirection.Y}
	
  return { 
    { 
      Command = "move", 
      Path = { 
          newOffset
        } 
    },
    { Command = "done" } 
  }
end
]]--