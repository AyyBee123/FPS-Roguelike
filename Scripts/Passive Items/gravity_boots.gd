extends Item

var jumps: float = 3
var jumps_increase: float = 1
var gravity: float = 0.67

func on_first_stack():
	player.stats.add_flat_stat("Extra_Jumps", jumps)
	player.stats.multiply_stat("Fall_Speed", gravity)

func on_stack():
	player.stats.add_flat_stat("Extra_Jumps", jumps_increase)

func on_remove():
	player.stats.add_flat_stat("Extra_Jumps", -jumps)
	player.stats.multiply_stat("Fall_Speed", 1.0/gravity)

func on_stack_remove():
	player.stats.add_flat_stat("Extra_Jumps", -jumps_increase)

func set_detailed_desription():
	detailed_description %= [
		jumps,
		jumps_increase,
		roundi(100 * (1 - gravity))
	]
