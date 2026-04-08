extends Item

@export var BLAST: PackedScene

var damage_increase: float = 5
var radius_increase: float = 1

func on_enemy_killed(_enemy: Enemy, _source: Variant, _damage: float):
	if _source.is_in_group("Unstable Molecule Blast"): return
	var blast = BLAST.instantiate()
	blast.add_to_group("Unstable Molecule Blast")
	blast.player = player
	blast.damage = get_stat_value("Damage")
	blast.radius = get_stat_value("Splash_Radius")
	get_tree().current_scene.add_child(blast)
	blast.global_position = _enemy.global_position

func on_stack():
	add_flat_stat("Damage", damage_increase)
	add_flat_stat("Splash_Radius", radius_increase)

func on_stack_remove():
	add_flat_stat("Damage", -damage_increase)
	add_flat_stat("Splash_Radius", -radius_increase)

func set_detailed_desription():
	detailed_description %= [
		stats["Damage"]["base"],
		damage_increase,
		stats["Splash_Radius"]["base"],
		radius_increase
	]
