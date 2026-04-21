extends Ability

@export var CLOUD: PackedScene

@onready var cooldown = %Cooldown

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	if not cooldown.is_stopped(): return
	if not enemy or source.is_in_group("Venom Cloud"): return
	var cloud = CLOUD.instantiate()
	cloud.visible = false
	cloud.position = enemy.position
	cloud.damage = get_stat_value("Damage", damage)
	cloud.size = get_stat_value("Range")
	cloud.player = player
	get_tree().current_scene.add_child(cloud)
	cloud.visible = true
	cooldown.start()
