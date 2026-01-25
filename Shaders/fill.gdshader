shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 empty_albedo : source_color;
uniform vec3 fill_albedo : source_color;

instance uniform float fill_amount : hint_range(0.0, 1.0);
uniform float fill_multiplier : hint_range(0.0, 1.0) = 1.0;
uniform float fill_offset : hint_range(0.0, 1.0) = 0.8;

uniform bool viewmodel_enabled = false;
uniform float z_clip_scale : hint_range(0.01, 1.0, 0.01) = 0.8;
uniform float fov_override : hint_range(1.0, 179.0, 0.1) = 100.0;

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
	float fill;
	if (1.0 - UV.y < fill_amount * fill_multiplier + fill_offset) {
		fill = 0.0;
	} else {
		fill = 1.0;
	}
	ALBEDO = mix(fill_albedo, empty_albedo, fill);
}
