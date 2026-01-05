extends Node3D

@onready var ray_cast = %RayCast

func _ready():
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y # snap the enemy to the ground (with offset)
	
	var normal = ray_cast.get_collision_normal()
	transform.basis = Basis.looking_at(-global_transform.basis.z, normal.normalized())
