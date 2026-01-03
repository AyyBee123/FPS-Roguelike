extends Node3D

@export var player: Player

var current_rotation: Vector3
var target_rotation: Vector3

@export var mouse_sensitivity: float = 0.001
@export var pitch_limit_degrees: float = 80.0

var arm: Arm

func _ready():
	player.weapon_shot.connect(add_recoil)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Current rotation state
var pitch: float = 0.0
var yaw: float = 0.0

# Recoil state
var recoil_current := Vector2.ZERO
var recoil_target := Vector2.ZERO

# Stores mouse delta each frame
var mouse_input := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input += event.relative

# add recoil (called when shooting)
func add_recoil(_arm) -> void:
	arm = _arm
	recoil_target.x += _arm.recoil.x
	recoil_target.y += _arm.recoil.y * randf_range(-1, 1)

func _process(delta: float) -> void:
	# mouse look
	yaw -= mouse_input.x * mouse_sensitivity
	pitch -= mouse_input.y * mouse_sensitivity * 1.25
	pitch = clamp(pitch, -deg_to_rad(pitch_limit_degrees), deg_to_rad(pitch_limit_degrees))
	mouse_input = Vector2.ZERO
	
	# recoil
	if arm:
		recoil_target = recoil_target.lerp(Vector2.ZERO, 1.0 - exp(-arm.recoil_speed * delta))
		recoil_current = recoil_current.lerp(recoil_target, 1.0 - exp(-arm.recoil_speed * delta))
	
	# horizontal rotation (yaw + recoil) to the player’s position
	player.rotation.y = yaw + recoil_current.y
	
	# interpolate position for jitter-free camera
	var interp = player.get_global_transform_interpolated()
	global_transform.origin = interp.origin
	
	# vertical rotation (pitch + recoil) to pivot
	rotation.x = clamp(-deg_to_rad(pitch_limit_degrees), pitch + recoil_current.x, deg_to_rad(pitch_limit_degrees))
