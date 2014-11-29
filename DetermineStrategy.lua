local affinities = {
	Explorer   = { Explorer = 1, Aggressive = 1, Camper = 1 },
	Aggressive = { Explorer = 1, Aggressive = 1, Camper = 1 },
	Camper     = { Explorer = 1, Aggressive = 1, Camper = 1 }
}

function determineStrategy(marine, affinity)
	local points = strategyWeights(marine)
	local max = points["Explorer"]
	local choosenStrategy = "Explorer"
	
	for strategy, point in pairs(points) do
		points[strategy] = points[strategy] * affinities[affinity][strategy]
	end
	
	print_r(points)
	
	for strategy, point in pairs(points) do
		if (point > max) then
			max = point
			choosenStrategy = strategy
		end
	end
	
	--return "Explorer"
	return choosenStrategy
end