extends Control

signal upgrade_selected(upgrade)

@onready var scalable_ui = %Scale
@onready var transition = %Transition
@onready var upgrade_list = %"Upgrade List"
@onready var buffer = $Buffer

var tween: Tween
var player: Player
var current_list: Array = [] # the current list of passive and ability upgrades

func _ready():
	get_tree().paused = true
	
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
	if tween.is_running() or not buffer.is_stopped(): return
	
	get_tree().paused = false
	if button.passives.size() > 0:
		upgrade_selected.emit(button.passives)
	else:
		upgrade_selected.emit(button.ability)
	queue_free()
