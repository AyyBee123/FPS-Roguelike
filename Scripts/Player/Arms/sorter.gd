extends Arm

@onready var sorter: MeshInstance3D = %Sorter
@onready var cube_node: Node3D = %CubeNode
@onready var cylinder_node: Node3D = %CylinderNode
@onready var pentagon_node: Node3D = %PentagonNode
@onready var prism_node: Node3D = %PrismNode
@onready var arm: MeshInstance3D = %Arm

var sorter_rotation: float
var rot_tween: Tween

var shape_num: int = 0

const SORTER_CYLINDER = preload("uid://bstpwsbja6kj7")
const SORTER_PENTAGON = preload("uid://21s0f1jtyytq")
const SORTER_PRISM = preload("uid://broogkqybtijb")

func _physics_process(delta):
	super._physics_process(delta)
	
	for shape: Node3D in arm.get_children():
		shape.position.z = lerpf(shape.position.z, 0, 0.5)

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	match shape_num % 4:
		0: # cube
			muzzle.color = "687ae7"
			super.shoot(ignore_fire_rate, outside_source)
			cube_node.position.z = 3.0
		1: # prism
			muzzle.color = "54e74d"
			shoot_different_projectile(SORTER_PRISM, ignore_fire_rate, outside_source)
			prism_node.position.z = 3.0
		2: # cylinder
			muzzle.color = "e73d4d"
			shoot_different_projectile(SORTER_CYLINDER, ignore_fire_rate, outside_source)
			cylinder_node.position.z = 3.0
		3: # pentagon
			muzzle.color = "e7864c"
			shoot_different_projectile(SORTER_PENTAGON, ignore_fire_rate, outside_source)
			pentagon_node.position.z = 3.0
	
	shape_num = (shape_num + 1) % 4
	
	rotate_sorter()

func rotate_sorter():
	rot_tween = get_tree().create_tween()
	rot_tween.tween_callback(func(): sorter.rotation.z = sorter_rotation; sorter_rotation -= PI/2)
	rot_tween.tween_property(sorter, "rotation:z", -PI/2, 0.25).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
