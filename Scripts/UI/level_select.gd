extends Control

@onready var levels = %Levels
@onready var level_info = %"Level Info"
@onready var level_image = %"Level Image"
@onready var level_name = %"Level Name"
@onready var menu_canvas = get_parent()

var level_group = ButtonGroup.new()

func _ready():
	for level: Button in levels.get_children():
		level.button_group = level_group
		level.pressed.connect(set_level_info.bind(level))
	
	visibility_changed.connect(set_first_button_focus)
	set_first_button_focus()

func set_first_button_focus():
	# set the first button as the focused one (mainly for controller)
	var first_button: Button = levels.get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false
	first_button.button_pressed = true
	
	set_level_info(first_button)
	GameState.selected_level = first_button.level

func set_level_info(lvl):
	level_image.texture = lvl.image
	level_name.text = lvl.level_name

func _on_back_pressed():
	Globals.sfx.back.play()
	menu_canvas.show_only(menu_canvas.character_select)
