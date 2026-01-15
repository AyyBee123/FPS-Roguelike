extends Item

var jumps: float = 5
var jumps_increase: float = 2
var gravity: float = 0.667

func on_pick_up(_player: Player):
	super.on_pick_up(_player)
	
	if existing_item: # stack the item if it already exists
		return
	
	_player.stats.add_flat_stat("Extra_Jumps", jumps)
	_player.stats.multiply_stat("Fall_Speed", gravity)

func on_stack():
	player.stats.add_flat_stat("Extra_Jumps", jumps_increase)

func set_detailed_desription():
	detailed_description %= [
		jumps,
		jumps_increase,
		String.num(gravity)
	]
