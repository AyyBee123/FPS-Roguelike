extends RigidBody3D

@export var IMPACT: PackedScene = preload("uid://mhyvno5adlsw")
@export var impact_color: Color = Color.WHITE
@export_range(0, 4) var impact_size: float = 1.0

@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var lifetime: Timer = %Lifetime

var damage: float
var speed: float
var range: float
var radius: float = 0.05

var player: Player

func _ready():
	lifetime.timeout.connect(_on_timer_timeout)
	lifetime.wait_time = range / speed
	lifetime.start()

func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
	else:
		create_impact()
	queue_free()

func create_impact():
	if not IMPACT: return
	var impact = IMPACT.instantiate()
	impact.position = position
	impact.color = impact_color
	impact.scale = Vector3.ONE * impact_size
	get_tree().current_scene.add_child(impact)

func _on_timer_timeout():
	queue_free()
