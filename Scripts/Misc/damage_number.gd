extends Node3D

static var render_count: int = 0
static var outline_count: int = -1

@export var reference_distance := 1.0

@onready var label: Label3D = %Label3D

var damage: float
var camera: Camera3D

func _ready():
	render_count = (render_count + 1) % 100
	outline_count = (outline_count + 1) % 100
	
	label.render_priority = render_count
	label.outline_render_priority = outline_count
	label.text = str(int(damage))

func _on_animation_player_animation_finished(anim_name):
	queue_free()
