extends RigidBody3D

@onready var mesh_instance = %MeshInstance
@onready var collision_shape = %CollisionShape

var arm
var arm_name: String

var rarity_weights = ArmPool.rarity_weights

func _ready():
	randomize()
	# Convert to cumulative drop chances
	var total_weight := 0.0
	for weight in rarity_weights.values():
		total_weight += weight
	
	var weighted_amount = randf() * total_weight
	
	# Find which rarity it falls into
	var cumulative: float = 0.0
	var chosen_rarity: int = -1
	for rarity in rarity_weights.keys():
		cumulative += rarity_weights[rarity]
		if weighted_amount <= cumulative:
			chosen_rarity = rarity
			break
	
	# Pick item from the correct pool
	var pool_name := ""
	match chosen_rarity:
		0: pool_name = "common_pool"
		1: pool_name = "rare_pool"
		2: pool_name = "legendary_pool"
	
	arm = ArmPool.get(pool_name).pick_random().instantiate()
	mesh_instance.set_mesh(arm.get_node("%MeshInstance").get_mesh())
	arm_name = arm.name
	# generate a single convex shape from the mesh
	var shape = mesh_instance.mesh.create_convex_shape()
	
	# assign it to the CollisionShape3D
	collision_shape.shape = shape

func pick_up(player):
	player.weapons_manager.swap_arm(arm)
	queue_free()
