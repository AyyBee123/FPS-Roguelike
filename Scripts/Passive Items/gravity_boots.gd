extends "res://Scripts/Passive Items/Base/base_passive_item.gd"

func on_pick_up(player):
	player.stats.add_flat_amount("Extra_Jumps", 5)
	player.stats.multiply_stat("Fall_Speed", 0.67)
