extends Arm

@onready var cactarm_shot = %"Cactarm Shot"
@onready var cactarm_shotgun = %"Cactarm Shotgun"
@onready var release_timer = %"Release Timer"

const NUMBER_OF_SPREAD_SHOTS: int = 8

@onready var original_range: float = base_range
@onready var original_fire_rate: float = base_fire_rate

var shooting: bool = false
var can_stack: bool = true

func shoot():
	if not release_timer.is_stopped(): return
	
	can_stack = true
	recoil_multiplier = 1
	base_projectile_count = 1
	base_range = original_range
	spread = 0
	
	if not firing_audio.has(cactarm_shot):
		firing_audio.clear()
		firing_audio.append(cactarm_shot)
	super.shoot()
	shooting = true

func release():
	super.release()
	
	if not shooting: return
	shooting = false
	
	can_stack = false
	recoil_multiplier = 3
	base_projectile_count = 6
	base_range = original_range / 2
	spread = 16
	
	if not firing_audio.has(cactarm_shotgun):
		firing_audio.clear()
		firing_audio.append(cactarm_shotgun)
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	
	animation_player.stop()
	if shoot_animation != "":
		animation_player.play(shoot_animation)
	if muzzle:
		muzzle.play()
	
	var camera_collision: Vector3 = get_camera_collision()
	
	player._on_arm_shot(self)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()
	
	release_timer.start(1.0 / fire_rate * 4)

func set_projectile_flags(proj):
	proj.can_stack = can_stack
	super.set_projectile_flags(proj)
