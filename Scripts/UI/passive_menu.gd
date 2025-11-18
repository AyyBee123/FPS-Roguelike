extends Control

signal upgrade_selected(upgrade)

@onready var scalable_ui = %Scale
@onready var transition = %Transition
@onready var upgrade_list = %"Upgrade List"

var base_resolution = Vector2(1920, 1080)
var tween: Tween

func _ready():
	get_tree().paused = true
	
	# set the menu size to match the window size
	get_viewport().size_changed.connect(_on_resize)
	_on_resize()
	
	# set the first button as the focused one (mainly for controller)
	var first_button = %"Upgrade List".get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false
	
	for button in upgrade_list.get_children():
		button.pressed.connect(select_upgrade.bind(button))
	
	transition.scale = Vector2.ZERO
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition, "scale", Vector2.ONE, 0.15)

func select_upgrade(button):
	if tween.is_running(): return
	
	get_tree().paused = false
	upgrade_selected.emit(button.passives)
	queue_free()

func _on_resize():
	var res = get_viewport().get_visible_rect().size
	var scale_factor = res.y / base_resolution.y
	scale_factor = clamp(scale_factor, 0.35, 1.75)
	scalable_ui.global_position = Vector2(res.x / 2, res.y / 2)
	scalable_ui.scale = Vector2(scale_factor, scale_factor)
