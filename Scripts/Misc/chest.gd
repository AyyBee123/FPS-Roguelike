class_name Chest extends Node3D

@onready var ray_cast = %RayCast
@onready var animation_player = %AnimationPlayer
@onready var item_marker = %"Item Marker"
@onready var collision_shape = %CollisionShape3D
@onready var armature = %Armature

@export var ITEM = preload("uid://dyk4mpi4d6hrl")

var is_open: bool = false:
	set(value):
		is_open = value
		collision_shape.disabled = value

var item: ItemPickup

func _ready():
	animation_player.play("RESET")
	animation_player.play("Close")
	animation_player.play("Spawn")
	
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	
	var normal = ray_cast.get_collision_normal()
	transform.basis = Basis.looking_at(-global_transform.basis.z, normal.normalized())
	
	armature.rotate_z(randf_range(0, TAU))

func open(player: Player):
	if is_open: return
	is_open = true
	
	animation_player.play("Open")

func roll_item(): # called from the animation player
	var rolled_item: Item = ItemPool.roll()
	item = ITEM.instantiate()
	item.item = rolled_item
	get_tree().current_scene.add_child(item)
	item.global_position = item_marker.global_position

func _on_visible_on_screen_notifier_3d_screen_exited():
	if is_open and not item:
		queue_free()
