extends ProgressBar

@export var player: Player

#func _physics_process(delta):
	#value = max_value - player.dash_cooldown / player.dash_cooldown.wait_time
