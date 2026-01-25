shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 color_1 : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color_2 : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color_3 : source_color = vec3(1.0, 1.0, 1.0);

uniform float speed = 1.0;
uniform sampler2D noise_texture;

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

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
