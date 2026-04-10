extends Control

signal upgrade_selected(upgrade)

@onready var scalable_ui = %Scale
@onready var transition = %Transition
@onready var upgrade_list = %"Upgrade List"
@onready var buffer = %Buffer
@onready var banish_background = %"Banish Background"

var tween: Tween
var player: Player
var current_list: Array = [] # the current list of passive and ability upgrades
var is_banishing: bool = false

func _ready():
	get_tree().paused = true
	
	Globals.sfx.level_up.play_deconflicted()
	
	set_buttons()
	
	transition.scale = Vector2.ZERO
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_interval(0.05)
	tween.tween_property(transition, "scale", Vector2.ONE, 0.15)

func _physics_process(_delta):
	get_tree().paused = true
	banish_background.visible = is_banishing

func set_buttons():
	# set the first button as the focused one (mainly for controller)
	var first_button = %"Upgrade List".get_child(0)
	first_button.initial_focus = true
	first_button.grab_focus()
	first_button.initial_focus = false
	
	for button in upgrade_list.get_children():
		button.pressed.connect(select_upgrade.bind(button))

func select_upgrade(button):
	if tween.is_running() or not buffer.is_stopped(): return
	
	if is_banishing:
		%Banish.banish(button)
		return
	
	Globals.sfx.confirm.play()
	
	set_physics_process(false)
	get_tree().paused = false
	if button.passives.size() > 0:
		upgrade_selected.emit(button.passives)
	else:
		upgrade_selected.emit(button.ability)
	queue_free()
