extends Item

func on_pick_up(_player):
	super.on_pick_up(_player)
	
	if existing_item: # stack the item if it already exists
		return
	
	print("hi")
	
	_player.stats.multiply_stat("Fire_Rate", 1.5)
	_player.stats.add_percent_stat("Move_Speed", 20)
	_player.stats.add_percent_stat("Speed", 25)

func on_stack():
	player.stats.add_multiplier_stat("Fire_Rate", 0.5)
	player.stats.add_percent_stat("Move_Speed", 10)
	player.stats.add_percent_stat("Speed", 15)
