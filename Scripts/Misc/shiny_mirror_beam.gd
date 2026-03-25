extends Node3D

@onready var beam: MeshInstance3D = %Beam
@onready var outer_beam: MeshInstance3D = %"Outer Beam"

var target: Enemy
var origin: Enemy

func _ready():
	set_beam_length(0.05)

func _physics_process(delta):
	if is_instance_valid(origin):
		global_position = origin.global_position
	
	if is_instance_valid(target):
		look_at(target.global_position)
		set_beam_length(global_position.distance_to(target.global_position))

func set_beam_length(length: float):
	beam.scale.z = length / 2
	outer_beam.scale.z = length / 2

func _on_animation_player_animation_finished(anim_name):
	queue_free()
