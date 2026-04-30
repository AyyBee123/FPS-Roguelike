shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_disabled, diffuse_lambert, specular_schlick_ggx, unshaded;

instance uniform vec3 player_position = vec3(0.0);
uniform float reveal_radius : hint_range(0.5, 20.0) = 0.5;
uniform float edge_softness : hint_range(0.1, 5.0) = 4.0;
uniform float max_alpha : hint_range(0.0, 1.0) = 0.5;
uniform float min_alpha : hint_range(0.0, 1.0) = 0.0;

uniform vec4 albedo : source_color = vec4(0.322, 0.769, 1.0, 1.0);
uniform sampler2D albedo_texture : source_color, hint_default_white;
uniform vec2 texture_scale = vec2(1.0);
uniform float emission_strength : hint_range(0.0, 4.0) = 1.0;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float pos = distance(
		vec3(world_pos.x, world_pos.y, world_pos.z),
		vec3(player_position.x, player_position.y, player_position.z)
	);
	
	float reveal = 1.0 - smoothstep(
		reveal_radius - edge_softness,
		reveal_radius + edge_softness,
		pos
	);

	vec4 tex = texture(albedo_texture, (UV - 0.5) * texture_scale + 0.5);
	vec3 col = albedo.rgb * tex.rgb;
	float alpha = mix(min_alpha, max_alpha, reveal);

	ALBEDO = col;
	ALPHA = alpha * tex.r;
	EMISSION = col * emission_strength * reveal;
}
