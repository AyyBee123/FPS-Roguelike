extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var oil_pool: PackedScene

func _on_body_entered(body):
	var pool = oil_pool.instantiate()
	pool.damage = damage
	pool.player = player
	pool.position = position
	
	Utils.copy_groups(self, pool)
	
	get_tree().current_scene.add_child(pool)
	player._on_weapon_spawned(pool, damage)
	super._on_body_entered(body)
