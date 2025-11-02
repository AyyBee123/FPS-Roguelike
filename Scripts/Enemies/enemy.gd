extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var armature: Node3D = %Armature
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skeleton_3d: Skeleton3D = %Skeleton3D

@export var health: float = 25
@export var speed: float = 5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var angular_acceleration: float = 5
var t: float = 0.0

func _ready():
	pass

func _physics_process(delta):
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

func hit(_damage):
	health -= _damage
	
	if health <= 0:
		queue_free()

func _on_visible_on_screen_notifier_3d_screen_entered():
	animation_player.active = true

func _on_visible_on_screen_notifier_3d_screen_exited():
	animation_player.active = false
