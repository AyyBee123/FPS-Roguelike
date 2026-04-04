extends Control

@onready var buttons = %Buttons
@onready var confirm: AudioStreamPlayer = %Confirm
@onready var back: AudioStreamPlayer = %Back
@onready var menu_canvas = get_parent()

func _ready():
	for button: Button in buttons.get_children():
		button.mouse_entered.connect(func(): if not has_focus(): button.grab_focus())
		button.pressed.connect(func(): confirm.play())

func _on_play_pressed():
	menu_canvas.show_only(menu_canvas.character_select)

func _on_settings_pressed():
	pass

func _on_quit_to_desktop_pressed():
	await confirm.finished
	get_tree().quit()

func disable_buttons():
	for button: Button in buttons.get_children():
		button.disabled = true
