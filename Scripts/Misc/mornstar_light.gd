extends MeshInstance3D

@onready var ding = $Ding
@onready var light_switch = $"Light Switch"

var lit_color: Color = Color("f45368")
var unlit_color: Color = Color("1f1f23")

var lit: bool = false: set = set_bulb

func set_bulb(value):
	lit = value
	if value:
		set_instance_shader_parameter("albedo_color", lit_color)
		ding.play_deconflicted()
		light_switch.play_deconflicted()
	else:
		set_instance_shader_parameter("albedo_color", unlit_color)
