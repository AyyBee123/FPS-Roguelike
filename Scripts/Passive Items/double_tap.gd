extends Item

const FIRE_DELAY_MULTIPLIER: float = 4.0

var chance: float = 0.1
var chance_increase: float = 0.1

func _ready():
	super._ready()
	randomize()

func on_weapon_shot(_arm: Arm, _source: Variant):
	if _source == self: return
	if randf() <= chance:
		await get_tree().create_timer(1.0 / (_arm.fire_rate * FIRE_DELAY_MULTIPLIER)).timeout
		_arm.shoot(true, self)

func on_stack():
	chance = clamp(chance + chance_increase, 0, 1)

func set_detailed_desription():
	detailed_description %= [
		chance * 100,
		chance_increase * 100
	]
