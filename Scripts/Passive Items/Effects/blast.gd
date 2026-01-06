extends Node3D

@onready var collision_shape = %CollisionShape3D

var player: Player
var damage: float
var radius: float

func _ready():
	collision_shape.shape.radius = radius
	await get_tree().create_timer(0.25).timeout
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
