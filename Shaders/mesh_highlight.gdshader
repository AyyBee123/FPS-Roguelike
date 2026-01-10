shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_disabled;

uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	ALBEDO = vec3(0.88, 1.0, 0.0);
	ALPHA = strength;
}
