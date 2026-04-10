extends Control

@onready var buttons = %Buttons
@onready var confirm: AudioStreamPlayer = %Confirm
@onready var back: AudioStreamPlayer = %Back
@onready var menu_canvas = get_parent()

func _ready():
	for button: Button in buttons.get_children():
		button.mouse_entered.connect(func(): if not has_focus(): button.grab_focus())
		button.pressed.connect(func(): confirm.play())
	
	visibility_changed.connect(set_first_button_focus)
	set_first_button_focus()

func set_first_button_focus():
	if not visible: return
	# set the first button as the focused one (mainly for controller)
	var first_button: Button = buttons.get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false

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
