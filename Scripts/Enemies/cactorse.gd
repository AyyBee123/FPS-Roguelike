extends Enemy

@onready var armature: Node3D = %Armature

const CACTORSE = preload("uid://duegs3ndgtxbj")

var normal: Vector3 = Vector3.UP

func _ready():
	super._ready()
	for lib_name in animation_player.get_animation_library_list():
		animation_player.remove_animation_library(lib_name)
	
	animation_player.add_animation_library("default", CACTORSE)

func _physics_process(delta):
	super._physics_process(delta)
	move(delta)

func move(delta):
	rotation.x = 0
	rotation.z = 0
	if nav_agent.is_navigation_finished(): return
	
	var current_position: Vector3 = global_transform.origin
	var next_position: Vector3 = nav_agent.get_next_path_position()
	velocity.x = current_position.direction_to(next_position).x * speed
	velocity.z = current_position.direction_to(next_position).z * speed
	
	var raycast_pos: float = ray_cast.get_collision_point().y + raycast_offset
	if position.y > raycast_pos:
		velocity.y -= gravity * delta
	else:
		position.y = raycast_pos
	
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * angular_acceleration)
	
	move_and_slide()

func target_position(target):
	nav_agent.target_position = target
