extends Enemy

@onready var armature: Node3D = %Armature

var normal: Vector3 = Vector3.UP
var desired: Vector3
var t: float = INF

func _ready():
	super._ready()

func _physics_process(delta):
	t += delta
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
	
	desired = Vector3.ZERO
	var current_position: Vector3 = global_position
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction = next_position - current_position
	desired += direction.normalized() * speed
	velocity = velocity.lerp(desired, delta)
	
	var raycast_pos: float = ray_cast.get_collision_point().y + raycast_offset
	if position.y > raycast_pos:
		velocity.y -= gravity * delta
	else:
		position.y = raycast_pos
	
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * angular_acceleration)
	
	move_and_slide()

func target_position(target: Vector3):
	var num = get_tree().current_scene.current_number_of_enemies
	if num > 50 and t >= num / 50.0: # lower the navigation amount with large enemy quantity to improve performance
		t = 0
		nav_agent.target_position = target
	elif num <= 50:
		nav_agent.target_position = target
