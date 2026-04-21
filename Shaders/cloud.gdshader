shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert;

uniform sampler2D cloud_texture;
uniform float distance_fade = 0.3;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;

void vertex() {
	vec2 uv = vec2(TIME) * vec2(0.1, 1.0) + UV;
	vec4 tex = texture(cloud_texture, uv);
	vec3 normal_shift = NORMAL * (tex.r * -0.3);
	VERTEX += normal_shift;
}

void fragment() {
	float depth_raw = texture(depth_texture, SCREEN_UV).r;
	float depth_linear = INV_PROJECTION_MATRIX[3][2] / (depth_raw + INV_PROJECTION_MATRIX[2][2]);
	float fade = clamp(1.0 - smoothstep(depth_linear + distance_fade, depth_linear, VERTEX.z), 0.0, 1.0);
	ALBEDO = COLOR.rgb;
	if (fade <= 0.01) discard;
    ALPHA = COLOR.a * fade;
}

void light() {
	float shading = max(dot(NORMAL, VIEW), 0.2);
	DIFFUSE_LIGHT = vec3(shading);
}
