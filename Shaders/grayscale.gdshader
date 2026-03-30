shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform float amount : hint_range(0.0, 1.0) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 col = texture(texture_albedo, UV);
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	ALBEDO = vec3(mix(col.rgb, vec3(gray), amount));
	ALPHA = col.a * alpha;
}