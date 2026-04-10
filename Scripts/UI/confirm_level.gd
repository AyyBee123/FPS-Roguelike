extends "res://Scripts/UI/button.gd"

@export var level_select: Control

func _input(event):
	if not level_select.visible: return
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index  == JOY_BUTTON_START:
			_on_pressed()

func _on_pressed():
	Globals.sfx.button_confirm.play()
	level_select.visible = false
	await Globals.sfx.button_confirm.finished
	get_tree().change_scene_to_packed(GameState.selected_level)
