extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var BLAST: PackedScene

var stuck: bool = false
var stuck_to: Node3D = null
var stuck_offset: Transform3D
var stuck_lifetime: float = 8.0

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if stuck:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		if stuck_to and is_instance_valid(stuck_to):
			state.transform = stuck_to.global_transform * stuck_offset
		return
	var vel = state.linear_velocity
	
	if vel.length() > 0.01:
		var dir = vel.normalized()
		var up = Vector3.UP if abs(dir.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
		state.transform = Transform3D(Basis.looking_at(dir, up), state.transform.origin)

func _physics_process(delta):
	super._physics_process(delta)
	if stuck and not is_instance_valid(stuck_to):
		queue_free()

func _on_body_entered(body):
	if stuck: return
	stuck = true
	
	if body is Enemy:
		body.hit(damage, player, self)
	
	stick_to(body)

func stick_to(target: Node):
	freeze = true
	stuck_to = target
	stuck_offset = target.global_transform.affine_inverse() * global_transform
	range = 9999999
	lifetime.start(stuck_lifetime)

func explode():
	var blast = BLAST.instantiate()
	blast.damage = damage
	blast.radius = radius
	blast.player = player
	blast.color = "00ffff"
	blast.position = position
	get_tree().current_scene.add_child.call_deferred(blast)

func _exit_tree():
	explode()
