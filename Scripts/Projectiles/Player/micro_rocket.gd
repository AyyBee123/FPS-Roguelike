extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var SOUNDBOARD: PackedScene

@onready var homing_buffer = %"Homing Buffer"

const ROTATION_SPEED_FACTOR: float = 2.0

var target: Enemy = null
var can_home: bool = false

func _ready():
	super._ready()
	homing_buffer.start(10.0 / speed)
	if homing_buffer.wait_time <= 0.05:
		_on_homing_buffer_timeout()
		homing_buffer.stop()

func _physics_process(delta):
	super._physics_process(delta)
	if target and can_home and has_line_of_sight(target):
		var desired_direction = (target.global_position - global_position).normalized() * speed
		linear_velocity = linear_velocity.lerp(desired_direction, speed / ROTATION_SPEED_FACTOR * delta)
		linear_velocity = linear_velocity.limit_length(speed * 0.333)
	elif not %Area3D.get_overlapping_bodies().is_empty() and %Area3D.get_overlapping_bodies()[0] is Enemy:
		target = %Area3D.get_overlapping_bodies()[0]

func has_line_of_sight(_target: Node3D) -> bool:
	var space_state = get_world_3d().direct_space_state
	
	var from = global_position
	var to = target.global_position
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	query.collision_mask = CollisionLayers.get_layer(["World", "Enemy"])
	
	var result = space_state.intersect_ray(query)
	
	# if the ray hit something, check if it was an enemy
	if result:
		return result.collider == target
	
	return false

func _on_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
	create_impact()
	queue_free()

func _on_timer_timeout():
	create_impact()
	queue_free()

func create_impact():
	if not IMPACT: return
	var impact = IMPACT.instantiate()
	impact.scale = Vector3.ONE * impact_size
	get_tree().current_scene.add_child(impact)
	impact.global_position = global_position
	
	var sb = SOUNDBOARD.instantiate()
	get_tree().current_scene.add_child(sb)
	sb.global_position = global_position
	sb.small_blast.play_deconflicted()

func _on_homing_buffer_timeout():
	can_home = true
