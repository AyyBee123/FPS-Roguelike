extends "res://Scripts/UI/button.gd"

@export var level_select: Control

func _on_pressed():
	Globals.sfx.button_confirm.play()
	level_select.visible = false
	await Globals.sfx.button_confirm.finished
	get_tree().change_scene_to_packed(GameState.selected_level)
