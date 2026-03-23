shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

instance uniform bool viewmodel_enabled = false;
instance uniform float z_clip_scale : hint_range(0.01, 1.0, 0.01) = 0.8;
instance uniform float fov_override : hint_range(1.0, 179.0, 0.1) = 100.0;

instance uniform vec3 zippy_albedo : source_color = vec3(0.86, 0.44, 0.2);
uniform float roughness : hint_range(0.0, 1.0);

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
	ALBEDO = zippy_albedo;
	ROUGHNESS = roughness;
}
