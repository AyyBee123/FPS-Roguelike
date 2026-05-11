extends Arm

@onready var sorter: MeshInstance3D = %Sorter

const SORTER_CUBE = preload("uid://bp1jygh0et0jk")
const SORTER_CYLINDER = preload("uid://bstpwsbja6kj7")
const SORTER_PENTAGON = preload("uid://21s0f1jtyytq")
const SORTER_PRISM = preload("uid://broogkqybtijb")

const SHOTS_PER_BURST: int = 4

var sorter_rotation: float
var rot_tween: Tween
var sway_amount: float = 0.5
var max_sway: float = 10.0
var shape_num: int = 0

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	var camera_collision: Vector3 = get_camera_collision()
	
	if not ignore_fire_rate:
		t = 0.0
		
		for i in SHOTS_PER_BURST:
			player._on_arm_shot(self, outside_source)
			
			match shape_num % 4:
				0: # cube
					muzzle.color = "687ae7"
					projectile = SORTER_CUBE
				1: # prism
					muzzle.color = "54e74d"
					projectile = SORTER_PRISM
				2: # cylinder
					muzzle.color = "e73d4d"
					projectile = SORTER_CYLINDER
				3: # pentagon
					muzzle.color = "e7864c"
					projectile = SORTER_PENTAGON
			
			for j in range(projectile_count):
				launch_projectile(camera_collision)
			
			for audio in firing_audio:
				if audio:
					audio.play_deconflicted()
			
			animation_player.stop()
			if shoot_animation != "":
				animation_player.play(shoot_animation)
			if muzzle:
				muzzle.play()
			
			shape_num = (shape_num + 1) % 4
			rotate_sorter()
			
			await get_tree().create_timer(1.0 / (fire_rate * 8)).timeout
		
		fire_rate_timer = 1.0 / fire_rate

func rotate_sorter():
	rot_tween = get_tree().create_tween()
	rot_tween.tween_callback(func(): sorter.rotation.z = sorter_rotation; sorter_rotation -= PI/2)
	rot_tween.tween_property(sorter, "rotation:z", -PI/2, 0.25).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
