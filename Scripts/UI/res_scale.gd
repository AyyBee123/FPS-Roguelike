extends CanvasLayer

@onready var scalable_ui = %Scale
var base_resolution = Vector2(1920, 1080)

func _ready():
	get_viewport().size_changed.connect(_on_resize)
	_on_resize()

func _on_resize():
	var res = get_viewport().get_visible_rect().size
	var scale_factor = res.y / base_resolution.y
	scale_factor = clamp(scale_factor, 0.35, 1.75)
	scalable_ui.global_position = Vector2(res.x / 2, res.y / 2)
	scalable_ui.scale = Vector2(scale_factor, scale_factor)
