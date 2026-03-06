extends Boss

@onready var _state_machine: state_machine = %state_machine

const SPIN_COUNT: int = 4
var current_spin: int = 0

var is_spawned: bool = false

func _ready():
	super._ready()
	var dir: Vector3 = player.global_position - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	vel = dir.rotated(Vector3.UP, %Armature.rotation.y) * speed / sqrt(dist_sq)
	
	rotation.y = atan2(vel.x, vel.z)

func idle():
	look()

func dig_up():
	look()

func dig_down():
	look()

func set_dig_pos():
	global_position = find_dig_point(player.global_position, 15, 20)

func look():
	var dir: Vector3 = player.global_position - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	if dist_sq > 0.001:
		vel = dir.rotated(Vector3.UP, %Armature.rotation.y) * speed / sqrt(dist_sq)
	
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), get_physics_process_delta_time() * angular_acceleration)

func find_dig_point(player_pos: Vector3, min_distance: float, max_distance: float) -> Vector3: # enemy spawn
	for i in 50:
		var pos: Vector3 = NavigationServer3D.map_get_random_point(
			get_tree().current_scene.nav_region.get_navigation_map(), 1, false
		)
		
		if pos == Vector3.ZERO:
			continue
		
		var plane_distance: float = Vector2(pos.x, pos.z).distance_to(Vector2(player_pos.x, player_pos.z))
		
		if plane_distance < min_distance or plane_distance > max_distance:
			continue
		
		return pos
	
	return Vector3.ZERO

func set_spawned():
	SignalBus.boss_spawned.emit(self)
	is_spawned = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spawn":
		_state_machine.set_state(_state_machine.states.idle)
	if anim_name == "Slam":
		_state_machine.set_state(_state_machine.states.idle)
	if anim_name == "Spread":
		if _state_machine.state == _state_machine.states.spread:
			_state_machine.set_state(_state_machine.states.spin)
		elif _state_machine.state == _state_machine.states.contract:
			_state_machine.set_state(_state_machine.states.idle)
	if anim_name == "Spin":
		if current_spin < SPIN_COUNT - 1:
			current_spin += 1
			animation_player.play("Spin")
		else:
			current_spin = 0
			_state_machine.set_state(_state_machine.states.contract)
