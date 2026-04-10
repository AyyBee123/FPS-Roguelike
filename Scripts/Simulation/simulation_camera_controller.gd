extends Node3D

@export var player: Player
@export var rig: Node3D

var current_rotation: Vector3
var target_rotation: Vector3
var rig_origin: Vector3
var land_tween: Tween
var dash_tween: Tween
var hit_tween: Tween

@export var sensitivity: float = 0.001
@export var pitch_limit_degrees: float = 85.0

var weapon_sway: float = 0.0025
var weapon_sway_speed: float = 10.0
var bob_amount: float = 0.025
var bob_freq: float = 0.015
var rig_max_rotation: float = 0.25
var rig_max_position: float = 0.2

var arm: Arm

func _ready():
	player.weapon_shot.connect(add_recoil)
	player.on_landing.connect(land)
	player.on_dash.connect(dash)
	player.hit_taken.connect(hit)
	rig_origin = rig.position

# Current rotation state
var pitch: float = 0.0
var yaw: float = 0.0

# Recoil state
var recoil_current: Vector2 = Vector2.ZERO
var recoil_target: Vector2 = Vector2.ZERO

# Stores mouse delta each frame
var input: Vector2 = Vector2.ZERO

# add recoil (called when shooting)
func add_recoil(_arm: Arm, _source: Node) -> void:
	arm = _arm
	recoil_target.x += _arm.recoil.x * _arm.recoil_multiplier
	recoil_target.y += _arm.recoil.y * _arm.recoil_multiplier * randf_range(-1, 1)

func _physics_process(delta: float) -> void:
	# mouse look
	yaw -= input.x * sensitivity
	pitch -= input.y * sensitivity * 1.25
	pitch = clamp(pitch, -deg_to_rad(pitch_limit_degrees), deg_to_rad(pitch_limit_degrees))
	
	# rotate the arm based on camera/player rotation
	if rig:
		rig.rotation.y = lerp(rig.rotation.y, input.x * weapon_sway, weapon_sway_speed * delta)
		rig.rotation.x = lerp(rig.rotation.x, input.y * weapon_sway, weapon_sway_speed * delta)
		rig.rotation = rig.rotation.clamp(-Vector3.ONE * rig_max_rotation, Vector3.ONE * rig_max_rotation)
	
	# horizontal rotation (yaw + recoil) to the player’s position
	player.rotation.y = yaw + recoil_current.y
	
	# interpolate position for jitter-free camera
	var interp: Transform3D = player.get_global_transform_interpolated()
	global_transform.origin = interp.origin
	
	# vertical rotation (pitch + recoil) to pivot
	rotation.x = clamp(-deg_to_rad(pitch_limit_degrees), pitch + recoil_current.x, deg_to_rad(pitch_limit_degrees))
	
	bob(player.velocity.length(), delta)
	
	input = Vector2.ZERO

func bob(vel: float, delta):
	if rig:
		if vel > 0.01:
			if player.is_on_floor():
				rig.position.y = lerp(rig.position.y, rig_origin.y + sin(Time.get_ticks_msec() * bob_freq * player.SPEED / 8) * bob_amount, 10 * delta)
				rig.position.x = lerp(rig.position.x, rig_origin.x + sin(Time.get_ticks_msec() * bob_freq * 0.5 * player.SPEED / 8) * bob_amount, 10 * delta)
			else:
				rig.rotation.x = lerp(rig.rotation.x, -player.velocity.y * 0.1, 10 * delta)
				rig.position.x = lerp(rig.position.x, rig_origin.x, 10 * delta)
				if player.velocity.y > 0:
					rig.position.y = lerp(rig.position.y, rig_origin.y - player.velocity.y * 0.025, 10 * delta)
				else:
					rig.position.y = lerp(rig.position.y, rig_origin.y - player.velocity.y * 0.005, 2.5 * delta)
		else:
			rig.position.y = lerp(rig.position.y, rig_origin.y + sin(Time.get_ticks_msec() * bob_freq * 0.1 * player.SPEED / 8) * bob_amount, 10 * delta)
			rig.position.x = lerp(rig.position.x, rig_origin.x, 10 * delta)
		
		rig.position.z = lerp(rig.position.z, rig_origin.z, 10 * delta)
		
		rig.position = rig.position.clamp(-Vector3.ONE * rig_max_position, Vector3.ONE * rig_max_position)

func land(impact_speed: float):
	var impact_strength: float = 0.025
	var impact_duration: float = 0.1
	
	land_tween = get_tree().create_tween()
	land_tween.tween_property(rig, "position:y", impact_speed * impact_strength, impact_duration).as_relative()
	land_tween.parallel().tween_property(rig, "rotation:x", impact_speed * impact_strength, impact_duration).as_relative()

func dash(_dash_speed: float, dash_direction: Vector2):
	var dash_duration: float = 0.05
	var dir = Vector3(dash_direction.x, 0, dash_direction.y).normalized()
	dash_tween = get_tree().create_tween()
	dash_tween.tween_property(rig, "position", -dir * 0.25, dash_duration).as_relative()

func hit(pos):
	var hit_strength: float = 0.333
	var hit_duration: float = 0.05
	
	hit_tween = get_tree().create_tween()
	hit_tween.tween_property(rig, "position:x", -pos.normalized().x * hit_strength, hit_duration).as_relative()
	hit_tween.parallel().tween_property(rig, "position:y", pos.normalized().y * hit_strength, hit_duration).as_relative()
