extends Item

var chance: float = 0.2
var chance_increase: float = 0.08
var base_chance: float = chance

func on_level_up(_level: int, _source: Variant):
	if _source == self: return
	
	var procs: int = floor(chance) # get extra procs beyond 100%
	if randf() <= fmod(chance, 1.0): # get remainder as probability
		procs += 1
	
	for i in procs:
		await get_tree().physics_frame
		player.gain_xp(roundi(player.XP_NEEDED), self)

func on_stack():
	chance += chance_increase

func on_stack_remove():
	chance -= chance_increase

func set_detailed_desription():
	detailed_description %= [
		base_chance * 100,
		chance_increase * 100
	]
