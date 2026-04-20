extends Ability

@export var LIGHTNING: PackedScene

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	if not enemy or source.is_in_group("Lightning Strike"): return
	var lightning = LIGHTNING.instantiate()
	lightning.visible = false
	lightning.position = enemy.position
	lightning.damage = get_stat_value("Damage", damage)
	lightning.size = get_stat_value("Splash_Radius")
	lightning.player = player
	get_tree().current_scene.add_child(lightning)
	lightning.visible = true
