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
		if event.keycode == KEY_F1:
			visible = not visible
			if visible:
				command.grab_focus()
		if event.keycode == KEY_ENTER:
			if visible:
				execute_command()

func execute_command():
	ConsoleManager.execute(command.text)
	command.clear()

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
