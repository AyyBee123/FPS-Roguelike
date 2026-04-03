extends Item

var fire_rate: float = 30

var speed: float = 25

var fire_rate_increase: float = 20

var speed_increase: float = 15

func on_first_stack():
	player.stats.add_percent_stat("Fire_Rate", fire_rate)
	player.stats.add_percent_stat("Speed", speed)

func on_stack():
	player.stats.add_percent_stat("Fire_Rate", fire_rate_increase)
	player.stats.add_percent_stat("Speed", speed_increase)

func on_remove():
	player.stats.add_percent_stat("Fire_Rate", -fire_rate)
	player.stats.add_percent_stat("Speed", -speed)

func on_stack_remove():
	player.stats.add_percent_stat("Fire_Rate", -fire_rate_increase)
	player.stats.add_percent_stat("Speed", -speed_increase)

func set_detailed_desription():
	detailed_description %= [
		fire_rate,
		fire_rate_increase,
		speed,
		speed_increase
	]
