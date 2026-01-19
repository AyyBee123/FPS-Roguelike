extends Node3D

@export var particles: Array[GPUParticles3D]

var color: Color = Color.WHITE
var max_lifetime: float
var size: float = 1.0

func _ready():
	for particle in particles:
		particle.restart()
		particle.material_override.albedo_color = color
		particle.process_material.scale_min *= size
		max_lifetime = max(particle.lifetime, max_lifetime)
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
