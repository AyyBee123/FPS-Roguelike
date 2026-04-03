extends Item

var dash_charges: int = 1
var move_speed: float = 10

var dash_charge_increase: int = 1
var move_speed_increase: float = 10

func on_first_stack():
	player.stats.add_flat_stat("Dashes", dash_charges)
	player.stats.add_percent_stat("Move_Speed", move_speed)

func on_stack():
	player.stats.add_flat_stat("Dashes", dash_charge_increase)
	player.stats.add_percent_stat("Move_Speed", move_speed_increase)

func on_remove():
	player.stats.add_flat_stat("Dashes", -dash_charges)
	player.stats.add_percent_stat("Move_Speed", -move_speed)

func on_stack_remove():
	player.stats.add_flat_stat("Dashes", -dash_charge_increase)
	player.stats.add_percent_stat("Move_Speed", -move_speed_increase)

func set_detailed_desription():
	detailed_description %= [
		move_speed,
		move_speed_increase,
		dash_charges,
		dash_charge_increase,
	]
