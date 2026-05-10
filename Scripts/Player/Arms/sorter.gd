extends Arm

@onready var sorter: MeshInstance3D = %Sorter

var sorter_rotation: float
var rot_tween: Tween
var sway_amount: float = 0.5
var max_sway: float = 10.0
var shape_num: int = 0

const SORTER_CYLINDER = preload("uid://bstpwsbja6kj7")
const SORTER_PENTAGON = preload("uid://21s0f1jtyytq")
const SORTER_PRISM = preload("uid://broogkqybtijb")

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	match shape_num % 4:
		0: # cube
			muzzle.color = "687ae7"
			super.shoot(ignore_fire_rate, outside_source)
		1: # prism
			muzzle.color = "54e74d"
			shoot_different_projectile(SORTER_PRISM, ignore_fire_rate, outside_source)
		2: # cylinder
			muzzle.color = "e73d4d"
			shoot_different_projectile(SORTER_CYLINDER, ignore_fire_rate, outside_source)
		3: # pentagon
			muzzle.color = "e7864c"
			shoot_different_projectile(SORTER_PENTAGON, ignore_fire_rate, outside_source)
	
	shape_num = (shape_num + 1) % 4
	rotate_sorter()

func rotate_sorter():
	rot_tween = get_tree().create_tween()
	rot_tween.tween_callback(func(): sorter.rotation.z = sorter_rotation; sorter_rotation -= PI/2)
	rot_tween.tween_property(sorter, "rotation:z", -PI/2, 0.25).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
