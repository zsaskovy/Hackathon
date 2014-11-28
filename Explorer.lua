Explorer = class( "Explorer", DeathMatchMarine )

function Explorer:select_mode()
	return "advance"
end

function Explorer:getAdjacentCell(marine, deltaX, deltaY)
	local cell, zone = Game.Map.Cell(marine.Bounds.X + deltaX, marine.Bounds.Y + deltaY)
	return cell
end


function Explorer:provide_steps(prev)
	local marine,err = Game.Map:get_entity(self.player_index)
	
	--where to move
	local newCoordinate = MapTools.addCoordinate( {X = marine.Bounds.X, Y = marine.Bounds.Y}, MapTools.left)
	
	print("aaaaaa" .. newCoordinate.X .. " " .. newCoordinate.Y)
	
	
  return { 
    { 
      Command = "move", 
      Path = { 
          { X = marine.Bounds.X - 1, Y = 1 }  
        } 
    },
    { Command = "done" } 
  }
end
