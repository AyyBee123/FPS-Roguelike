shader_type spatial;
render_mode unshaded, cull_front, blend_mix, depth_draw_always;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 fresnel_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float fresnel_amount = 4.0;
uniform float fresnel_intensity = 4.5;

instance uniform bool viewmodel_enabled = false;
instance uniform float z_clip_scale : hint_range(0.01, 1.0, 0.01) = 0.8;
instance uniform float fov_override : hint_range(1.0, 179.0, 0.1) = 100.0;

uniform float speed : hint_range(0.0, 100.0) = 2.0;
uniform float amplitude : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	VERTEX.y += sin(TIME * speed) * amplitude;
	
	if (viewmodel_enabled) {
		Z_CLIP_SCALE = z_clip_scale;
		
		if (!IN_SHADOW_PASS) {
			float flip_y = sign(PROJECTION_MATRIX[1][1]);
			float aspect = PROJECTION_MATRIX[1][1] / PROJECTION_MATRIX[0][0];
			float f = flip_y / tan(fov_override * PI / 360.0);
			PROJECTION_MATRIX[0][0] = f / aspect;
			PROJECTION_MATRIX[1][1] = f;
		}
	}
}

vec4 fresnel_glow(float amount, float intensity, vec4 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	vec4 fresnel = fresnel_glow(fresnel_amount, fresnel_intensity, fresnel_color, NORMAL, VIEW);
	ALBEDO = base_color.rgb + fresnel.rgb;
	ALPHA = base_color.a + fresnel.a;
}

