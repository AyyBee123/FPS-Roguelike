extends Ability

const MICRO_MISSILE = preload("uid://c8solqmwcm8ub")

const DAMAGE_MULTIPLIER: float = 0.5

func _on_shoot(projectile: Variant, damage: float):
	if projectile.is_in_group("Micro Missile"): return
	
	var missile = MICRO_MISSILE.instantiate()
	missile.damage = get_stat_value("Damage", damage * DAMAGE_MULTIPLIER)
	missile.scale = Vector3.ONE * get_stat_value("Size")
	missile.speed = stats["Speed"]["base"]
	missile.player = player
	get_tree().current_scene.add_child(missile)
	player._on_arm_fired(missile, missile.damage)
	missile.global_position = player.get_arm().bullet_point.global_position + Vector3(0, 0.5, 0)
	missile.set_linear_velocity(Vector3.UP * get_stat_value("Speed"))
