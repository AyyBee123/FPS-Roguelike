extends Node3D

@export var tick_node: PackedScene
@export var tick_rate: float = 0.1

var damage: float

var player: Player

var enemies: Array[Enemy]
var tick_nodes: Array[Node]

func _on_area_3d_body_entered(body):
	if body is Enemy:
		var tick = tick_node.instantiate()
		tick.player = player
		tick.source = self
		tick.damage = damage
		tick.tick_rate = tick_rate
		body.add_child(tick)
		enemies.append(body)
		tick_nodes.append(tick)

func _on_area_3d_body_exited(body):
	if body is Enemy:
		var index = enemies.find(body)
		if index == -1: return
		
		var tick = tick_nodes.get(index)
		tick_nodes.remove_at(index)
		enemies.remove_at(index)
		tick.queue_free()
