extends CanvasLayer

var menus: Array[Control] = []

@onready var main_menu = %Menu
@onready var character_select = %"Character Select"
@onready var level_select = %"Level Select"

func _ready():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	get_tree().paused = false
	menus = [main_menu, character_select, level_select]
	for menu in menus:
		menu.visibility_changed.connect(_on_visibility_changed.bind(menu))
	show_only(main_menu)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventJoypadMotion and abs(event.axis_value) > Settings.deadzone:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_visibility_changed(menu):
	if menu.visible:
		show_only(menu)

func show_only(node):
	for menu in menus:
		menu.visible = menu == node
