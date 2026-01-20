extends Arm

@onready var barrel = %Barrel
@onready var cylinder_001 = $Armature/Base/Cylinder_001

const SPOOL_TIME: float = 1.5
const STEP = TAU / 5

var fire_rate_multiplier: float = 0.25

var is_shoot_button_held: bool = false

var current_rotation: float = 0.0
var spool: float = 0.0

func _physics_process(delta):
	cylinder_001.rotate_object_local(Vector3.UP, delta * 4)
	super._physics_process(delta)
	if is_shoot_button_held:
		spool = min(spool + delta / SPOOL_TIME, 1.0)
		barrel.rotation.z = min(current_rotation, barrel.rotation.z + delta * fire_rate * fire_rate_multiplier)
	else:
		spool = max(spool - delta / SPOOL_TIME, 0.2)
		barrel.rotation.z = min(current_rotation, barrel.rotation.z + (current_rotation - barrel.rotation.z) * delta / fire_rate_multiplier)
	
	fire_rate_multiplier = lerp(0.2, 1.0, ease_out_quad(spool))

func ease_out_quad(t: float):
	return 1.0 - (1.0 - t) * (1.0 - t)

func _input(event):
	if Input.is_action_pressed("shoot"):
		if not is_shoot_button_held:
			barrel.rotation.z = 0
			current_rotation = STEP
		is_shoot_button_held = true
	elif is_shoot_button_held and not Input.is_action_pressed("shoot"):
		is_shoot_button_held = false
		barrel.rotation.z = 0
		current_rotation = max(round(TAU * fire_rate_multiplier / STEP) * STEP, STEP)

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	if not ignore_fire_rate:
		t = 0.0
	fire_rate_timer = 1.0 / (fire_rate * fire_rate_multiplier)
	animation_player.stop()
	animation_player.play(shoot_animation)
	if muzzle:
		var m = muzzle.instantiate()
		m.set_color(muzzle_color)
		m.size = muzzle_size
		bullet_point.add_child(m)
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self, outside_source)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()
	
	current_rotation += STEP
