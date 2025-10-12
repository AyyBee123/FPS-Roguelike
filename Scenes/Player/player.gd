extends CharacterBody3D

@onready var camera = %Camera

var SPEED = 5.0
var JUMP_VELOCITY = 4.5

var camera_rotation = Vector2(0, 0)
var sensitivity = 0.001

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion:
		var mouse_event = event.relative * sensitivity
		camera_look(mouse_event)

func camera_look(movement: Vector2):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	camera_rotation += movement
	camera_rotation.y = clamp(camera_rotation.y, -1.5, 1.2)
	
	transform.basis = Basis() # reset rotation
	camera.transform.basis = Basis() # reset camera rotation
	
	rotate_object_local(Vector3(0, 1, 0), -camera_rotation.x) # first rotate the player about the y-axis
	camera.rotate_object_local(Vector3(1, 0, 0), -camera_rotation.y) # then rotate the camera about the x-axis
