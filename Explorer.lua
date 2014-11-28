Explorer = class( "Explorer", DeathMatchMarine )

function Explorer:select_mode()
	return "advance"
end

function Explorer:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")
	
	local direction = MapTools.left
	local newDirection = coord(0,0)
	
	--where to move
	function tryMove()
		local nextCoord = MapTools:addCoordinate(Marine.Bounds, MapTools:turnDirection(direction, MapTools.top))
		return MapTools:isPassable(nextCoord)
	end
	
	while not tryMove do
		direction = MapTools:nextDirection(direction)
	end
	newDirection = {X = Marine.Bounds.X + newDirection.X, Y = Marine.Bounds.Y + newDirection.Y}
	
  return { 
    { 
      Command = "move", 
      Path = { 
          newDirection
        } 
    },
    { Command = "done" } 
  }
end
