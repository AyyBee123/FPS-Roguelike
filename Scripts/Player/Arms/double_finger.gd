extends Arm

@onready var muzzle_point = %"Muzzle Point"
@onready var muzzle_point_2 = %"Muzzle Point2"

func shoot():
	if t < fire_rate_timer: return
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	animation_player.play(shoot_animation)
	if muzzle:
		var m = muzzle.instantiate()
		m.set_color(muzzle_color)
		muzzle_point.add_child(m)
		
		var m2 = muzzle.instantiate()
		m2.set_color(muzzle_color)
		muzzle_point_2.add_child(m2)
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()
