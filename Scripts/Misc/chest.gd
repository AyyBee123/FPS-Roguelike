class_name Chest extends Node3D

@onready var ray_cast = %RayCast
@onready var chest_ray_cast = %"Chest RayCast"
@onready var animation_player = %AnimationPlayer
@onready var item_marker = %"Item Marker"
@onready var collision_shape = %CollisionShape3D
@onready var armature = %Armature
@onready var chest_check = %"Chest Check"
@onready var chest_open = %ChestOpen

@export var ITEM = preload("uid://dyk4mpi4d6hrl")

var can_open: bool = false
var is_open: bool = false:
	set(value):
		is_open = value
		collision_shape.disabled = value

var item: ItemPickup

func _ready():
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
	transform.basis = Basis.looking_at(-global_transform.basis.z, normal.normalized())
	
	armature.rotation.y = randf_range(0, TAU)

func open(player: Player):
	if is_open: return
	is_open = true
	
	chest_open.play_deconflicted()
	
	animation_player.play("Open")

func roll_item(): # called from the animation player
	var rolled_item: Item = ItemPool.roll()
	item = ITEM.instantiate()
	item.item = rolled_item
	get_tree().current_scene.add_child(item)
	item.global_position = item_marker.global_position

func check_for_chest():
	for i in 30:
		if chest_ray_cast.get_collider():
			position = get_tree().current_scene.find_chest_spawn()
			continue
		else:
			break

func _on_visible_on_screen_notifier_3d_screen_exited():
	if is_open and not item:
		queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spawn":
		can_open = true
