// NOTE: Shader automatically converted from Godot Engine 4.5.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon, unshaded;

instance uniform vec3 albedo_color : source_color = vec3(1.0);
uniform sampler2D albedo_texture : filter_nearest_mipmap;
uniform bool enable_billboard = false;

void vertex() {
	if (enable_billboard) {
		// Billboard Mode: Enabled
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
				MAIN_CAM_INV_VIEW_MATRIX[0],
				MAIN_CAM_INV_VIEW_MATRIX[1],
				MAIN_CAM_INV_VIEW_MATRIX[2],
				MODEL_MATRIX[3]);

		// Billboard Keep Scale: Enabled
		MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
				vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
				vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
				vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
				vec4(0.0, 0.0, 0.0, 1.0));
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = albedo_color;
	ALPHA = tex.a * COLOR.a;
}
