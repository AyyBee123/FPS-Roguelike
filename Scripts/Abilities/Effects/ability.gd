class_name Ability extends Node

@export var ability_name: String

var player_owner: Player

func _ready():
	player_owner = get_parent().player
	SignalBus.enemy_hit.connect(_on_hit)

func _on_hit(source: Variant, player: Player, enemy: Enemy = null, damage: float = 0.0):
	pass

func _on_shoot(player: Player, arm: Arm, damage: float = 0.0):
	pass
