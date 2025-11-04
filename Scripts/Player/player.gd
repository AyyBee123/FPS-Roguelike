extends CharacterBody3D

@onready var camera = %Camera
@onready var camera_controller_anchor = %"Camera Controller Anchor"
@onready var animation_player = %AnimationPlayer
@onready var weapons_manager = %"Weapons Manager"
@onready var passives = %Passives
@onready var abilities = %Abilities

const Stats = preload("uid://d0a7frb8gvg68")
var stats

var SPEED: float:
	get:
		return stats.get_character_stat("Move_Speed")
var JUMP_HEIGHT: float:
	get:
		return stats.get_character_stat("Jump_Height")
var FALL_SPEED: float:
	get:
		return stats.get_character_stat("Fall_Speed")
var NUMBER_OF_EXTRA_JUMPS: int:
	get:
		return stats.get_character_stat("Extra_Jumps")

var pickup = null
var nearby_pickups: Array = []

func _ready():
	stats = Stats.new()

func _physics_process(delta):
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * FALL_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT
	
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
	
	if nearby_pickups.size() > 0:
		pickup = get_pickup_collision()
	
	get_tree().call_group("Enemy", "target_position", global_transform.origin)

func _input(event):
	if event.is_action_pressed("pickup") and pickup:
		pickup.pick_up(self)

func get_pickup_collision():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().size
	
	var ray_origin = camera.project_ray_origin(viewport / 2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport / 2) * 3.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = CollisionLayers.get_mask(["Pickup"])
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if not result.is_empty():
		return result.collider
	else:
		return null

func hit(damage):
	print("Ow!")

func _on_pickup_detect_body_entered(body):
	nearby_pickups.append(body)

func _on_pickup_detect_body_exited(body):
	nearby_pickups.erase(body)
