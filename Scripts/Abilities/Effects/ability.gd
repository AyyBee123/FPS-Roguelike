class_name Ability extends Node

@export var ability_name: String

var player: Player

func _ready():
	player = get_parent().player
	player.enemy_hit.connect(_on_hit)

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	pass

func _on_shoot(player: Player, arm: Arm, damage: float):
	pass
