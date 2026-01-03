extends Label

@export var player: Player

func _physics_process(delta):
	text = "LEVEL  %s" % str(player.current_level)
