extends Node3D

func _physics_process(delta):
	rotate_y(PI/2 * delta)
