extends Arm

@export var big_projectile: PackedScene

@onready var base_projectile: PackedScene = projectile
@onready var rec: Vector2 = recoil

const NUMBER_TO_BIG_SHOT: int = 5 # number of shots to reach big shot

var current_shot: int = 0

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	if current_shot < NUMBER_TO_BIG_SHOT - 1:
		current_shot += 1
		shoot_animation = "Shoot"
		projectile = base_projectile
		recoil = rec
		if firing_audio.has(%"Leaper Big Laser"):
			firing_audio.erase(%"Leaper Big Laser")
		super.shoot(ignore_fire_rate, outside_source)
	else:
		current_shot = 0
		shoot_animation = "Big Shoot"
		projectile = big_projectile
		recoil = rec * 3
		if not firing_audio.has(%"Leaper Big Laser"):
			firing_audio.append(%"Leaper Big Laser")
		super.shoot(ignore_fire_rate, outside_source)
