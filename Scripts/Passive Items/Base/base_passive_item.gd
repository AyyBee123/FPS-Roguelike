class_name Item extends Node

@export_enum("COMMON", "UNCOMMON", "LEGENDARY", "UNSET:-1") var rarity: int = -1
@export var mesh: Mesh

func on_pick_up(player):
	pass
