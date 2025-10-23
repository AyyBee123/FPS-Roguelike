extends "res://Scripts/Passive Items/Base/base_passive_item.gd"

func on_pick_up(player):
	player.NUMBER_OF_EXTRA_JUMPS += 5
	player.FALL_SPEED *= 0.67
