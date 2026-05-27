class_name ArmoryBox extends RigidBody3D

@export var arm: PackedScene
@export var meshes: Array[MeshInstance3D]

@onready var armature = %Armature
@onready var animation_player = %AnimationPlayer
@onready var collision_shape = %CollisionShape3D
@onready var ray_cast = %RayCast
@onready var chest_ray_cast = %"Chest RayCast"
@onready var chest_check = %"Chest Check"
@onready var arm_marker = %"Arm Marker"

var is_open: bool = false:
	set(value):
		is_open = value
		collision_shape.disabled = value

var arm_pickup: ArmPickup
var arm_spawned: bool = false

func _ready():
	unhighlight()
	
	armature.scale = Vector3.ZERO
	animation_player.play("Close")
	animation_player.play("Spawn")
	
	chest_ray_cast.global_transform = Transform3D(Basis(), chest_ray_cast.global_position) # lock the ray's rotation
	chest_ray_cast.force_raycast_update() # detect chests immediately
	check_for_chest()
	
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	
	armature.rotation.y = randf_range(0, TAU)

func open(_player: Player):
	if is_open: return
	is_open = true
	animation_player.play("Open")

func check_for_chest():
	for i in 30:
		if chest_ray_cast.get_collider():
			position = GameState.current_level.find_chest_spawn()
			continue
		else:
			break

func spawn_arm():
	arm_pickup = arm.instantiate()
	arm_pickup.rotation.y = rotation.y + armature.rotation.y - PI/2
	get_tree().current_scene.add_child(arm_pickup)
	arm_pickup.global_position = arm_marker.global_position
	arm_spawned = true

func play_sound(audio: String, pos: float = 0.0): # called from animation player
	get_node("%" + audio).play_deconflicted(pos)

func highlight():
	for m in meshes:
		var mat: ShaderMaterial = m.material_overlay
		if mat and mat is ShaderMaterial:
			mat.set_shader_parameter("strength", 0.05)

func unhighlight():
	for m in meshes:
		var mat: ShaderMaterial = m.material_overlay
		if mat and mat is ShaderMaterial:
			mat.set_shader_parameter("strength", 0.0)

func _on_visible_on_screen_notifier_3d_screen_exited():
	if arm_spawned and not arm_pickup:
		queue_free()
