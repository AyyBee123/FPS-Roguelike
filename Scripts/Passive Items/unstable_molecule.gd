extends Item

@export var BLAST: PackedScene

func on_enemy_killed(_enemy: Enemy, _source: Variant, _damage: float):
	var blast = BLAST.instantiate()
	blast.player = player
	blast.damage = get_stat_value("Damage")
	blast.radius = get_stat_value("Splash_Radius")
	get_tree().current_scene.add_child(blast)
	blast.global_position = _enemy.global_position

func on_stack():
	add_percent_stat("Damage", 20)
	add_percent_stat("Splash_Radius", 25)
