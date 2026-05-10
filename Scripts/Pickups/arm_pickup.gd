class_name ArmPickup extends RigidBody3D

@export var arm_scene: PackedScene
@export var shader: Shader

@onready var collision_shape = %CollisionShape
@onready var visual_offset = %"Visual Offset"
@onready var jingle = %Jingle
@onready var arm_node = %"Arm Node"
@onready var default_scale = get_scale()

const AMPLITUDE: float = 0.05
const FREQUENCY: float = 1.0
const HIGHLIGHT_COLOR: Color = Color(0.88, 1.0, 0.0)

var rarity_weights
var arm: Arm
var arm_name: String
var offset: Vector3 = Vector3.ZERO
var armature: Node3D
var time: float = 0.0
var default_pos: Vector3
var mesh_list: Array
var tween: Tween
var rarity: int
var rarity_color: Color

func _ready():
	rarity_weights = get_tree().current_scene.get_node("%Arm Pool").rarity_weights
	
	if not arm_scene:
		if not arm:
			arm = get_tree().current_scene.get_node("%Arm Pool").roll()
	else:
		arm = arm_scene.instantiate()
	arm_name = arm.arm_name
	rarity = arm.rarity
	
	match rarity:
		0: rarity_color = Color("cccccc") # common
		1: rarity_color = Color("42d042") # uncommon
		2: rarity_color = Color("e68b19") # legendary
	
	var arm_mesh_list = arm.find_children("", "MeshInstance3D", true)
	
	setup_arm(arm_mesh_list)
	
	jingle.play_deconflicted(0.5)
	play_tween()
	visual_offset.add_child(arm)
	arm.animation_player.stop()
	unhighlight()

func _physics_process(delta):
	time += delta * FREQUENCY
	visual_offset.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))

func pick_up(player):
	for m: MeshInstance3D in mesh_list:
		m.material_overlay = null
	player.weapons_manager.swap_arm(arm)
	queue_free()

func setup_arm(arm_mesh_list: Array):
	for mesh in arm_mesh_list:
		set_material_override(mesh)
		#make_unique(mesh)
		mesh_list.append(mesh)
		
		# add item highlight shader
		var mat: ShaderMaterial = ShaderMaterial.new()
		mat.shader = shader
		mat.resource_local_to_scene = true
		mesh.material_overlay = mat
	
	# get the mesh bounding box and create and collision box using the resulting bounding box
	var aabb: AABB = get_visual_aabb(arm_mesh_list)
	var box: Shape3D = BoxShape3D.new()
	box.size = aabb.size
	collision_shape.shape = box
	
	# center the arm's position
	visual_offset.position -= aabb.position + aabb.size / 2
	default_pos = visual_offset.position

func get_visual_aabb(meshes: Array) -> AABB:
	var first: bool = true
	var combined: AABB = AABB()
	
	for mesh in meshes:
		var xform: Transform3D = mesh.transform
		var p: Node3D = mesh.get_parent()
		
		while p: # keep iterating through the parents
			xform = p.transform * xform
			if not p.get_parent() is Node3D: break
			p = p.get_parent()
		var aabb: AABB = transform_aabb(mesh.mesh.get_aabb(), xform)
		
		if first:
			combined = aabb
			first = false
		else:
			combined = combined.merge(aabb)
	
	return combined

func transform_aabb(aabb: AABB, xform: Transform3D) -> AABB:
	# get the corner points of the aabb box
	var points: Array[Vector3] = [
		Vector3(aabb.position.x, aabb.position.y, aabb.position.z),
		Vector3(aabb.position.x + aabb.size.x, aabb.position.y, aabb.position.z),
		Vector3(aabb.position.x, aabb.position.y + aabb.size.y, aabb.position.z),
		Vector3(aabb.position.x, aabb.position.y, aabb.position.z + aabb.size.z),
		Vector3(aabb.position.x + aabb.size.x, aabb.position.y + aabb.size.y, aabb.position.z),
		Vector3(aabb.position.x + aabb.size.x, aabb.position.y, aabb.position.z + aabb.size.z),
		Vector3(aabb.position.x, aabb.position.y + aabb.size.y, aabb.position.z + aabb.size.z),
		Vector3(aabb.position.x + aabb.size.x, aabb.position.y + aabb.size.y, aabb.position.z + aabb.size.z),
	]
	
	var result: AABB = AABB(xform * points[0], Vector3.ZERO)
	
	for i in range(1, points.size()):
		result = result.expand(xform * points[i])
	return result

func make_unique(node: Node) -> void:
	if node is MeshInstance3D:
		# make the mesh resource unique first
		if node.mesh:
			node.mesh = node.mesh.duplicate(true)
		
		if node.material_override:
			node.material_override = node.material_override.duplicate(true)

func set_material_override(mesh_instance: MeshInstance3D):
	mesh_instance.set_instance_shader_parameter("viewmodel_enabled", false)
	
	for i in range(mesh_instance.mesh.get_surface_count()):
		var material: Material = mesh_instance.mesh.surface_get_material(i)
		
		if material == null: continue
		
		if material is StandardMaterial3D:
			material.use_z_clip_scale = false
			material.use_fov_override = false
	
	var override: Material = mesh_instance.material_override
	
	if override and override is StandardMaterial3D:
		override.use_z_clip_scale = false
		override.use_fov_override = false

func play_tween():
	tween = get_tree().create_tween()
	tween.tween_callback(func(): scale = Vector3.ZERO)
	tween.tween_property(self, "position:y", 0.75, 0.05).as_relative()
	tween.parallel().tween_property(self, "scale", default_scale * 1.5, 0.05)
	tween.tween_property(self, "scale", default_scale * 1.25, 0.1)

func highlight():
	for m: MeshInstance3D in mesh_list:
		if m.material_overlay:
			m.material_overlay.set_shader_parameter("edge_color", HIGHLIGHT_COLOR)

func unhighlight():
	for m in mesh_list:
		if m.material_overlay:
			m.material_overlay.set_shader_parameter("edge_color", rarity_color)
