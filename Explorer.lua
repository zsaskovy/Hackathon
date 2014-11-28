Explorer = class( "Explorer", DeathMatchMarine )

function Explorer:select_mode()
	return "advance"
end

function Explorer:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")
	
	--where to move
	local newCoordinate = MapTools:addCoordinate( {X = marine.Bounds.X, Y = marine.Bounds.Y}, MapTools.left)
	
	print("aaaaaa" .. newCoordinate.X .. " " .. newCoordinate.Y)
	
	
  return { 
    { 
      Command = "move", 
      Path = { 
          newCoordinate  
        } 
    },
    { Command = "done" } 
  }
end
