Aggressive = class("Aggressive", Strategy)

function Aggressive:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, 4)
	
end
