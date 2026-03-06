extends Enemy

@onready var rock: MeshInstance3D = %Rock
@onready var move_timer: Timer = %"Move Timer"
@onready var rotation_point: Node3D = %"Rotation Point"
@onready var rotation_marker: Marker3D = %"Rotation Marker"

var normal: Vector3 = Vector3.UP
var desired: Vector3
var gravity = 9.8
var current_player_pos: Vector3

func _ready():
	super._ready()
	move_timer.start(randf_range(TICK_RATE / 2, TICK_RATE))

func move(delta):
	var dir: Vector3 = player.global_position - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	
	var rot_dir: Vector3 = (rotation_marker.global_position - global_position) * speed
	
	if dist_sq > 0.001:
		vel = dir / sqrt(dist_sq)
	
	desired = Vector3.ZERO
	
	var raycast_y: float = ray_cast.get_collision_point().y + raycast_offset
	
	rotation_point.rotation.y = lerp_angle(
		rotation_point.rotation.y,
		atan2(vel.x, vel.z),
		delta * angular_acceleration
	)
	
	position.x += rot_dir.x * delta
	position.z += rot_dir.z * delta
	position.y = lerp(position.y, raycast_y, delta * gravity)
	
	var move_vec = Vector3(rot_dir.x, 0.0, rot_dir.z) * delta
	var distance = move_vec.length()

	if distance > 0.001:
		var roll_axis = Vector3.UP.cross(move_vec.normalized())
		var roll_angle = distance
		rock.rotate(roll_axis, roll_angle)

func _on_move_timer_timeout():
	move_timer.start(TICK_RATE)
	move(get_physics_process_delta_time())
