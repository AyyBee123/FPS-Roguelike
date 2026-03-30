extends Button

@export var menu: Control

@onready var amount = $Amount

var player: Player

func _ready():
	player = menu.player
	amount.text = "x%d" % player.reroll_amount
	mouse_entered.connect(func(): if not has_focus(): grab_focus())
	focus_exited.connect(func(): if player.reroll_amount <= 0: menu.upgrade_list.get_children()[2].grab_focus())

func _physics_process(delta):
	visible = player.reroll_amount > 0
	disabled = not visible
	amount.text = "x%d" % player.reroll_amount

func _on_pressed():
	menu.current_list.clear()
	for upgrade in menu.upgrade_list.get_children():
		upgrade.roll()
	player.reroll_amount -= 1
