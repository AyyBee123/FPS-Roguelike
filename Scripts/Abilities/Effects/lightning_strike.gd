extends Ability

const LIGHTNING = preload("uid://ion0xy4nx46o")

const DAMAGE_MULTIPLIER: float = 0.5

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	if not enemy or source.is_in_group("Lightning Strike"): return
	var lightning = LIGHTNING.instantiate()
	lightning.position = enemy.position
	lightning.damage = get_stat_value("Damage", damage * DAMAGE_MULTIPLIER)
	lightning.scale = Vector3.ONE * get_stat_value("Size")
	lightning.player = player
	get_tree().current_scene.add_child(lightning)
