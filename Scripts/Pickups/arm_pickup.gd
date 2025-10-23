extends RigidBody3D

@onready var mesh_instance = %MeshInstance
@onready var collision_shape = %CollisionShape

var arm = preload("res://Scenes/Arms/ph_arm2.tscn")
var arm_name: String
var arm_instance

func _ready():
	arm_instance = arm.instantiate()
	mesh_instance.set_mesh(arm_instance.get_node("%MeshInstance").get_mesh())
	arm_name = arm_instance.name
	# generate a single convex shape from the mesh
	var shape = mesh_instance.mesh.create_convex_shape()
	
	# assign it to the CollisionShape3D
	collision_shape.shape = shape

func pick_up(player):
	player.weapons_manager.swap_arm(arm_instance, global_transform.origin)
	queue_free()
