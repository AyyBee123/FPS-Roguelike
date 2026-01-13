extends Node3D

@onready var ray_cast = %RayCast3D
@onready var decal = %Decal

func _physics_process(delta):
	decal.global_position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	decal.rotation.y += delta * PI
