extends RigidBody3D

@onready var collision_shape = %CollisionShape3D
@onready var lifetime = %Lifetime

var damage: float
var speed: float
var range: float

func _ready():
	lifetime.wait_time = range / speed
	lifetime.start()

func _on_body_entered(body):
	if body is Player:
		body.hit(damage, global_position)
	queue_free()

func _on_timer_timeout():
	queue_free()
