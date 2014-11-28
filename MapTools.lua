MapTools = class("MapTools")

MapTools.static.left = coord(-1,0)
MapTools.static.right = coord(1,0)
MapTools.static.top = coord(0,-1)
MapTools.static.bottom = coord(0,1)

function MapTools:addCoordinate(op1, op2)
	local r = coord(op1.X+op2.X, op1.Y+op2.Y)
	return r
end
	
function getCell(coord)
	local cell, zone = coord(coord.X, coord.Y)
	return cell
end
	
function getZone(coord)
	local cell, zone = coord(coord.X, coord.Y)
	return zone
end
	
function isPassable(coord)
	return getCell(coord) > Map.Impassable
end