extends "res://Scripts/Projectiles/Player/projectile.gd"

@onready var mesh = %Mesh
@onready var trail = %Trail

var target: Node
var target_pos: Vector3
var current_speed: float
var is_returning: bool = false
var tween: Tween
var rotation_direction: float

func _ready():
	super._ready()
	%"Rotation Node".rotation.z = randf_range(-PI/12, PI/12)
	rotation_direction = sign(%"Rotation Node".rotation.z)

func _physics_process(delta):
	super._physics_process(delta)
	mesh.rotation.y += 5.0 * delta * rotation_direction
	trail.global_transform.basis = mesh.global_transform.basis
	
	if is_instance_valid(target):
		target_pos = target.global_position
		if is_returning:
			current_speed = lerpf(current_speed, speed, 4.0 * delta)
			var direction = (target_pos - global_position).normalized()
			set_linear_velocity(direction * current_speed)
			
			if global_position.distance_squared_to(target_pos) <= 0.4:
				queue_free()

func _on_body_entered(_body):
	create_impact()
	_on_timer_timeout()

func _on_timer_timeout():
	if not is_returning:
		is_returning = true
		set_linear_velocity(Vector3.ZERO)
		lifetime.wait_time *= 2
		lifetime.start()
	else:
		queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
