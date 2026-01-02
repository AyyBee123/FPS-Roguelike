extends TextureProgressBar

@export var player: Player

@onready var text = %"Health Text"

func _physics_process(delta):
	value = player.current_health / player.MAX_HEALTH
	text.text = "%d / %d" % [player.current_health, player.MAX_HEALTH]
