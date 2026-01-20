extends Node3D

var size: float = 1.0

func _ready():
	rotate_z(randf_range(0, TAU))
	for particle in get_children():
		if particle is GPUParticles3D:
			particle.restart()
			if size < 1:
				particle.process_material.scale_max *= size
			else:
				particle.process_material.scale_min *= size

func set_color(color: Color):
	for particle in get_children():
		if particle is GPUParticles3D:
			particle.process_material.color = color

func _on_muzzle_planes_finished():
	queue_free()
