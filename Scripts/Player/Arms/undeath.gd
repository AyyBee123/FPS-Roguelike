extends Arm

func shoot():
	if t >= fire_rate_timer:
		%AtomicBlast.pitch_scale = randf_range(1.25, 1.5)
	super.shoot()

func set_projectile_flags(proj):
	proj.damage = damage
	proj.radius = range
	proj.player = player
	proj.color = "ffd73a"

func _on_animation_player_animation_finished(_anim_name):
	animation_player.play("Idle")
