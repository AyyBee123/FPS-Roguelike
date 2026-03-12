extends Node3D

@export var particles: Array[GPUParticles3D]
@export var soundboard: PackedScene

@onready var collision_shape: CollisionShape3D = %CollisionShape3D

var player: Player
var damage: float
var radius: float
var make_sound: bool = true
var color: Color = Color.SANDY_BROWN
var max_lifetime: float

func _ready():
	if make_sound:
		var sb = soundboard.instantiate()
		get_tree().current_scene.add_child(sb)
		sb.global_position = global_position
		sb.emb_blast.play_deconflicted()
	
	scale = Vector3.ONE * radius
	
	for particle in particles:
		particle.restart()
		if particle.material_override is StandardMaterial3D:
			particle.material_override.albedo_color = color
		elif particle.material_override is ShaderMaterial:
			particle.set_instance_shader_parameter("albedo_color", color)
		max_lifetime = max(particle.lifetime, max_lifetime)
	
	await get_tree().create_timer(max_lifetime).timeout
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)

func _on_blast_finished():
	collision_shape.disabled = true
