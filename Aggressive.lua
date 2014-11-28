Aggressive = class("Aggressive", Strategy)

function Aggressive:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.bounds, 4)
	
end
