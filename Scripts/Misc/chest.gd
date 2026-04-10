class_name Chest extends Node3D

@onready var ray_cast = %RayCast
@onready var chest_ray_cast = %"Chest RayCast"
@onready var animation_player = %AnimationPlayer
@onready var item_marker = %"Item Marker"
@onready var collision_shape = %CollisionShape3D
@onready var armature = %Armature
@onready var chest_check = %"Chest Check"
@onready var chest_open = %ChestOpen
@onready var cost_label = %"Cost Label"

@export var ITEM: PackedScene
@export var meshes: Array[MeshInstance3D]

var can_open: bool = false
var is_open: bool = false:
	set(value):
		is_open = value
		collision_shape.disabled = value

var item: ItemPickup
var item_spawned: bool = false
var cost: int = 0

func _ready():
	GameState.current_level.cost_increased.connect(cost_changed)
	cost_changed()
	
	unhighlight()
	
	armature.scale = Vector3.ZERO
	animation_player.play("RESET")
	animation_player.play("Close")
	animation_player.play("Spawn")
	
	chest_ray_cast.global_transform = Transform3D(Basis(), chest_ray_cast.global_position) # lock the ray's rotation
	chest_ray_cast.force_raycast_update() # detect chests immediately
	check_for_chest()
	
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	
	var normal = ray_cast.get_collision_normal()
	if normal == Vector3.ZERO:
		normal = Vector3.UP
	transform.basis = Basis.looking_at(-global_transform.basis.z, normal.normalized())
	
	armature.rotation.y = randf_range(0, TAU)

func open(_player: Player):
	if is_open: return
	is_open = true
	
	chest_open.play_deconflicted()
	
	cost_label.visible = false
	animation_player.play("Open")
	
	# increase the cost of all chests and armory boxes
	GameState.current_level.increase_costs()

func roll_item(): # called from the animation player
	item = ITEM.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = item_marker.global_position
	item_spawned = true

func check_for_chest():
	for i in 30:
		if chest_ray_cast.get_collider() and chest_ray_cast.get_collider() != chest_check:
			position = GameState.current_level.find_chest_spawn()
			chest_ray_cast.force_raycast_update()
		else:
			break

func cost_changed():
	cost = GameState.current_level.chest_cost
	cost_label.text = "%d¢" % cost

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
	if item_spawned and not item:
		queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spawn":
		can_open = true
