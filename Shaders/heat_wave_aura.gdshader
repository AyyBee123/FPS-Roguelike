shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_disabled, diffuse_lambert, specular_schlick_ggx, depth_prepass_alpha, unshaded;

uniform vec2 displacement_speed = vec2(0.0, 1.0);
uniform vec2 displacement_scale = vec2(1.0, 1.0);
uniform sampler2D displacement_texture : source_color, repeat_enable;
uniform float displacement_intensity;
uniform sampler2D color_palette : source_color, filter_nearest;
uniform float opacity = 1.0;
uniform vec2 speed = vec2(0.0, 1.0);
uniform vec2 scale = vec2(1.0, 1.0);
uniform sampler2D texture_base : source_color, filter_nearest, repeat_enable;
uniform sampler2D texture_add : source_color, hint_default_black, filter_nearest;
uniform sampler2D texture_subtract : source_color, hint_default_black, filter_nearest;

void vertex() {
	vec3 vertex = VERTEX;
	float time = TIME;
	vec3 normal = NORMAL;
	
	vec2 displacement = (vec2(time) * displacement_speed + UV) * displacement_scale;
	vec4 tex = texture(displacement_texture, displacement);
	
	VERTEX = vertex + vec3(tex.r * displacement_intensity) * normal;
}

void fragment() {
	vec2 uv = UV;
	float time = TIME;
	
	vec4 albedo_tex = texture(color_palette, vec2(uv.y));
	float noise = texture(texture_base, (vec2(time) * speed + UV) * scale).r;
	float add = texture(texture_add, UV).r;
	float subtract = texture(texture_subtract, UV).r;
	float alpha = clamp(noise + add - subtract, 0.0, 1.0);
	
	ALBEDO = vec3(albedo_tex.xyz);
	ALPHA = opacity * alpha;
}
