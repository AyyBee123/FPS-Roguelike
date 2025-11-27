extends Node3D

@onready var blast = %GPUParticles3D

func _ready():
	blast.one_shot = true
	blast.restart()

func _on_gpu_particles_3d_finished():
	queue_free()
