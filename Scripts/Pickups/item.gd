extends Node3D

var time: float = 0.0
var amplitude: float = 0.1
var frequency: float = 2.0

@onready var mesh_instance = %MeshInstance
@onready var default_pos = mesh_instance.get_position()

func _physics_process(delta):
	rotate_y(PI/2 * delta)
	
	time += delta * frequency
	mesh_instance.set_position(default_pos + Vector3(0, sin(time) * amplitude, 0))
