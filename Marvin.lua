Marvin = class( "Marvin", DeathMatchMarine )

function Marvin:select_mode()
	return "advance"
end

function Marvin:provide_steps(prev)
	local marine,err = Game.Map:get_entity("marine-1")

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
