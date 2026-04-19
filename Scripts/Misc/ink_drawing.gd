extends Decal

var laser: Node3D
var tween: Tween

func _ready():
	fade_out()

func fade_out():
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "size", Vector3(0, 0.5, 0), 2)
	tween.tween_callback(queue_free)

func quick_fade_out():
	if tween: tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "size", Vector3(0, 0.5, 0), 0.25)
	tween.parallel().tween_property(self, "modulate:a", 0.25, 0.25)
	tween.tween_callback(queue_free)

func _exit_tree():
	if laser:
		laser.trail_points.erase(self)
