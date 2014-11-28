function strategy(marine) 
	local l = MapTools:getMyLocation(marine)
	
	if (getNearEnemies(l) ~= nil) then
		local enemies = getNearEnemies(l)
		if (canAttack(marine)) then
			attack(enemies)
		else
			escape(enemies)
		end
	elseif (getNearItems(l) ~= nil) then
		local nearItems = getNearItems(l)
		
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

function getNearEnemies(nearItems)
end

function getNearItems(nearItems)
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
