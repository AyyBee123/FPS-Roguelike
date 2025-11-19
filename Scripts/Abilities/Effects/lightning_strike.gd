extends Ability

const LIGHTNING = preload("uid://ion0xy4nx46o")

const DAMAGE_MULTIPLIER: float = 0.5

var damage_increase: float = 0.0
var radius_increase: float = 0.0

func _on_hit(source: Variant, enemy: Enemy = null, damage: float = 0):
	if not enemy or source.is_in_group("Lightning Strike"): return
	
	var lightning = LIGHTNING.instantiate()
	lightning.position = enemy.position
	lightning.damage = damage * DAMAGE_MULTIPLIER * (1 + damage_increase)
	lightning.scale = Vector3.ONE * (1 + radius_increase)
	get_tree().current_scene.add_child(lightning)
