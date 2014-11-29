MapTools = class("MapTools")

MapTools.static.left = coord(-1,0)
MapTools.static.right = coord(1,0)
MapTools.static.top = coord(0,-1)
MapTools.static.bottom = coord(0,1)
MapTools.static.directions = { left, top, right, bottom }
MapTools.static.up = coord(0,-1)
MapTools.static.down = coord(0,1)

MapTools.static.pickupTypes = {
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

	MapTools.static.weaponTypes = {
		w_shotgun = true, 
		w_chaingun = true, 
		w_rocket_launcher = true, 
		w_chainsaw = true, 
		w_plasma = true, 
		w_bfg = true, 
		w_machinegun = true, 
		w_grenade = true
	}

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

function MapTools:hasCell(c)
	return not (Game.Map:cell(c.X, c.Y) == nil)
end

function MapTools:getCell(c)
	cell, zone = Game.Map:cell(c.X, c.Y)
	return cell
end
	
function MapTools:getZone(c)
	local cell, zone = Game.Map:cell(c.X, c.Y)
	return zone
end
	
function MapTools:isPassable(c)
	local possibleCell = MapTools:getCell(c)
	if (not (possibleCell == nil)) then
		return possibleCell > 127
	else
		return false
	end
end

function MapTools:getMyLocation(marine)
	return marine.Bounds
end

function MapTools:getPassableCells(c, maxDistance)
	local res = {}
	for i= c.X - maxDistance, c.X + maxDistance, 1 do
		for j = c.Y - maxDistance, c.Y + maxDistance, 1 do
			if maxDistance <= (math.abs(c.X - i) + math.abs(c.Y - j)) and MapTools:isPassable(coord(i,j)) then
				res[#res+1]=coord(i,j)
			end
		end
	end
	return res
end

function MapTools:getNearItems(coord, maxDistance)
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
		if (valid_types[v.Type] and (v.Bounds.X ~= coord.X or v.Bounds.Y ~= coord.Y)) then
			ret[#ret+1] = {v}
		end
	end
	
	return ret
end

function MapTools:getNearEnemies(coord, maxDistance)
	local stuff = nil
	if (maxDistance ~= nil) then
		local range = maxDistance
		local tx = coord.X - range
		local ty = coord.Y - range
		stuff = Game.Map:entities_in(tx, ty, range * 2, range * 2)
	else
		stuff = Game.Map:entities_in(0, 0, Game.Map.width, Game.Map.height)
	end

	local ret = {}
	
	local valid_types = { marine = true }
	
	if (stuff == nil) then return ret end
	
	for k, v in pairs(stuff) do
        if (valid_types[v.Type] and not isTeamMember(v)) then
		--if (valid_types[v.Type] and (v.Bounds.X ~= coord.X or v.Bounds.Y ~= coord.Y)) then
			ret[#ret+1] = {v}
		end
	end
	
	return ret
end

function isTeamMember(marine)
    for i = 1, #Marvins do
        if (Marvins[i] == marine.Id) then return true end
    end
    return false
end

function MapTools:hasPath(entityId, targetX, targetY)
	local path = Game.Map:get_move_path(entityId, targetX, targetY)
	return (#path ~= 0)
end

function MapTools:isEntitySafe(entity)
	return (entity.Type ~= "env_acid")
end

function MapTools:hasSafePath(entityId, targetX, targetY)
	local path = Game.Map:get_move_path(entityId, targetX, targetY)
	for i=1, #path do
		local ents = Game.Map:entities_at(path[i].X, path[i].Y)
		print("ENTITIES")
		print_r(ents)
		if (ents ~= nil and #ents > 0) then
			for j=1, #ents do
				if (not (MapTools:isEntitySafe(ents[j]))) then return false end
			end
		end
	end
	return true
end

--splits the move command with item pickup commands if possible
function MapTools:collectShitWhileMoving(moveCommand)

	function hasPickupEntity(pos)
		local ents = Game.Map:entities_at(pos.X, pos.Y)
		if (ents == nil or #ents == 0) then return false end
		for i=1,#ents do
			if (isPickupItem(ents[i].Type)) then return true end
		end
		return false
	end
	
	local newCommand = {}
	local newPath = {}
	local curPath = moveCommand.Path
	local pickup = false
	
--print("COMMAND")
--print_r(curPath)
	
	
	if (curPath == nil or #curPath <1) then 
		--print("NOCOMMAND")
		--return moveCommand 
	end
	
	for i=1, #curPath do
		newPath[#newPath+1] = curPath[i]
		
		if (i>1 and hasPickupEntity(curPath[i])) then
			print("PICKUP")
			pickup = true
			newCommand[#newCommand+1] = {Command = "move", Path = newPath}
			newCommand[#newCommand+1] = {Command = "pickup"}
			newPath = {}
		end
	end
	if (#newPath > 0) then newCommand[#newCommand+1] = {Command = "move", Path = newPath} end

	if (pickup) then 
		print("NEWCOMMAND")
		print_r(newCommand)
	end
	return newCommand

end

function MapTools:getClosest(marine, entities)
	local ret = {}
	local minDistance = -1
	
	for i = 1, #entities do
		local path = Game.Map:get_move_path(marine.Id, Explorer.nextPosition.X, Explorer.nextPosition.Y)
		if (path ~= nil and (#path < minDistance or minDistance == -1)) then
			minDistance = #path
			ret = entities[i]
		end
	end
	
	return ret
end