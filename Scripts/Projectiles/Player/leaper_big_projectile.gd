extends "res://Scripts/Projectiles/Player/leaper_projectile.gd"

func _on_body_entered(body):
	if ignored.has(body):
		return
	if body is Enemy:
		body.hit(damage * 1.5, player, self)
		bounce(body)
	else:
		create_impact()
	if target: return
	queue_free()
