extends "res://Scripts/Projectiles/Player/projectile.gd"

var target: Node
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
	%Mesh.rotation.y += 5.0 * delta * rotation_direction
	
	if not is_instance_valid(target):
		queue_free()
	
	if is_instance_valid(target) and is_returning:
		current_speed = lerpf(current_speed, speed, 4.0 * delta)
		var direction = (target.global_position - global_position).normalized()
		set_linear_velocity(direction * current_speed)
		
		if global_position.distance_squared_to(target.global_position) <= 0.4:
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
