extends Area3D

@onready var pillar: Boss = get_parent()

func _on_body_entered(body):
	if body is Player:
		body.velocity += Vector3((body.global_position - global_position).normalized().x * 1000, 15, 0)
		body.hit(20.0, global_position)
