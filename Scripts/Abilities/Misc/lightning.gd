extends Node3D

@onready var bolt: GPUParticles3D = %Bolt
@onready var blast: GPUParticles3D = %Blast
@onready var lightning = %Lightning

var damage: float

var player: Player

func _ready():
	lightning.play_deconflicted()
	
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
