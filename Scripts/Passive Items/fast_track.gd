extends Item

var fire_rate: float = 30
var move_speed: float = 20
var speed: float = 25

var fire_rate_increase: float = 20
var move_speed_increase: float = 10
var speed_increase: float = 15

func on_pick_up(_player):
	super.on_pick_up(_player)
	
	if existing_item: # stack the item if it already exists
		return
	
	_player.stats.add_percent_stat("Fire_Rate", fire_rate)
	_player.stats.add_percent_stat("Move_Speed", move_speed)
	_player.stats.add_percent_stat("Speed", speed)

func on_stack():
	player.stats.add_percent_stat("Fire_Rate", fire_rate_increase)
	player.stats.add_percent_stat("Move_Speed", move_speed_increase)
	player.stats.add_percent_stat("Speed", speed_increase)

func set_detailed_desription():
	detailed_description %= [
		fire_rate,
		fire_rate_increase,
		move_speed,
		move_speed_increase,
		speed,
		speed_increase
	]
