extends Node3D

@export var color: Color = Color("fccf95")
@export_range(0, 3) var size: float = 1.0

var point: Node3D

func _ready():
	scale = Vector3.ONE * size

func play():
	rotate_z(randf_range(0, TAU))
	for particle in get_children():
		if particle is GPUParticles3D:
			particle.process_material.color = color
			particle.restart()
