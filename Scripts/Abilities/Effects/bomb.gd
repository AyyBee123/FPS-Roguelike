extends RigidBody3D

@export var BLAST: PackedScene

var player: Player
var damage: float
var radius: float

func _on_body_entered(_body):
	explode()
	queue_free()

func explode():
	var blast = BLAST.instantiate()
	blast.player = player
	blast.damage = damage
	blast.radius = radius
	blast.make_sound = true
	get_tree().current_scene.add_child(blast)
	blast.global_position = global_position
