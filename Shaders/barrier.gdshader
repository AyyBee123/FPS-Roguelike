shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D border : repeat_disable, filter_nearest;
uniform vec2 scale = vec2(1.0, 1.0);
uniform sampler2D base_texture;
uniform float mask_strength = 1.0;

uniform vec3 emission_color : source_color;

uniform float pulse_speed : hint_range(0.1, 5.0) = 1.2;
uniform float pulse_width : hint_range(0.005, 0.5) = 0.06;
uniform float pulse_intensity : hint_range(0.0, 5.0) = 2.0;
uniform vec2 pulse_aspect = vec2(1.0, 1.0);

uniform sampler2D noise_texture;
uniform vec2 noise_speed;
uniform float noise_strength = 3.0;

void fragment() {
	vec2 center = vec2(0.5);
	vec2 uv = UV - center;
	
	vec4 border_tex = texture(border, UV);
	vec4 barrier_tex = texture(base_texture, (UV - 0.5) * scale + 0.5);
	vec4 tex = clamp(barrier_tex - border_tex, vec4(0.0), vec4(1.0));
	
	float noise_alpha = texture(noise_texture, UV + TIME * noise_speed).r;
	vec4 noise_tex = tex * noise_alpha * noise_strength;
	
	vec2 dir = UV - vec2(0.5);
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) / (PI * 2.0);
	vec2 polar = vec2(radius, angle);
	float mask = smoothstep(0.0, 0.8, pow(polar.r, mask_strength));
	
	vec4 albedo = border_color * border_tex + noise_tex.a * color * tex * vec4(mask) * (1.0 - border_tex.r);
	
	float pulse_dist = length(vec2(uv.x / pulse_aspect.x, uv.y / pulse_aspect.y));
	float pulse_time = mix(-0.5, 1.0, fract(TIME * pulse_speed));
	float ring = abs(pulse_dist - pulse_time);
	float pulse = smoothstep(pulse_width, 0.0, ring) * pulse_intensity;
	float edge_fade = 1.0 - smoothstep(0.0, 1.0, pulse_dist);
	
	pulse *= albedo.a;
	pulse *= (1.0 - border_tex.a);

	ALBEDO = albedo.xyz;
	EMISSION = emission_color * (1.0 - pulse);
	ALPHA = albedo.a + pulse;
}