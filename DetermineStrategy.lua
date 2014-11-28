local affinities = {
	Explorer   = { Explorer = 10, Aggressive = 5, Camper = 1 },
	Aggressive = { Explorer = 5, Aggressive = 10, Camper = 1 },
	Camper     = { Explorer = 1, Aggressive = 1, Camper = 10 }
}

function determineStrategy(marine, affinity)
	return "Explorer"
end