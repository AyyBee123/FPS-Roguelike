extends Arm

@export var bullet_points: Array[Marker3D]
@export var shoot_animations: Array[String]

var finger_number: int = 0

func shoot():
	if t < fire_rate_timer: return
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	
	animation_player.stop()
	finger_number = randi_range(0, 4)
	animation_player.play(shoot_animations[finger_number])
	bullet_points[finger_number].get_child(0).play()
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()
