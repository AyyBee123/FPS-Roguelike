extends Enemy

@onready var armature: Node3D = %Armature
@onready var move_timer = %"Move Timer"
@onready var object_avoidance = %"Object Avoidance"

var normal: Vector3 = Vector3.UP
var desired: Vector3
var gravity = 9.8

func _ready():
	super._ready()
	move_timer.start(randf_range(TICK_RATE/2, TICK_RATE))

func _physics_process(delta):
	super._physics_process(delta)

func move(delta):
	rotation.x = 0
	rotation.z = 0
	
	var dir: Vector3 = player.global_position - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	
	if dist_sq > 0.001:
		vel = dir * speed / sqrt(dist_sq)
	
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
	desired = Vector3.ZERO
	
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), delta * angular_acceleration)
	
	var raycast_y: float = ray_cast.get_collision_point().y + raycast_offset
	
	position.x += vel.x * delta
	position.z += vel.z * delta
	position.y = lerp(position.y, raycast_y, delta * gravity)

func _on_move_timer_timeout():
	move_timer.start(TICK_RATE)
	move(get_physics_process_delta_time())
