extends Ability

@export var AURA: PackedScene

const DAMAGE_MULTIPLIER: float = 0.75

func _on_shoot(projectile: Variant, damage: float):
	var aura = AURA.instantiate()
	aura.damage = get_stat_value("Damage", damage * DAMAGE_MULTIPLIER)
	aura.scale /= projectile.scale
	aura.scale = Vector3.ONE * get_stat_value("Size")
	aura.player = player
	projectile.add_child(aura)
