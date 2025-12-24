extends Node3D

@export var tick_node: PackedScene
@export var tick_rate: float = 0.1

var damage: float

var player: Player

func _on_area_3d_body_entered(body):
	if body is Enemy:
		var tick = tick_node.instantiate()
		tick.player = player
		tick.source = self
		tick.damage = damage
		tick.tick_rate = tick_rate
		body.add_child(tick)

func _on_area_3d_body_exited(body):
	if body is Enemy:
		var tick = body.get_node_or_null("Tick Damage")
		if tick:
			body.remove_child(tick)
