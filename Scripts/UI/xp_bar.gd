extends ProgressBar

@export var player: CharacterBody3D

func _physics_process(delta):
	value = player.current_xp as float / player.XP_NEEDED
