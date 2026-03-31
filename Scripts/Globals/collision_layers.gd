extends Node

# dictionary automatically built from ProjectSettings layer names
var layer_bits: Dictionary = {}

func _ready():
	# detect both 2D and 3D layer settings
	var prefix: String = "layer_names/3d_physics"
	if not ProjectSettings.has_setting(prefix + "/layer_1"):
		prefix = "layer_names/2d_physics"
	
	for i in range(1, 33):
		@warning_ignore("shadowed_variable_base_class")
		var name = ProjectSettings.get_setting("%s/layer_%d" % [prefix, i])
		if name != "":
			layer_bits[name] = 1 << (i - 1)

func get_layer(names: Array) -> int:
	var mask: int = 0
	for n in names:
		if layer_bits.has(n):
			mask |= layer_bits[n]
		else:
			push_warning("Unknown layer name: %s" % n)
	return mask
