extends Ability

@export var AURA: PackedScene

const DAMAGE_MULTIPLIER: float = 0.333

func _on_shoot(projectile: Variant, damage: float):
	create_aura(projectile, damage)

func _on_spawn(projectile: Variant, damage: float):
	create_aura(projectile, damage)

func create_aura(projectile: Variant, damage: float):
	if projectile.get_node_or_null("Circle of Light Aura"): return
	var aura = AURA.instantiate()
	aura.visible = false
	aura.damage = get_stat_value("Damage", damage * DAMAGE_MULTIPLIER)
	aura.scale = Vector3.ONE * get_stat_value("Splash_Radius") / projectile.scale
	aura.player = player
	projectile.add_child(aura)
	aura.visible = true
