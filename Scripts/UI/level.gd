extends Label

@export var player: CharacterBody3D

func _physics_process(delta):
	text = "LVL %s" % str(player.current_level)
