shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_disabled, diffuse_toon, specular_toon;

uniform vec2 texture_scale = vec2(1.0);
uniform sampler2D dissolve_texture;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

uniform float light_attenuation = 1.3;
uniform float shadow_roundness = 1.0;
uniform sampler2D shading_gradient: source_color, hint_default_black;

void fragment() {
	vec2 uv = UV * texture_scale;
	vec4 tex = texture(dissolve_texture, uv);
	ALBEDO = vec3(COLOR.xyz);
	ALPHA = tex.r;
	ALPHA_SCISSOR_THRESHOLD = COLOR.a * opacity;
}

void light() {
	float dot_product = dot(NORMAL, LIGHT);
	float atten = (clamp(dot_product, -0.90, 0.90) + 1.0) * 0.47 * light_attenuation;
	float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), shadow_roundness);
	float round_cell_shade = clamp(atten, 0.04, 0.98) * fresnel;
	vec4 gradient = texture(shading_gradient, vec2(round_cell_shade));
	DIFFUSE_LIGHT = clamp(LIGHT_COLOR * vec3(gradient.xyz), vec3(0), vec3(1));
}
