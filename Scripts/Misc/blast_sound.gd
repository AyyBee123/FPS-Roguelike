extends Node3D

@onready var blast = $Blast
@onready var lightning = $Lightning

func _on_sound_finished():
	queue_free()
