extends "res://Scripts/UI/button.gd"

@export var character_select: Control

func _input(event):
	if not character_select.visible: return
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index == JOY_BUTTON_START:
			_on_pressed()

func _on_pressed():
	Globals.sfx.button_confirm.play()
	character_select.visible = false
	character_select.menu_canvas.show_only(character_select.menu_canvas.level_select)
