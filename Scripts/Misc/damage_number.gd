extends Node3D

static var render_count: int = 0

@export var reference_distance := 1.0

@onready var label: Label3D = %Label3D
@onready var animation_player = %AnimationPlayer

var damage: float
var camera: Camera3D

func _ready():
	render_count = (render_count + 1) % 100
	label.render_priority = render_count
	label.outline_render_priority = render_count - 1
	
	if damage > 0 and damage < 1: damage = 1 # round up to 1 if the value is between 0 and 1
	label.text = str(int(damage))

func add_damage(amount: float):
	damage += amount
	label.text = str(int(damage))
	animation_player.play("new_animation")

func _on_animation_player_animation_finished(anim_name):
	queue_free()
