extends Arm

const NUMBER_TO_BIG_SHOT: int = 5 # number of shots to reach big shot

var current_shot: int = 0
var is_big_shot: bool = false

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
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

func launch_projectile(point: Vector3):
	if not projectile: return
	
	var spread_rad: float = deg_to_rad(spread)
	var direction = (point - bullet_point.get_global_transform().origin).normalized()
	var proj = projectile.instantiate()
	
	# get random angle in a uniform distribution
	var cos_angle = lerp(cos(spread_rad), 1.0, randf())
	var angle = acos(cos_angle)
	
	# get a random perpendicular axis
	var perp = direction.cross(Vector3.UP)
	if perp.length() < 0.001:
		perp = direction.cross(Vector3.RIGHT)
	perp = perp.rotated(direction, randf() * TAU).normalized()
	
	direction = direction.rotated(perp, angle)
	
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.radius = splash_radius
	proj.player = player
	proj.is_big_shot = is_big_shot
	
	Utils.copy_groups(self, proj)
	
	get_tree().current_scene.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	proj.global_transform.origin = bullet_point.global_transform.origin
	proj.look_at(proj.global_transform.origin + direction, Vector3.UP)
	proj.set_linear_velocity(direction * speed)
