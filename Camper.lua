Camper = class("Camper", Strategy)

function Camper:nextMove(marine)
	local possibleCells = MapTools:getPassableCells(marine.Bounds, 4)
	
end
