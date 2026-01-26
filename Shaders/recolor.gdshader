// NOTE: Shader automatically converted from Godot Engine 4.5.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon, unshaded;

instance uniform vec3 albedo_color : source_color = vec3(0.12, 0.12, 0.13);

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
	vec2 base_uv = UV;
	ALBEDO = albedo_color;
	ALPHA = COLOR.a;
}
