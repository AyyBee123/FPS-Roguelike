shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert;

uniform sampler2D cloud_texture;
uniform float distance_fade = 0.3;
uniform sampler2D depth_texture : hint_depth_texture;

void vertex() {
	vec2 uv = vec2(TIME) * vec2(0.1, 1.0) + UV;
	vec4 tex = texture(cloud_texture, uv);
	vec3 normal_shift = NORMAL * vec3(tex.r) * vec3(-0.3);
	VERTEX += normal_shift;
}

void fragment() {
	float depth_tex = texture(depth_texture, SCREEN_UV).r;
	vec4 depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth_tex, 1.0);
	depth_world_pos.xyz /= depth_world_pos.w;
	float fade = clamp(1.0 - smoothstep(depth_world_pos.z + distance_fade, depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	ALBEDO = COLOR.rgb;
	ALPHA = COLOR.a * fade;
}

void light() {
	float dot_product = dot(NORMAL, VIEW);
	float shading = smoothstep(0.0, 0.1, clamp(dot_product, 0.0, 1.0));
	vec3 diffuse = clamp(vec3(shading), vec3(0.1), vec3(1.0));
	DIFFUSE_LIGHT = diffuse;
}
