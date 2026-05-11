extends "res://Scripts/Projectiles/Player/projectile.gd"

var stacks: int = 0
var can_stack: bool = true

func _on_body_entered(body):
	if body is Enemy:
		if not body.has_meta("cactarm_stack"):
			body.set_meta("cactarm_stack", 0)
		if can_stack:
			body.set_meta("cactarm_stack", body.get_meta("cactarm_stack", 0) + 1)
		body.hit(damage * body.get_meta("cactarm_stack", 1), player, self)
	else:
		create_impact()
	queue_free()
