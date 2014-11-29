Marvins = {}
UnderAttack = nil

function CreateMarine(player_index, marine_id, instance_index)

    Marvins[#Marvins + 1] = marine_id

	return Marvin:new(player_index, marine_id, instance_index)
end
