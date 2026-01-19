extends RigidBody3D

@export var IMPACT: PackedScene = preload("uid://mhyvno5adlsw")
@export var spawn_impact: bool = true
@export var impact_color: Color = Color.WHITE
@export_range(0, 4) var impact_size: float = 1.0

@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var lifetime: Timer = %Lifetime

var damage: float
var speed: float
var range: float
var radius: float

var player: Player

func _ready():
	lifetime.timeout.connect(_on_timer_timeout)
	lifetime.wait_time = range / speed
	lifetime.start()

func _on_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
	if spawn_impact:
		create_impact()
	queue_free()

func create_impact():
	var impact = IMPACT.instantiate()
	impact.position = position
	impact.color = impact_color
	get_tree().current_scene.add_child(impact)

func _on_timer_timeout():
	queue_free()
