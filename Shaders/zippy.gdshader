shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

instance uniform vec3 zippy_albedo : source_color = vec3(0.86, 0.44, 0.2);
uniform float roughness : hint_range(0.0, 1.0);

void fragment() {
	ALBEDO = zippy_albedo;
	ROUGHNESS = roughness;
}
