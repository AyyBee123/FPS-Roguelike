extends Node3D

@export var particles: Array[GPUParticles3D]

var color: Color = Color.WHITE
var max_lifetime: float
var size: float = 1.0

func _ready():
	for particle in particles:
		particle.restart()
		if particle.material_override is StandardMaterial3D:
			particle.material_override.albedo_color = color
		elif particle.material_override is ShaderMaterial:
			particle.material_override.set_shader_parameter("albedo", color)
		if size < 1:
			particle.process_material.scale_max *= size
		else:
			particle.process_material.scale_min *= size
		max_lifetime = max(particle.lifetime, max_lifetime)
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
