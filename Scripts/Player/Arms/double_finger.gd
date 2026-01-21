extends Arm

@onready var muzzle_point = %"Muzzle Point".find_child("Muzzle Flash")
@onready var muzzle_point_2 = %"Muzzle Point2".find_child("Muzzle Flash")

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	if not ignore_fire_rate:
		t = 0.0
	
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	animation_player.play(shoot_animation)
	if muzzle_point:
		muzzle_point.play()
	if muzzle_point_2:
		muzzle_point_2.play()
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self, outside_source)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()
