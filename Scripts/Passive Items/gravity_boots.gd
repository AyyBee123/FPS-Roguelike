extends Item

func on_pick_up(player):
	player.stats.add_flat_stat("Extra_Jumps", 5)
	player.stats.multiply_stat("Fall_Speed", 0.67)
