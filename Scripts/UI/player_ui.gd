extends Control

@export var player: Player
@export var marker: PackedScene

@onready var damage_indicators: Control = %"Damage Indicators"


func _ready():
	player.hit_taken.connect(_on_taking_damage)

func _on_taking_damage(pos):
	var mk = marker.instantiate()
	mk.rotation = pos.angle()
	damage_indicators.add_child(mk)
