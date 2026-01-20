extends Node3D

@export var soundboard: PackedScene
@export var particles: Array[GPUParticles3D]

@onready var blast = %Blast

var damage: float

var player: Player
var max_lifetime: float

func _ready():
	var sb = soundboard.instantiate()
	get_tree().current_scene.add_child(sb)
	sb.global_position = global_position
	sb.lightning.play_deconflicted()
	
	for particle in particles:
		particle.restart()
		max_lifetime = max(particle.lifetime, max_lifetime)
		blast.scale = scale
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
