extends Area3D

func _on_area_entered(area):
	if area.is_in_group("XP"):
		area.player = get_parent()
