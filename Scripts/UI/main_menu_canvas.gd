extends CanvasLayer

var menus: Array[Control] = []

@onready var main_menu = %Menu
@onready var character_select = %"Character Select"
@onready var level_select = %"Level Select"

func _ready():
	get_tree().paused = false
	menus = [main_menu, character_select, level_select]
	for menu in menus:
		menu.visibility_changed.connect(_on_visibility_changed.bind(menu))
	show_only(main_menu)

func _on_visibility_changed(menu):
	if menu.visible:
		show_only(menu)

func show_only(node):
	for menu in menus:
		menu.visible = menu == node
