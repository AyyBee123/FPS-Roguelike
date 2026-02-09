extends Node3D

var max_lifetime: float = 0.0

func _ready():
	for particle in get_children():
		if not particle is GPUParticles3D: continue
		particle.restart()
		max_lifetime = max(particle.lifetime, max_lifetime)
	%MinibossSpawn.play_deconflicted()
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()
