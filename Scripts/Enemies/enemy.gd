extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var armature = %Armature

@export var health: float = 25
@export var speed: float = 5

var angular_acceleration = 5
var t: float = 0.0

func _ready():
	pass

func _physics_process(delta):
	move(delta)

func move(delta):
	if nav_agent.is_navigation_finished(): return
	t += delta
	if t >= 1.0/20.0:
		t = 0
		var current_position: Vector3 = global_transform.origin
		var next_position: Vector3 = nav_agent.get_next_path_position()
		velocity = current_position.direction_to(next_position) * speed
	
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), delta * angular_acceleration)
	move_and_slide()

func target_position(target):
	nav_agent.target_position = target

func hit(_damage):
	health -= _damage
	
	if health <= 0:
		queue_free()
