extends Area3D

var xp_amount: float = 1.0
var player = null

func _physics_process(delta):
	if player:
		position += (player.position - position) * delta * 10

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.gain_xp(xp_amount)
		queue_free()
