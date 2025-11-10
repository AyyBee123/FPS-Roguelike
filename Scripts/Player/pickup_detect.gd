extends Area3D

@export var player: Player

func _on_area_entered(area):
	if area.is_in_group("XP"):
		area.player = player
