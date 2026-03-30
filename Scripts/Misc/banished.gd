extends Node3D

var item: Item

@onready var sprite_3d = %Sprite3D

func _ready():
	sprite_3d.texture = item.icon
	sprite_3d.material_override.set_shader_parameter("texture_albedo", item.icon)

func _physics_process(delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		%Node3D.look_at(camera.global_position, Vector3.UP)
	sprite_3d.material_override.set_shader_parameter("alpha", sprite_3d.modulate.a)
