extends Ability

@export var projection: PackedScene

var node: Node3D

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if player and get_parent() == player.abilities and not node:
		node = projection.instantiate()
		node.ability = self
		node.player = player
		player.camera.add_child(node)

## gets the base stat value, after calculating ability stats
func get_base_stat_value(stat_type: String, value: Variant = null):
	if value == null:
		value = stats[stat_type]["base"]
	return value * (1 + stats[stat_type]["+"] + stats[stat_type]["flat"]) * stats[stat_type]["x"]
