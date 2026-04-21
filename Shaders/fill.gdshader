shader_type spatial;
render_mode unshaded, cull_disabled;

#include "res://Shaders/z_clip_fov.gdshaderinc"

uniform vec3 empty_albedo : source_color;
uniform vec3 fill_albedo : source_color;

instance uniform float fill_amount : hint_range(0.0, 1.0);
uniform float fill_multiplier : hint_range(0.0, 1.0) = 1.0;
uniform float fill_offset : hint_range(0.0, 1.0) = 0.8;

void vertex() {
	apply_viewmodel(Z_CLIP_SCALE, PROJECTION_MATRIX);
}

void fragment() {
	float fill;
	if (1.0 - UV.y < fill_amount * fill_multiplier + fill_offset) {
		fill = 0.0;
	} else {
		fill = 1.0;
	}
	ALBEDO = mix(fill_albedo, empty_albedo, fill);
}
