extends Node

var passives: Array[PackedScene]
var json_file: String = "res://Data/passive_pool.json"

func _init():
	populate_pool()

func populate_pool():
	var loader = PoolLoader.new()
	loader.load_pool(json_file, passives)

func get_stat(passive_to_not_pick: Passive = null):
	var passive: Passive = passives.pick_random().instantiate()
	if passive_to_not_pick:
		if passive.stat_name == passive_to_not_pick.stat_name:
			passive.queue_free()
			return get_stat(passive_to_not_pick)
	return passive
