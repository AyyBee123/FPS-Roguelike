extends Area3D

@export var TICK_RATE: float = 0.04

@onready var collision_shape = %CollisionShape3D
@onready var lifetime = %Lifetime

var damage: float
var speed: float
var range: float

var direction: Vector3

var t: float = 0.0

func _ready():
	t = randf_range(TICK_RATE / 2, TICK_RATE)
	lifetime.wait_time = range / speed
	lifetime.start()

func _physics_process(delta):
	t += delta
	if t >= TICK_RATE:
		t = 0.0
		global_position += direction * speed * delta

func _on_body_entered(body):
	if body is Player:
		body.hit(damage, global_position)
	queue_free()

func _on_timer_timeout():
	queue_free()
