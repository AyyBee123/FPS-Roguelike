extends Item

var chance: float = 0.1
var chance_increase: float = 0.1
var base_chance: float = chance

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	if _source == self: return
	if randf() <= chance:
		if _enemy:
			_enemy.hit(_damage, player, self)

func on_stack():
	chance += chance_increase

func on_stack_remove():
	chance -= chance_increase

func set_detailed_desription():
	detailed_description %= [
		base_chance * 100,
		chance_increase * 100
	]
