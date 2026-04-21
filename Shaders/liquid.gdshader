shader_type spatial;
render_mode cull_disabled, depth_draw_always, blend_mix, unshaded;

#include "res://Shaders/z_clip_fov.gdshaderinc"

uniform float liquid_height = 0.5;
uniform vec4 liquid_surface_color: source_color = vec4(0.7, 0.5, 1.0, 1.0);
uniform sampler2D liquid_rim_gradient;
uniform float rim_emission_intensity: hint_range(0.0, 2.0) = 0.2;
uniform float rim_exponent: hint_range(1.0, 10.0) = 3.0;
uniform float emission_intensity: hint_range(0.0, 3.0) = 0.1;
uniform float liquid_surface_gradient_size: hint_range(0.0, 3.0) = 0.1;
uniform vec2 wobble = vec2(0.0, 0.0); 
varying float y_coordinate;

mat4 rotate_x(in float angle) {
	return mat4(
			vec4(1.0,0.0,0.0,0.0),
			vec4(0.0,cos(angle),-sin(angle),0.0),
			vec4(0.0,sin(angle),cos(angle),0.0),
			vec4(0.0,0.0,0.0,1.0));
}

mat4 rotate_z(in float angle) {
	return mat4(
			vec4(cos(angle),-sin(angle), 0.0, 0.0),
			vec4(sin(angle),cos(angle), 0.0, 0.0),
			vec4(0.0,0.0,1.0,0.0),
			vec4(0.0,0.0,0.0,1.0));
}

void vertex() {
	apply_viewmodel(Z_CLIP_SCALE, PROJECTION_MATRIX);
	
	vec3 rotated_vert_z = (rotate_z(1.6) * vec4(VERTEX, 1.0)).xyz;
	vec3 rotated_vert_x = (rotate_x(-1.6) * vec4(VERTEX, 1.0)).xyz;
	vec3 vert = (rotated_vert_z * wobble.x + rotated_vert_x * wobble.y) + VERTEX;
	y_coordinate = (MODEL_MATRIX * (vec4(vert, 1.0))).y - MODEL_MATRIX[3].y;
}

void fragment() {
	float fresnel = dot(normalize(NORMAL), normalize(VERTEX));
	fresnel = abs(fresnel);
	fresnel = 1.0 - fresnel;
	float pow_fresnel = pow(fresnel, rim_exponent);
	if (y_coordinate > liquid_height) {
		discard;
	}
	if (FRONT_FACING) {
		vec4 liquid_color = texture(liquid_rim_gradient, vec2(pow_fresnel));
		float surface_component = smoothstep(
				liquid_height - liquid_surface_gradient_size,
				liquid_height,
				y_coordinate);
		
		ALBEDO = mix(liquid_color.rgb, liquid_surface_color.rgb, surface_component);
	
	} else {
		NORMAL = (INV_PROJECTION_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz;
		ALBEDO = liquid_surface_color.rgb;
		AO_LIGHT_AFFECT = 0.0;
	}
	
	EMISSION = ALBEDO * (pow_fresnel * rim_emission_intensity + emission_intensity);
}