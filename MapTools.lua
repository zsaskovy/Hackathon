MapTools = class("MapTools")

MapTools.static.left = coord(-1,0)
MapTools.static.right = coord(1,0)
MapTools.static.top = coord(0,-1)
MapTools.static.bottom = coord(0,1)
MapTools.static.directions = { left, top, right, bottom }
MapTools.static.up = coord(0,-1)
MapTools.static.down = coord(0,1)

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

function MapTools:getPassableCells(coord, maxDistance)
	local res = {}
	for i= coord.X - maxDistance, coord.X + maxDistance, 1 do
		for j = coord.Y - maxDistance, coord.Y + maxDistance, 1 do
			if maxDistance <= (abs(coord.X - i) + abs(coord.Y - j)) and isPassable(coord(i,j)) then
				res[#res+1]=coord(i,j)
			end
		end
	end
end

function getNearItems(coord, maxDistance)
	local range = maxDistance
	local tx = coord.X - range
	local ty = coord.Y - range
	local stuff = Game.Map:entities_in(tx, ty, range * 2, range * 2)

	local ret = {}
	
	local valid_types = {
		ammo_bullet = true, 
		ammo_rocket = true, 
		ammo_cell = true, 
		env_heal = true, 
		i_medkit = true,
		w_shotgun = true, 
		w_chaingun = true, 
		w_rocket_launcher = true, 
		w_chainsaw = true, 
		w_plasma = true, 
		w_bfg = true, 
		w_machinegun = true, 
		w_grenade = true
	}
	
	for k, v in pairs(stuff) do
		if (valid_types[v.Type]) then
			ret[#ret+1] = {v}
		end
	end
	
	return ret
end
