extends Node

var abilities = [
	preload("uid://c2o7h4efocscc"),
	preload("uid://cdthgqjlxd3jl"),
]

func get_ability():
	var ability: Ability = abilities.pick_random().instantiate()
	return ability
