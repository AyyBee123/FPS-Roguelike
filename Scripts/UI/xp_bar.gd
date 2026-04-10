extends ProgressBar

@export var player: Player

func _physics_process(_delta):
	value = lerp(value, player.current_xp / player.XP_NEEDED, 0.25)
