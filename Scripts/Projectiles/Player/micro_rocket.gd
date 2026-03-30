extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var SOUNDBOARD: PackedScene

const ROTATIONAL_ACCELRATION: float = 24.0

var target: Enemy = null
var can_home: bool = false

func _physics_process(delta):
	super._physics_process(delta)
	if target and can_home:
		var desired_direction = (target.global_position - global_position).normalized() * speed
		linear_velocity = linear_velocity.lerp(desired_direction, ROTATIONAL_ACCELRATION * delta)
		linear_velocity = linear_velocity.limit_length(speed * 0.333)
	elif not %Area3D.get_overlapping_bodies().is_empty() and %Area3D.get_overlapping_bodies()[0] is Enemy:
		target = %Area3D.get_overlapping_bodies()[0]

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
