MapTools = class("MapTools")

MapTools.static.left = coord(-1,0)
MapTools.static.right = coord(1,0)
MapTools.static.up = coord(0,-1)
MapTools.static.down = coord(0,1)

function MapTools:addCoordinate(op1, op2)
	local r = coord(op1.X+op2.X, op1.Y+op2.Y)
	return r
end
	
function MapTools:getCell(c)
	local cell, zone = Game.Map:cell(c.X, c.Y)
	return cell
end
	
function MapTools:getZone(c)
	local cell, zone = Game.Map:cell(c.X, c.Y)
	return zone
end
	
function MapTools:isPassable(c)
	return getCell(c) > Map.Impassable
end

function MapTools:getMyLocation(marine)
	return marine.Bounds
end