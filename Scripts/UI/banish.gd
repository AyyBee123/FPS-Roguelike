extends Button

@export var menu: Control

@onready var amount = $Amount

var player: Player

func _ready():
	player = menu.player
	amount.text = "x%d" % player.banish_amount
	mouse_entered.connect(func(): if not has_focus(): grab_focus())
	focus_exited.connect(func(): if player.banish_amount <= 0: menu.upgrade_list.get_children()[2].grab_focus())

func _physics_process(delta):
	visible = player.banish_amount > 0
	disabled = not visible
	amount.text = "x%d" % player.banish_amount

func _on_pressed():
	menu.is_banishing = not menu.is_banishing

func banish(button):
	if button.ability:
		var pool = get_tree().current_scene.ability_pool.abilities
		var idx = pool.find_custom(func(packed): 
			return packed.resource_path == button.ability.scene_file_path
		)
		if idx != -1:
			pool.remove_at(idx)
	elif button.passives.size() > 0:
		var pool = get_tree().current_scene.passive_pool.passives
		var idx = pool.find_custom(func(packed): 
			return packed.resource_path == button.passives[0].scene_file_path
		)
		if idx != -1:
			pool.remove_at(idx)
	button.roll()
	menu.is_banishing = false
	player.banish_amount -= 1
