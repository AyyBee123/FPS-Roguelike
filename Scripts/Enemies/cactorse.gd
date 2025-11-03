extends "res://Scripts/Enemies/enemy.gd"

@onready var armature: Node3D = %Armature
@onready var skeleton_3d: Skeleton3D = %Skeleton3D

const CACTORSE = preload("uid://duegs3ndgtxbj")

func _ready():
	super._ready()
	for lib_name in animation_player.get_animation_library_list():
		animation_player.remove_animation_library(lib_name)
	
	animation_player.add_animation_library("default", CACTORSE)

func _physics_process(delta):
	super._physics_process(delta)
	move(delta)

func move(delta):
	if nav_agent.is_navigation_finished(): return

	var current_position: Vector3 = global_transform.origin
	var next_position: Vector3 = nav_agent.get_next_path_position()
	velocity.x = current_position.direction_to(next_position).x * speed
	velocity.z = current_position.direction_to(next_position).z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), delta * angular_acceleration)
	move_and_slide()

func target_position(target):
	nav_agent.target_position = target
