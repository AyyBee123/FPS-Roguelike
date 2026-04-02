extends Node3D

@export var level_name: String

func _ready():
	await get_tree().create_timer(0.5).timeout
	var path: String = "res://Assets/Screenshots/" + level_name + ".png"
	get_viewport().get_texture().get_image().save_png(path)
	print("Screenshot saved at " + path)
