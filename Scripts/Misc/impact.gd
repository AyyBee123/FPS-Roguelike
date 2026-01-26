extends Node3D

@export var particles: Array[GPUParticles3D]

var color: Color = Color.WHITE
var max_lifetime: float

func _ready():
	for particle in particles:
		particle.restart()
		if particle.material_override is StandardMaterial3D:
			particle.material_override.albedo_color = color
		elif particle.material_override is ShaderMaterial:
			particle.set_instance_shader_parameter("albedo_color", color)
		max_lifetime = max(particle.lifetime, max_lifetime)
	
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
