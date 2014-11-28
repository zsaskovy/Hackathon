Strategy = class("Strategy")

Strategy.static.recentPositions = {}

function Strategy:recentlyVisited(c)
	for i=1, #Strategy.recentPositions, 1 do
		if Strategy.recentPositions[i] == c then return true end
	end
	return false
end

function Strategy:nextMove(marine)
	return { Command = "done" }
end
