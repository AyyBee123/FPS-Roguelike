extends Area3D

@onready var pillar: Boss = get_parent()

func _ready():
	$CollisionShape3D.disabled = true

func _on_body_entered(body):
	if body is Player:
		body.velocity += Vector3(
			(body.global_position - global_position).normalized().x * 1000,
			15,
			Vector3.RIGHT.rotated(Vector3.UP, pillar.rotation.y).z
		)
		body.hit(20.0, global_position)
