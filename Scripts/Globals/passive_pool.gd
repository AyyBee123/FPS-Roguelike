extends Node

var passives: Array = [
	preload("uid://ck8e0xlkfeop6"),
	preload("uid://dw041uajaa1gg"),
	preload("uid://blf4j31no8f3d"),
	preload("uid://dflfd00x2j2is"),
	preload("uid://cc872qe0bk4b"),
	preload("uid://dpjreq5jo01gb"),
	preload("uid://b3u2c1s6odbpb"),
	preload("uid://cm6salthujj5t"),
	preload("uid://benqet3fkm7n6")
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
