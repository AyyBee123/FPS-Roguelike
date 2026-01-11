extends Item

@onready var fire_rate = %"Fire Rate"

const FIRE_DELAY_MULTIPLIER: float = 4.0

var chance: float = 0.1
var arm: Arm

func _ready():
	super._ready()
	randomize()

func on_weapon_shot(_arm: Arm, _source: Variant):
	if _source == self: return
	arm = _arm
	if randf() <= chance:
		if fire_rate.is_stopped():
			fire_rate.start(1.0 / (_arm.fire_rate * FIRE_DELAY_MULTIPLIER))

func on_stack():
	chance = clamp(chance + 0.1, 0, 1)

func _on_fire_rate_timeout():
	arm.shoot(true, self)
