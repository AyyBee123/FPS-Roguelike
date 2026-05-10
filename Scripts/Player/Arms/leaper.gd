extends Arm

const NUMBER_TO_BIG_SHOT: int = 5 # number of shots to reach big shot

var current_shot: int = 0
var is_big_shot: bool = false

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	if not ignore_fire_rate:
		t = 0.0
	
	if current_shot < NUMBER_TO_BIG_SHOT - 1:
		current_shot += 1
		shoot_animation = "Shoot"
		recoil_multiplier = 1
		is_big_shot = false
		if firing_audio.has(%"Leaper Big Laser"):
			firing_audio.erase(%"Leaper Big Laser")
		super.shoot(ignore_fire_rate, outside_source)
	else:
		current_shot = 0
		shoot_animation = "Big Shoot"
		recoil_multiplier = 4
		is_big_shot = true
		if not firing_audio.has(%"Leaper Big Laser"):
			firing_audio.append(%"Leaper Big Laser")
		super.shoot(ignore_fire_rate, outside_source)

func set_projectile_flags(proj):
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.radius = splash_radius
	proj.player = player
	proj.is_big_shot = is_big_shot
