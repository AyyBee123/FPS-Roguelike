shader_type spatial;
render_mode unshaded;
uniform sampler2D base_texture: source_color;
instance uniform float fade: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	ALPHA *= fade;
}
