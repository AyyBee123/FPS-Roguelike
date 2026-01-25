class_name ArmPickup extends RigidBody3D

@export var arm_scene: PackedScene
@export var shader: Shader

@onready var collision_shape = %CollisionShape
@onready var visual_offset = %"Visual Offset"
@onready var jingle = %Jingle
@onready var default_scale = get_scale()


const AMPLITUDE: float = 0.05
const FREQUENCY: float = 1.0

var arm: Arm
var arm_name: String
var rarity_weights = ArmPool.rarity_weights
var offset: Vector3 = Vector3.ZERO
var armature: Node3D
var time: float = 0.0
var default_pos: Vector3
var mesh_list: Array[MeshInstance3D]
var tween: Tween

func _ready():
	if not arm_scene:
		if not arm:
			arm = ArmPool.roll()
	else:
		arm = arm_scene.instantiate()
	arm_name = arm.arm_name
	if arm.get_node_or_null("Armature"):
		armature = arm.get_node("Armature").duplicate()
		armature.position.z = 0
		visual_offset.add_child(armature)
		offset = arm.get_node("Armature").position
	jingle.play_deconflicted(0.5)
	play_tween()
	
	# get the mesh bounding box and create and collision box using the resulting bounding box
	var aabb: AABB = get_visual_aabb(arm)
	var box: Shape3D = BoxShape3D.new()
	box.size = aabb.size
	collision_shape.shape = box
	
	# center the arm's position
	visual_offset.position -= aabb.position + aabb.size / 2
	default_pos = visual_offset.position
	
	unhighlight()

func _physics_process(delta):
	time += delta * FREQUENCY
	visual_offset.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))

func pick_up(player):
	unhighlight()
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
			if child.name == "Minimap Icon":
				continue
			mesh_list.append(child)
			meshes.append(child)
		meshes += get_all_mesh_instances(child) # recursion for nested children
	return meshes

func play_tween():
	tween = get_tree().create_tween()
	tween.tween_callback(func(): scale = Vector3.ZERO)
	tween.tween_property(self, "position:y", 0.75, 0.05).as_relative()
	tween.parallel().tween_property(self, "scale", default_scale * 1.5, 0.05)
	tween.tween_property(self, "scale", default_scale, 0.1)

func highlight():
	for m in mesh_list:
		var mat: ShaderMaterial = m.material_overlay
		if mat and mat is ShaderMaterial:
			mat.set_shader_parameter("strength", 0.075)

func unhighlight():
	for m in mesh_list:
		var mat: ShaderMaterial = m.material_overlay
		if mat and mat is ShaderMaterial:
			mat.set_shader_parameter("strength", 0.0)
