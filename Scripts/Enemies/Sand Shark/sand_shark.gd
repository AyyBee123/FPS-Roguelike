extends Miniboss

@onready var move_timer = %"Move Timer"
@onready var _state_machine = %state_machine

var normal: Vector3 = Vector3.UP
var desired: Vector3
var gravity: float = 9.8
var target: Vector3
var angle: float = 0.0

@onready var BASE_SPEED: float = speed
@onready var INITIAL_OFFSET: float = raycast_offset

func _ready():
	super._ready()
	move_timer.start(randf_range(TICK_RATE / 2, TICK_RATE))

func _physics_process(delta):
	super._physics_process(delta)
	angle += delta

func swim():
	speed = lerp(speed, BASE_SPEED, 0.2)

func prepare():
	speed = lerp(speed, BASE_SPEED * 4, 0.1)

func charge():
	speed = lerp(speed, BASE_SPEED * 8, 0.333)
	
	if global_position.distance_to(target) > 24:
		target = player.global_position
	
	if global_position.distance_to(target) <= 12:
		_state_machine.set_state(_state_machine.states.bite)

func jump():
	var bite_tween: Tween = get_tree().create_tween()
	bite_tween.bind_node(self)
	bite_tween.tween_property(self, "position:y", 4, 0.25).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func move(delta):
	var dir: Vector3 = target - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	
	if dist_sq > 0.001:
		vel = dir.rotated(Vector3.UP, %CollisionShape3D.rotation.y) * speed / sqrt(dist_sq)
	
	desired = Vector3.ZERO
	
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), delta * angular_acceleration)
	
	var raycast_y: float = ray_cast.get_collision_point().y + raycast_offset
	
	position.x += vel.x * delta
	position.z += vel.z * delta
	position.y = lerp(position.y, raycast_y, delta * gravity)

func _on_move_timer_timeout():
	move_timer.start(TICK_RATE)
	if _state_machine.state == _state_machine.states.swim:
		target = player.global_position
	if _state_machine.state == _state_machine.states.prepare:
		target = player.global_position.cross(Vector3.DOWN).rotated(Vector3.UP, angle)
	if _state_machine.state == _state_machine.states.bite:
		target = global_position + Vector3.BACK.rotated(Vector3.UP, rotation.y)
	
	move(get_physics_process_delta_time())

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Bite":
		_state_machine.set_state(_state_machine.states.swim)

func play_sound(sound: NodePath):
	get_node(sound).play_deconflicted()
