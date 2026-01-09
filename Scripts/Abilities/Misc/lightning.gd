extends Node3D

@export var soundboard: PackedScene

@onready var bolt: GPUParticles3D = %Bolt
@onready var blast: GPUParticles3D = %Blast

var damage: float

var player: Player

func _ready():
	var sb = soundboard.instantiate()
	get_tree().current_scene.add_child(sb)
	sb.global_position = global_position
	sb.lightning.play_deconflicted()
	
	bolt.one_shot = true
	blast.one_shot = true
	
	bolt.restart()
	blast.restart()
	
	blast.process_material.scale_min = scale.x
	blast.process_material.scale_max = scale.x

func _on_blast_finished():
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
