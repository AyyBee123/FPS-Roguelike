extends Ability

@export var heat_wave: PackedScene

var node: Node3D

func _physics_process(delta):
	super._physics_process(delta)
	
	if player and get_parent() == player.abilities and not node:
		node = heat_wave.instantiate()
		node.ability = self
		node.player = player
		player.add_child(node)
