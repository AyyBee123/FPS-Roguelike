extends Node

var passives: Array = [
	preload("uid://ck8e0xlkfeop6"),
	preload("uid://dw041uajaa1gg"),
	
]

func _ready():
	randomize()

func get_stat(passive_to_not_pick: Passive = null):
	var passive: Passive = passives.pick_random().instantiate()
	if passive_to_not_pick:
		if passive.stat_name == passive_to_not_pick.stat_name:
			passive.queue_free()
			return get_stat(passive_to_not_pick)
	return passive
