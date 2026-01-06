class_name Chest extends Node3D

@onready var ray_cast = %RayCast
@onready var animation_player = %AnimationPlayer

var is_open: bool = false

func _ready():
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	
	var normal = ray_cast.get_collision_normal()
	transform.basis = Basis.looking_at(-global_transform.basis.z, normal.normalized())

func open(player: Player):
	if is_open: return
	is_open = true
	
	animation_player.play("Open")

func roll_item():
	var item = ItemPool.roll()
	
