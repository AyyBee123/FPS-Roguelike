extends Node

@onready var level = get_parent() as Level

const CHEST = preload("uid://cml3a2ykki6lr")
const ARMORY_BOX = preload("uid://ctxgapymf2x0l")

func spawn_chests():
	for i in range(level.NUMBER_OF_CHESTS):
		var chest = CHEST.instantiate()
		chest.position = level.find_chest_spawn()
		level.add_child(chest)
		await get_tree().physics_frame

func spawn_armory_boxes():
	for i in range(level.NUMBER_OF_ARMORY_BOXES):
		var armory_box = ARMORY_BOX.instantiate()
		armory_box.position = level.find_chest_spawn()
		level.add_child(armory_box)
		await get_tree().physics_frame

func _on_timer_timeout():
	spawn_chests()
	spawn_armory_boxes()
