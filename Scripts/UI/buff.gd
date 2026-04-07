class_name Buff extends Control

@onready var icon = %Icon
@onready var number = %Number

var cooldown: float = 0.0

var source: Node

func _physics_process(_delta):
	if not is_instance_valid(source):
		queue_free()

func set_buff(_num):
	pass
