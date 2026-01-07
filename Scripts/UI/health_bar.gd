extends ProgressBar

@export var player: Player

@onready var text = %"Health Text"

func _physics_process(delta):
	value = lerp(value, player.current_health / player.MAX_HEALTH, 0.25)
	text.text = "%d / %d" % [player.current_health, player.MAX_HEALTH]
