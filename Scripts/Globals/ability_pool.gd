extends Node

var abilities: Array[PackedScene]
var json_file: String = "res://Data/ability_pool.json"

func _init():
	populate_pool()

func populate_pool():
	var loader = PoolLoader.new()
	loader.load_pool(json_file, abilities)

func get_ability():
	var ability: Ability = abilities.pick_random().instantiate()
	return ability
