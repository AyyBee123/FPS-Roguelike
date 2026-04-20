extends Arm

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t >= fire_rate_timer or ignore_fire_rate:
		%AtomicBlast.pitch_scale = randf_range(1.25, 1.5)
	super.shoot(ignore_fire_rate, outside_source)

func set_projectile_flags(proj):
	proj.damage = damage
	proj.radius = range
	proj.player = player
	proj.color = "ffd73a"

func _on_animation_player_animation_finished(_anim_name):
	animation_player.play("Idle")
