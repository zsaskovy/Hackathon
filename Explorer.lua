Explorer = class( "Explorer", DeathMatchMarine )

function Explorer:select_mode()
	return "advance"
end

function Explorer:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")
	
	--where to move
	local newCoordinates = {}
	for dir in {MapTools.left, MapTools.bottom, MapTools.right, MapTools.left} do
		local potentialCoord = MapTools.addCoordinate( marine.Bounds, dir)
		if (MapTools.isPassable(potentialCoord)) then
			newCoordinates[#newCoordinates+1] = newCoordinate
		end
	end	
	
	print("aaaaa" .. newCoordinates[0] .. newCoordinates[1])
	
  return { 
    { 
      Command = "move", 
      Path = { 
          newCoordinates[1]
        } 
    },
    { Command = "done" } 
  }
end
