extends HBoxContainer

@export var player: Player

@onready var label = $Label

var kill_count: int = 0

func _ready():
	player.enemy_killed.connect(update_kill_count)

func update_kill_count(enemy: Enemy, source: Variant, damage: float):
	kill_count += 1
	label.text = str(kill_count)
