extends Area3D

@export var player: Player
@onready var pickup_collision = %"Pickup Collision"

func _physics_process(delta):
	pickup_collision.shape.radius = player.PICKUP_RADIUS

func _on_area_entered(area):
	if area.is_in_group("XP"):
		area.player = player
