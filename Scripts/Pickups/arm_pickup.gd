class_name ArmPickup extends RigidBody3D

@export var arm_scene: PackedScene
@export var shader: Shader

@onready var collision_shape = %CollisionShape
@onready var visual_offset = %"Visual Offset"
@onready var jingle = %Jingle
@onready var default_scale = get_scale()

const AMPLITUDE: float = 0.05
const FREQUENCY: float = 1.0
const HIGHLIGHT_COLOR: Color = Color(0.88, 1.0, 0.0)

var arm: Arm
var arm_name: String
var rarity_weights = ArmPool.rarity_weights
var offset: Vector3 = Vector3.ZERO
var armature: Node3D
var time: float = 0.0
var default_pos: Vector3
var mesh_list: Array[MeshInstance3D]
var tween: Tween
var rarity: int
var rarity_color: Color

func _ready():
	if not arm_scene:
		if not arm:
			arm = ArmPool.roll()
	else:
		arm = arm_scene.instantiate()
	arm_name = arm.arm_name
	rarity = arm.rarity
	
	match rarity:
		0: # common
			rarity_color = Color("cccccc")
		1: # uncommon
			rarity_color = Color("42d042")
		2: # legendary
			rarity_color = Color("e68b19")
	
	if arm.get_node_or_null("Armature"):
		armature = arm.get_node("Armature").duplicate()
		make_unique(armature)
		armature.position.z = 0
		visual_offset.add_child(armature)
		offset = arm.get_node("Armature").position
	jingle.play_deconflicted(0.5)
	play_tween()
	
	# get the mesh bounding box and create and collision box using the resulting bounding box
	var aabb: AABB = get_visual_aabb(armature)
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
	player.weapons_manager.swap_arm(arm)
	queue_free()

func get_visual_aabb(root: Node3D) -> AABB:
	var meshes: Array = get_all_mesh_instances(root)
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
			var mat: ShaderMaterial = ShaderMaterial.new()
			mat.shader = shader
			child.material_overlay = mat
			mesh_list.append(child)
			meshes.append(child)
		meshes += get_all_mesh_instances(child) # recursion for nested children
	return meshes

func make_unique(root: Node) -> void:
	for node in root.get_children():
		if node is MeshInstance3D:
			# Duplicate the mesh
			if node.mesh:
				node.mesh = node.mesh.duplicate()
				
			# duplicate all materials
			for i in node.get_surface_override_material_count():
				var mat = node.get_surface_override_material(i)
				if mat:
					node.set_surface_override_material(i, mat.duplicate())
			
			# also handle mesh surface materials
			if node.mesh:
				for i in node.mesh.get_surface_count():
					var mat = node.mesh.surface_get_material(i)
					if mat:
						node.mesh.surface_set_material(i, mat.duplicate())
		make_unique(node)

func play_tween():
	tween = get_tree().create_tween()
	tween.tween_callback(func(): scale = Vector3.ZERO)
	tween.tween_property(self, "position:y", 0.75, 0.05).as_relative()
	tween.parallel().tween_property(self, "scale", default_scale * 1.5, 0.05)
	tween.tween_property(self, "scale", default_scale * 1.25, 0.1)

func highlight():
	for m in mesh_list:
		if m.material_overlay:
			m.set_instance_shader_parameter("edge_color", HIGHLIGHT_COLOR)

func unhighlight():
	for m in mesh_list:
		if m.material_overlay:
			m.set_instance_shader_parameter("edge_color", rarity_color)
