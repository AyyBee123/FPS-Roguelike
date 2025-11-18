shader_type spatial;

render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_disabled, unshaded;

uniform sampler2D material_texture;
uniform sampler2D gradiant;

void vertex() {
    // Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
    // COLOR.r remapped from [0, 1] → [0.0, 0.7]
    float threshold = COLOR.r * 0.7;

    // Flow UV down over time
    vec2 uv = UV + vec2(0.0, -TIME);

    // Sample texture
    float mask = texture(material_texture, uv).r;

    // Smooth threshold cutout
    float alpha_val = smoothstep(threshold, 0.7, mask);

    // Sample gradient using smoothstep result
    vec3 col = texture(gradiant, vec2(alpha_val)).rgb;

    ALBEDO = col;
    ALPHA = alpha_val;
}
