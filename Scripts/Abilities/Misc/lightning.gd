extends Node3D

@onready var bolt = %Bolt
@onready var blast = %Blast

var damage: float
var radius: float = 2.25

func _ready():
	bolt.one_shot = true
	blast.one_shot = true
	
	bolt.restart()
	blast.restart()

func _on_blast_finished():
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, self)
