class_name Ability extends Node

@export var ability_name: String

func _ready():
	SignalBus.enemy_hit.connect(_on_hit)

func _on_hit(source: Variant, enemy: Enemy = null, damage: float = 0.0):
	pass

func _on_shoot(player: Player, arm: Arm, damage: float = 0.0):
	pass
