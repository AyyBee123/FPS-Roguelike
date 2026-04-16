extends Ability

@export var AURA: PackedScene

func _on_shoot(projectile: Variant, damage: float):
	create_aura(projectile, damage)

func _on_spawn(projectile: Variant, damage: float):
	create_aura(projectile, damage)

func create_aura(projectile: Variant, damage: float):
	if projectile.get_node_or_null("Circle of Light Aura"):
		var _aura = projectile.get_node("Circle of Light Aura")
		_aura.damage = get_stat_value("Damage", damage)
		_aura.scale = Vector3.ONE * get_stat_value("Splash_Radius", player.weapons_manager.current_arm.splash_radius) / projectile.scale
		return
	var aura = AURA.instantiate()
	aura.visible = false
	aura.damage = get_stat_value("Damage", damage)
	aura.scale = Vector3.ONE * get_stat_value("Splash_Radius", player.weapons_manager.current_arm.splash_radius) / projectile.scale
	aura.player = player
	projectile.add_child(aura)
	aura.visible = true
