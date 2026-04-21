shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

#include "res://Shaders/z_clip_fov.gdshaderinc"

instance uniform vec3 albedo_color : source_color = vec3(0.12, 0.12, 0.13);

void vertex() {
	apply_viewmodel(Z_CLIP_SCALE, PROJECTION_MATRIX);
}

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo_color;
	ALPHA = COLOR.a;
}
