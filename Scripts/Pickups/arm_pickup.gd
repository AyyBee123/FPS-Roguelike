class_name ArmPickup extends RigidBody3D

@onready var collision_shape = %CollisionShape
@onready var visual_offset = %"Visual Offset"

const AMPLITUDE: float = 0.05
const FREQUENCY: float = 1.0

var arm: Arm
var arm_name: String
var rarity_weights = ArmPool.rarity_weights
var offset: Vector3 = Vector3.ZERO
var armature: Node3D
var time: float = 0.0
var default_pos: Vector3

func _ready():
	if not arm:
		arm = ArmPool.roll()
	arm_name = arm.name
	if arm.get_node_or_null("Armature"):
		armature = arm.get_node("Armature").duplicate()
		armature.position.z = 0
		visual_offset.add_child(armature)
		offset = arm.get_node("Armature").position
	
	# get the mesh bounding box and create and collision box using the resulting bounding box
	var aabb: AABB = get_visual_aabb(arm)
	var box: Shape3D = BoxShape3D.new()
	box.size = aabb.size
	collision_shape.shape = box
	
	# center the arm's position
	visual_offset.position -= aabb.position + aabb.size / 2
	default_pos = visual_offset.position

func _physics_process(delta):
	time += delta * FREQUENCY
	visual_offset.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))

func pick_up(player):
	player.weapons_manager.swap_arm(arm)
	queue_free()

func get_visual_aabb(root: Node3D) -> AABB:
	var meshes = get_all_mesh_instances(root)
	
	var combined: AABB = AABB()
	var first: bool = true
	
	for mesh in meshes:
		var aabb = mesh.get_aabb()
		if first:
			combined = aabb
			first = false
		else:
			combined = combined.merge(aabb)
	
	return combined

func get_all_mesh_instances(node: Node) -> Array:
	var meshes = []
	for child in node.get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		meshes += get_all_mesh_instances(child) # recursion for nested children
	return meshes
