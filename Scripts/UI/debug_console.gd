extends Control

@onready var log = %Log
@onready var command = %Command

@onready var arm_pool = %"Arm Pool"
@onready var item_pool = %"Item Pool"
@onready var ability_pool = %"Ability Pool"

func _ready():
	visible = false
	visibility_changed.connect(_on_visibility_changed)

func _process(_delta):
	if visible:
		refocus()

func _input(event):
	if event is InputEventKey and event.pressed and OS.has_feature("editor") and \
			GameState.current_level == get_tree().current_scene:
		if event.keycode == KEY_QUOTELEFT:
			visible = not visible
			if visible:
				command.grab_focus()
			accept_event()
		if event.keycode == KEY_ENTER:
			if visible:
				execute_command()
			accept_event()
		if event.keycode == KEY_ESCAPE:
			if visible:
				visible = false
				accept_event()

func execute_command():
	ConsoleManager.execute(command.text)
	command.clear()
	visible = false
	await get_tree().physics_frame
	visible = true

func refocus():
	command.grab_focus()

func _on_visibility_changed():
	get_tree().paused = visible
	if visible:
		%Command.grab_focus()
		
		ConsoleManager.ui = self
		ConsoleManager.player = get_tree().get_first_node_in_group("Player")
		ConsoleManager.level = GameState.current_level
		
		ConsoleManager.item_pool = item_pool
		ConsoleManager.arm_pool = arm_pool
		ConsoleManager.ability_pool = ability_pool
		
		if ConsoleManager.enemies.is_empty():
			ConsoleManager.load_from_file("res://Scenes/Enemies/", ConsoleManager.enemies)
