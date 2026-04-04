extends Button

@export var character_select: Control

func _on_pressed():
	Globals.sfx.button_confirm.play()
	character_select.visible = false
	character_select.menu_canvas.show_only(character_select.menu_canvas.level_select)
