extends Button

@export var menu: Control

@onready var amount = $Amount
@onready var coin_amount = $"HBoxContainer/Coin Amount"

const COIN_AMOUNT: int = 25

var player: Player

func _ready():
	player = menu.player
	amount.text = "x%d" % player.skip_amount
	coin_amount.text = "+%d" % COIN_AMOUNT
	mouse_entered.connect(func(): if not has_focus(): grab_focus())

func _physics_process(_delta):
	visible = player.skip_amount > 0
	disabled = not visible
	amount.text = "x%d" % player.skip_amount

func _on_pressed():
	Globals.sfx.confirm.play_deconflicted()
	menu.is_banishing = false
	player.skip_amount -= 1
	player.coin_count += COIN_AMOUNT # * player.coin_multiplier, add later
	get_tree().paused = false
	menu.queue_free()
