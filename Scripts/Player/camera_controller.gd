extends Camera3D

@onready var camera_controller_anchor = %"Camera Controller Anchor"

var player
var sensitivity = 0.001
var mouse_input := Vector2(0, 0)
var camera_rotation := Vector2(0, 0)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_input.x += -event.screen_relative.x * sensitivity
		mouse_input.y += -event.screen_relative.y * sensitivity

func _process(delta):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	camera_rotation.x = clampf(camera_rotation.x + mouse_input.y, -5 * PI/12, PI/2)
	camera_rotation.y += mouse_input.x
	
	# rotate the camera about the x-axis
	camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(camera_rotation.x, 0, 0))
	# rotate the player about the y-axis
	player.transform.basis = Basis.from_euler(Vector3(0, camera_rotation.y, 0))
	
	global_transform = camera_controller_anchor.get_global_transform_interpolated()
	
	mouse_input = Vector2.ZERO
