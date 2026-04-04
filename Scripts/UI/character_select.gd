extends Control

@onready var characters = %Characters
@onready var character_info = %"Character Info"
@onready var character_image = %"Character Image"
@onready var character_name = %"Character Name"
@onready var menu_canvas = get_parent()

var char_group = ButtonGroup.new()

func _ready():
	for character: Button in characters.get_children():
		character.button_group = char_group
		character.pressed.connect(set_character_info.bind(character))
	
	visibility_changed.connect(set_first_button_focus)
	set_first_button_focus()

func set_first_button_focus():
	# set the first button as the focused one (mainly for controller)
	var first_button: Button = characters.get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false
	first_button.button_pressed = true
	
	set_character_info(first_button)
	GameState.selected_character = first_button.character

func set_character_info(lvl):
	character_image.texture = lvl.char_image
	character_name.text = lvl.char_name

func _on_back_pressed():
	Globals.sfx.back.play()
	menu_canvas.show_only(menu_canvas.main_menu)
