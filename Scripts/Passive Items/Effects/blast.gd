extends Node3D

@export var soundboard: PackedScene

@onready var collision_shape = %CollisionShape3D
@onready var blast: GPUParticles3D = %Blast

var player: Player
var damage: float
var radius: float
var gradiant: GradientTexture1D

func _ready():
	var sb = soundboard.instantiate()
	get_tree().current_scene.add_child(sb)
	sb.global_position = global_position
	sb.blast.play_deconflicted()
	
	if gradiant:
		blast.draw_pass_1.surface_get_material(0).set_shader_parameter("gradiant", gradiant)
	
	blast.one_shot = true
	blast.restart()
	
	blast.process_material.scale_min = radius / 2
	blast.process_material.scale_max = radius / 2
	
	collision_shape.shape.radius = radius
	await get_tree().create_timer(0.25).timeout
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
