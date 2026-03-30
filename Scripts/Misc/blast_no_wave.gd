extends Node3D

@onready var blast = %Blast

var player: Player
var radius: float
var color: Color = Color.SANDY_BROWN

func _ready():
	blast.restart()
	blast.set_instance_shader_parameter("albedo_color", color)
	scale = Vector3.ONE * radius

func _on_blast_finished():
	queue_free()
