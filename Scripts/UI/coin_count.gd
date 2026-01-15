extends HBoxContainer

@export var player: Player
@onready var label = $Label

func _ready():
	player.coin_count_changed.connect(update_coin_count)

func update_coin_count(amount: int):
	label.text = str(amount)
