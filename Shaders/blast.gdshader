shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

uniform sampler2D erosion;
uniform float erosion_max_offset = 0.1;

void fragment() {
	vec2 base_uv = UV;
	
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
	
	vec4 erosion_tex = texture(erosion, base_uv);
	float erosion_val = smoothstep(COLOR.r, COLOR.r, erosion_tex.r);
	
	ALPHA *= erosion_val;
}
