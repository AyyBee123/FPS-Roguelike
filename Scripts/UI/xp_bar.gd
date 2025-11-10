extends ProgressBar

@export var player: Player

func _physics_process(delta):
	value = player.current_xp as float / player.XP_NEEDED
