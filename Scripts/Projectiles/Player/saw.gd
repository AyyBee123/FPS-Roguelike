extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var SOUNDBOARD: PackedScene

@onready var mesh: MeshInstance3D = %Mesh
@onready var raycast: RayCast3D = %RayCast3D
@onready var frontcast: RayCast3D = %FrontCast3D
@onready var sparks: GPUParticles3D = %Sparks
@onready var saw: DeconflictedAudioPlayer = %Saw

const LAUNCH_SPEED_MULTIPLIER: float = 2.0
const STICKING_FORCE: float = 20.0
const ACCELERATION: float = 100.0

var grounded: bool = false
var current_speed: float

func _ready():
	super._ready()
	current_speed = speed
	sparks.emitting = false

func _physics_process(delta):
	super._physics_process(delta)
	if grounded and raycast.is_colliding():
		gravity_scale = 6.0
		var normal = raycast.get_collision_normal()
		
		# reset the forward trajectory every frame for uneven terrain
		var forward = -transform.basis.z
		var projected = forward - normal * forward.dot(normal)
		
		# add some ramp up in speed
		current_speed = move_toward(current_speed, speed * LAUNCH_SPEED_MULTIPLIER, ACCELERATION * delta)
		linear_velocity = projected.normalized() * current_speed
		
		# makes the saw stick to the ground
		apply_central_force(-normal * STICKING_FORCE)
		
		mesh.rotation.x -= TAU * 2 * delta
	else:
		mesh.rotation.x -= PI * delta
	
	if frontcast.is_colliding():
		var normal = frontcast.get_collision_normal()
		var steepness = normal.dot(Vector3.UP) # 0 = vertical wall, 1 = flat floor, negative = past vertical (overhang)
		
		if steepness < 0.1: # wall is steep enough to block the saw
			var sound = SOUNDBOARD.instantiate()
			sound.position = position
			get_tree().current_scene.add_child(sound)
			sound.saw_hit.play_deconflicted()
			
			create_impact()
			queue_free()
			return
	
	if get_colliding_bodies().size() > 0:
		sparks.emitting = true
	else:
		sparks.emitting = false

func _on_body_entered(_body):
	if not grounded:
		lifetime.start(range / (speed * LAUNCH_SPEED_MULTIPLIER))
		saw.pitch_scale = randf_range(0.75, 1.25)
		saw.play_deconflicted()
	grounded = true

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
