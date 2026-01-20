extends Node3D

func _ready():
	randomize()
	rotate_z(randf_range(0, TAU))
	for particle in get_children():
		if particle is GPUParticles3D:
			particle.restart()

func set_color(color: Color):
	for particle in get_children():
		if particle is GPUParticles3D:
			particle.process_material.color = color

func _on_muzzle_planes_finished():
	queue_free()
