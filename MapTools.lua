MapTools = class("MapTools")

MapTools.static.left = coord(-1,0)
MapTools.static.right = coord(1,0)
MapTools.static.top = coord(0,-1)
MapTools.static.bottom = coord(0,1)
MapTools.static.directions = { left, top, right, bottom }

function MapTools:addCoordinate(op1, op2)
	local r = coord(op1.X+op2.X, op1.Y+op2.Y)
	return r
end

function MapTools:nextDirection(dir)
	if dir==top then return right
	elseif dir==right then return bottom
	elseif dir==bottom then return left
	elseif dir==left then return top
	end
end

--apply a turn direction to a direction. returns an offset
function MapTools:turnDirection(dir, turnDir)
	function invert(dir)
		return coord(dir.Y, dir.X)
	end
	function minus(dir)
		return coord(-1*dir.X, -1*dir.Y)
	end
	
	if turnDir == top then 
		return dir
	elseif turnDir == bottom then
		return minus(dir)
	elseif turnDir == left then
		if dir.X == 0 then return minus(invert(dir))
		else return invert(dir)
		end
	elseif turnDir == right then
		if (dir.X == 0) then return invert(dir)
		else return minus(invert(dir))
		end
	end
end

function getCell(c)
	local cell, zone = Game.Map.Cell(c.X, c.Y)
	return cell
end
	
function getZone(c)
	local cell, zone = Game.Map.Cell(c.X, c.Y)
	return zone
end
	
function isPassable(c)
	return getCell(c) > Map.Impassable
end