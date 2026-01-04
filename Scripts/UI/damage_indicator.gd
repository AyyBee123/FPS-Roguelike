extends Control

var tween: Tween

func _ready():
	modulate.a = 0
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.05)
	tween.tween_interval(0.2)
	tween.tween_property(self, "modulate:a", 0, 0.125)
	tween.tween_callback(queue_free)
