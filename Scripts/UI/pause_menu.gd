extends Control

@export var player: Player

@onready var buttons = %Buttons
@onready var confirm: AudioStreamPlayer = %Confirm
@onready var back: AudioStreamPlayer = %Back
@onready var pause: AudioStreamPlayer = %Pause
@onready var unpause: AudioStreamPlayer = %Unpause

var is_pause_menu_open: bool = false
var is_changing_scene: bool = false

func _ready():
	visible = false
	
	for button: Button in buttons.get_children():
		button.mouse_entered.connect(func(): if not has_focus(): button.grab_focus())
		button.pressed.connect(func(): confirm.play())

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if is_pause_menu_open:
			close_pause_menu()
		elif not get_tree().paused and not player.is_dead: # only open if nothing else paused the game and the player is still alive
			open_pause_menu()

func open_pause_menu() -> void:
	is_pause_menu_open = true
	get_tree().paused = true
	visible = true
	
	# set the first button as the focused one (mainly for controller)
	var first_button = buttons.get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false
	
	pause.play()

func close_pause_menu() -> void:
	is_pause_menu_open = false
	get_tree().paused = false
	visible = false
	
	unpause.play()

func _on_resume_pressed():
	close_pause_menu()

func _on_restart_pressed():
	disable_buttons()
	await confirm.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_settings_pressed():
	pass

func _on_quit_to_menu_pressed():
	disable_buttons()
	await confirm.finished

func _on_quit_to_desktop_pressed():
	disable_buttons()
	await confirm.finished
	get_tree().quit()

func disable_buttons():
	for button: Button in buttons.get_children():
		button.disabled = true
