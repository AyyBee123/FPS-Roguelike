shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

#include "res://Shaders/z_clip_fov.gdshaderinc"

instance uniform vec3 zippy_albedo : source_color = vec3(0.86, 0.44, 0.2);
uniform float roughness : hint_range(0.0, 1.0);

void vertex() {
	apply_viewmodel(Z_CLIP_SCALE, PROJECTION_MATRIX);
}

void fragment() {
	ALBEDO = zippy_albedo;
	ROUGHNESS = roughness;
}
