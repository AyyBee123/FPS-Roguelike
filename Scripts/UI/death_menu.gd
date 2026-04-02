extends Control

@export var player: Player

@onready var buttons = %Buttons
@onready var confirm: AudioStreamPlayer = %Confirm

var is_pause_menu_open: bool = false

func _ready():
	visible = false
	
	for button: Button in buttons.get_children():
		button.mouse_entered.connect(func(): if not has_focus(): grab_focus())
		button.pressed.connect(func(): confirm.play(); disable_buttons())

func open_death_menu() -> void:
	is_pause_menu_open = true
	get_tree().paused = true
	visible = true
	
	# set the first button as the focused one (mainly for controller)
	var first_button = buttons.get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false

func disable_buttons():
	for button: Button in buttons.get_children():
		button.disabled = true

func _on_restart_pressed():
	await confirm.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_to_menu_pressed():
	await confirm.finished

func _on_quit_to_desktop_pressed():
	await confirm.finished
	get_tree().quit()
