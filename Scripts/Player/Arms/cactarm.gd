extends Arm

@onready var cactarm_shot = %"Cactarm Shot"
@onready var cactarm_shotgun = %"Cactarm Shotgun"
@onready var release_timer = %"Release Timer"

const NUMBER_OF_SPREAD_SHOTS: int = 8

var released: bool = true

@onready var original_range: float = base_range
@onready var original_fire_rate: float = base_fire_rate

func _input(event):
	if Input.is_action_pressed("shoot"):
		released = false
	if not released and not Input.is_action_pressed("shoot"):
		released = true

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if not release_timer.is_stopped(): return
	if not released:
		base_projectile_count = 1
		base_range = original_range
		spread = 0
		if not firing_audio.has(cactarm_shot):
			firing_audio.clear()
			firing_audio.append(cactarm_shot)
		super.shoot(ignore_fire_rate, outside_source)
	else:
		base_projectile_count = 8
		base_range = original_range / 2
		spread = 16
		if not firing_audio.has(cactarm_shotgun):
			firing_audio.clear()
			firing_audio.append(cactarm_shotgun)
		super.shoot(true, outside_source)
		release_timer.start(1.0 / fire_rate * 4)

func release(outside_source: Variant = self):
	super.release(outside_source)
	shoot(true, self)
