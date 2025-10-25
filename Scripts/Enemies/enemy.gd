extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var mesh = %MeshInstance3D

@export var health: float = 25
@export var speed: float = 5

var angular_acceleration = 5

func _ready():
	pass

func _physics_process(delta):
	move(delta)

func move(delta):
	if nav_agent.is_navigation_finished(): return
	
	var current_position: Vector3 = global_transform.origin
	var next_position: Vector3 = nav_agent.get_next_path_position()
	
	mesh.rotation.y = lerp(mesh.rotation.y, atan2(-velocity.x, -velocity.z), delta * angular_acceleration)
	
	velocity = current_position.direction_to(next_position) * speed
	move_and_slide()

func target_position(target):
	nav_agent.target_position = target

func hit(_damage):
	health -= _damage
	print(health)
	
	if health <= 0:
		queue_free()
