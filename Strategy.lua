function strategy(marine) 
	local l = MapTools:getMyLocation(marine)
	
	if (getNearEnemies(l) ~= nil) then
		local enemies = getNearEnemies(l)
		if (canAttack(marine)) then
			attack(enemies)
		else
			escape(enemies)
		end
	elseif (getNearItems(marine) ~= nil) then
		local nearItems = getNearItems(marine)
		
		if (lowHealth(marine) and hasHealing(nearItems)) then
			item = getHealing(nearItems)
			moveTo(nearItems.location)
		elseif (lowAmmo(marine) and hasAmmo(nearItems)) then
			item = getAmmo(nearItems)
			moveTo(nearItems.location)
		else 
			moveAlong(l)
		end
	else
		moveAlong(l)
	end
	
end

function getNearEnemies(c)
end

function getNearItems(marine)
	local range = marine.MovePoints
	local tx = marine.Bounds.X - range
	local ty = marine.Bounds.Y - range
	local stuff = Game.Map:entities_in(tx, ty, range * 2, range * 2)

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
	
	print_r(valid_types)
	
	for k, v in pairs(stuff) do
		if (valid_types[v.Type]) then
			print(v.Type)
		end
	end
end

function canAttack(marine)
	return (marine.AttackPoints > 0 and not lowAmmo(marine))
end

function attack(enemies)
end

function escape(enemies)
end

function lowHealth(marine)
    local healt_threshold = 5
    return marine.Health < healt_threshold
end

function hasHealing(nearItems)
end

function lowAmmo(marine)
    local ammo_threshold = 0
    return marine.AttackPoints > ammo_threshold
end

function hasAmmo(nearItems)
    
end

function moveAlong(location)
end
