extends Item

func on_pick_up(_player: Player):
	super.on_pick_up(_player)
	
	if player.get_node_or_null("%Passives/" + name): # stack the item if it already exists
		return
	
	_player.stats.add_flat_stat("Extra_Jumps", 5)
	_player.stats.multiply_stat("Fall_Speed", 0.67)

func on_stack():
	player.stats.add_flat_stat("Extra_Jumps", 2)
