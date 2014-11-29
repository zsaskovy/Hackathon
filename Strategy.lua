Strategy = class("Strategy")

Strategy.static.maxVisits = 10
Strategy.static.recentPositions = {asd = "qwe"}

function Strategy:visit(c)
	if (#Strategy.recentPositions >= Strategy.maxVisits) then
		for i=2, #Strategy.recentPositions, 1 do
			Strategy.recentPositions[i-1] = Strategy.recentPositions[i]
		end
		Strategy.recentPositions[#Strategy.recentPositions] = c
	else
		Strategy.recentPositions[#Strategy.recentPositions+1] = c
	end
end

function Strategy:recentlyVisited(c)
	for i=0, #Strategy.recentPositions, 1 do
		if Strategy.recentPositions[i] == c then return true end
	end
	return false
end

function Strategy:nextMove(marine)
	return { Command = "done" }
end

function Strategy:isPickupType(t)
	return (MapTools.pickupTypes[t] ~= nil)
end

function Strategy:isWeaponType(t)
	return (MapTools.weaponTypes[t] ~= nil)
end
