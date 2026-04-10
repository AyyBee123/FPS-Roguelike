extends Label

@export var player: Player

func _physics_process(_delta):
	text = "LEVEL  %s" % str(player.current_level)
