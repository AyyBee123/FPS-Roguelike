extends HBoxContainer

@export var player: Player
@onready var label = $Label

var amount: float
var tween: Tween

func _ready():
	amount = player.coin_count
	player.coin_count_changed.connect(update_coin_count)

func _physics_process(delta):
	label.text = str(int(amount))

func update_coin_count(_amount: float):
	var difference: float = abs(_amount - amount)
	tween = get_tree().create_tween()
	tween.tween_property(self, "amount", _amount, clamp(difference / 100, 0.01, 1)) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
