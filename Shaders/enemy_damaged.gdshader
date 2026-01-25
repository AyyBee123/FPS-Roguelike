shader_type spatial;
render_mode unshaded;
uniform sampler2D base_texture: source_color;
instance uniform float fade: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 final_output = texture(base_texture, UV);
	final_output.a *= fade;

	ALPHA *= final_output.a;
}
