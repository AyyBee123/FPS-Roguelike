extends Node3D

@onready var blast = $Blast
@onready var emb_blast = $"EMB Blast"
@onready var lightning = $Lightning

func _on_sound_finished():
	queue_free()

func _on_timer_timeout():
	queue_free()
