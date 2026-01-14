class_name Buff extends Control

@onready var icon = %Icon
@onready var number = %Number

var cooldown: float = 0.0

var source: Node

func _ready():
	if source is Item or source is Ability:
		icon.texture = source.icon

func set_buff(_num):
	pass
