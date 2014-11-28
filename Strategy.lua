function strategy(bot) 
	local l = MapTools:getMyLocation(bot)
	
	if (getNearEnemies(l) ~= nil) then
		local enemies = getNearEnemies(l)
		if (canAttack()) then
			attack(enemies)
		else
			escape(enemies)
		end
	elseif (getNearItems(l) ~= nil) then
		local nearItems = getNearItems(l)
		
		if (lowHealth() and hasHealing(nearItems)) then
			item = getHealing(nearItems)
			moveTo(nearItems.location)
		elseif (lowAmmo() and hasAmmo(nearItems)) then
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

function canAttack()
end

function attack(enemies)
end

function escape(enemies)
end

function lowHealth()
end

function hasHealing(nearItems)
end

function lowAmmo()
end

function hasAmmo(nearItems)
end

function moveAlong(location)
end

local function getMyLocation()
end