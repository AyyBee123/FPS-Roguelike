extends "res://Scripts/Enemies/enemy.gd"

const CACTORSE = preload("uid://duegs3ndgtxbj")

func _ready():
	for lib_name in animation_player.get_animation_library_list():
		animation_player.remove_animation_library(lib_name)
	
	animation_player.add_animation_library("default", CACTORSE)
