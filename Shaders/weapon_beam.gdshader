shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform vec3 color_1 : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color_2 : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color_3 : source_color = vec3(1.0, 1.0, 1.0);

instance uniform bool viewmodel_enabled = false;
instance uniform float z_clip_scale : hint_range(0.01, 1.0, 0.01) = 0.8;
instance uniform float fov_override : hint_range(1.0, 179.0, 0.1) = 100.0;

uniform float speed = 1.0;
uniform sampler2D noise_texture;

void vertex() {
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

void fragment() {
	vec2 uv = UV;
	uv.y = UV.y + TIME * speed;
	vec4 tex = texture(noise_texture, uv);
	vec3 color = COLOR.rgb;
	float alpha = 1.0;
	if (tex.r > 0.667) {
		color = color_1;
	} else if (tex.r > 0.5) {
		color = color_2;
	} else if (tex.r > 0.333) {
		color = color_3;
	}
	else if (tex.r <= 0.333) {
		alpha = 0.0;
	}
	
	ALBEDO = color;
	ALPHA = alpha;
}
