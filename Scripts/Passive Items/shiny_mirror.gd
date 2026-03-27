extends Item

const SHINY_MIRROR_BEAM = preload("uid://pvaicrxrjr3q")

var chance: float = 0.5
var chance_increase: float = 0.5
var base_chance: float = chance

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	if _source == self: return
	
	var procs: int = floor(chance) # get extra procs beyond 100%
	if randf() <= fmod(chance, 1.0): # get remainder as probability
		procs += 1
	
	var ignored: Array = [_enemy] # start by ignoring the enemy that was hit
	
	for i in procs:
		var target = get_closest_enemy(_enemy, ignored, get_stat_value("Range"))
		if target:
			var beam = SHINY_MIRROR_BEAM.instantiate()
			beam.position = _enemy.position
			beam.target = target
			beam.origin = _enemy
			get_tree().current_scene.add_child(beam)
			
			ignored.append(target)
			target.hit(_damage, player, self, false)

func on_stack():
	chance = chance + chance_increase

func set_detailed_desription():
	detailed_description %= [
		base_chance * 100,
		chance_increase * 100
	]

func get_closest_enemy(origin: Enemy, ignore: Array, max_range: float = INF) -> Enemy:
	var closest: Enemy = null
	var closest_dist = max_range
	for enemy in get_tree().current_scene.get_children():
		if not enemy is Enemy: continue
		if enemy in ignore: continue
		
		var dist = origin.global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy
	
	return closest
