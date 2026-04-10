extends Arm

@export var cylinders: Array[MeshInstance3D]

@onready var barrel = %Barrel
@onready var magazine = %Magazine
@onready var buzz = %SMG2

const SPOOL_TIME: float = 1.5
const STEP = TAU / 5

var is_shoot_button_held: bool = false
var fire_rate_multiplier: float = 0.25
var current_rotation: float = 0.0
var spool: float = 0.0

func _physics_process(delta):
	super._physics_process(delta)
	if is_shoot_button_held:
		spool = min(spool + delta / SPOOL_TIME, 1.0)
		barrel.rotation.z = min(current_rotation, barrel.rotation.z + delta * fire_rate * fire_rate_multiplier)
	else:
		spool = max(spool - delta / SPOOL_TIME, 0.1)
		barrel.rotation.z = min(current_rotation, barrel.rotation.z + (current_rotation - barrel.rotation.z) * delta / fire_rate_multiplier)
	
	fire_rate_multiplier = lerp(0.2, 1.0, ease_out_quad(spool))
	
	var dir = fire_rate * fire_rate_multiplier
	for cylinder in cylinders:
		cylinder.rotate_object_local(Vector3.UP, delta * dir)
		dir = -dir
	magazine.rotation.z = -barrel.rotation.z / 2

func ease_out_quad(_t: float):
	return 1.0 - (1.0 - _t) * (1.0 - _t)

func _input(_event):
	if Input.is_action_pressed("shoot"):
		if not is_shoot_button_held:
			barrel.rotation.z = 0
			current_rotation = STEP
		is_shoot_button_held = true
	elif is_shoot_button_held and not Input.is_action_pressed("shoot"):
		is_shoot_button_held = false
		barrel.rotation.z = 0
		if fire_rate_multiplier >= 0.98:
			buzz.pitch_scale = max(1 - fire_rate_multiplier, 0.25)
		buzz.play_deconflicted(0.125)
		current_rotation = max(round(TAU * fire_rate_multiplier / STEP) * STEP, STEP)

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	if not ignore_fire_rate:
		t = 0.0
	fire_rate_timer = 1.0 / (fire_rate * fire_rate_multiplier)
	animation_player.stop()
	animation_player.play(shoot_animation)
	if muzzle:
		muzzle.play()
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self, outside_source)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.pitch_scale = fire_rate_multiplier / 2 + 1
			audio.play_deconflicted()
	
	current_rotation += STEP
