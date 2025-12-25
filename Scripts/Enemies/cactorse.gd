extends Enemy

@onready var armature: Node3D = %Armature

var normal: Vector3 = Vector3.UP

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	move(delta)

func move(delta):
	rotation.x = 0
	rotation.z = 0
	if nav_agent.is_navigation_finished():
		animation_player.play("idle")
		return
	
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
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
