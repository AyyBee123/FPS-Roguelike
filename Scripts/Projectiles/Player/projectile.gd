extends RigidBody3D

@onready var collision_shape = %CollisionShape
@onready var lifetime = %Lifetime

var damage: float
var speed: float
var range: float

var player: Player

func _ready():
	lifetime.wait_time = range / speed
	lifetime.start()

func _on_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
		player._on_enemy_hit(body, self, damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
