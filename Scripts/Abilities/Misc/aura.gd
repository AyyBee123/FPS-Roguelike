extends Node3D

var damage: float

var player: Player

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
