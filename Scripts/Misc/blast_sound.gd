extends Node3D

@onready var blast = $Blast
@onready var small_blast = $"Small Blast"
@onready var emb_blast = $"EMB Blast"
@onready var lightning = $Lightning
@onready var saw_hit = $"Saw Hit"

func _on_sound_finished():
	queue_free()

func _on_timer_timeout():
	queue_free()
