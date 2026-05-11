extends Item

const FIRE_DELAY_MULTIPLIER: float = 4.0

var chance: float = 0.1
var chance_increase: float = 0.1
var base_chance: float = chance

func on_weapon_shot(_arm: Arm):
	if not _arm: return
	if randf() <= chance:
		var state: SceneState = _arm.projectile.get_state()
		var type = state.get_node_type(0)
		if type == "RigidBody3D":
			_arm.launch_projectile(add_spread(_arm.get_camera_point(), 4.0))

func on_stack():
	chance += chance_increase

func on_stack_remove():
	chance -= chance_increase

func set_detailed_desription():
	detailed_description %= [
		base_chance * 100,
		chance_increase * 100
	]

func add_spread(point: Vector3, angle: float) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var from = camera.global_position
	
	var dir = (point - from).normalized()
	var dist = from.distance_to(point)
	
	var spread_rad = deg_to_rad(angle)
	var random_angle = randf() * TAU
	var random_tilt = randf() * spread_rad
	
	var right = dir.cross(Vector3.UP).normalized()
	if right.length_squared() < 0.001:
		right = dir.cross(Vector3.RIGHT).normalized()
	var up = dir.cross(right).normalized()
	
	dir = (dir
	+ right * cos(random_angle) * sin(random_tilt)
	+ up * sin(random_angle) * sin(random_tilt)
	).normalized()
	
	return from + dir * dist
