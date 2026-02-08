extends Enemy

@onready var armature: Node3D = %Armature
@onready var move_timer = %"Move Timer"
@onready var nav_agent = %NavigationAgent3D

var normal: Vector3 = Vector3.UP
var desired: Vector3
var gravity = 9.8
var current_player_pos: Vector3

func _ready():
	super._ready()
	move_timer.start(randf_range(TICK_RATE / 2, TICK_RATE))

func _physics_process(delta):
	super._physics_process(delta)

func move(delta):
	if nav_agent.is_navigation_finished():
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		return
	
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	var dir: Vector3 = next_pos - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	
	if dist_sq > 0.001:
		vel = dir * speed / sqrt(dist_sq)
	
	if animation_player.current_animation != "walk":
		animation_player.play("walk")
	
	desired = Vector3.ZERO
	
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), delta * angular_acceleration)
	
	var raycast_y: float = ray_cast.get_collision_point().y + raycast_offset
	
	position.x += vel.x * delta
	position.z += vel.z * delta
	position.y = lerp(position.y, raycast_y, delta * gravity)

func _on_move_timer_timeout():
	move_timer.start(TICK_RATE)
	if current_player_pos == Vector3.ZERO or abs(player.global_position.length() - current_player_pos.length()) > 0.6:
		nav_agent.set_target_position(player.global_position)
		current_player_pos = player.global_position
	move(get_physics_process_delta_time())
