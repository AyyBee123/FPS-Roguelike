extends Arm

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t >= fire_rate_timer or ignore_fire_rate:
		%AtomicBlast.pitch_scale = randf_range(1.25, 1.5)
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
	proj.range = range
	proj.radius = splash_radius
	proj.player = player
	proj.color = "ffd73a"
	
	Utils.copy_groups(self, proj)
	
	get_tree().current_scene.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	proj.global_transform.origin = bullet_point.global_transform.origin

func _on_animation_player_animation_finished(anim_name):
	animation_player.play("Idle")
