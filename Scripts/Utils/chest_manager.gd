extends Node

@onready var level = get_parent() as Level

const CHEST = preload("uid://cml3a2ykki6lr")

func spawn_chests():
	for i in range(level.NUMBER_OF_CHESTS):
		var chest = CHEST.instantiate()
		chest.position = level.find_chest_spawn()
		level.add_child(chest)

func _on_timer_timeout():
	spawn_chests()
