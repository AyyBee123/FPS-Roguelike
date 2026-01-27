shader_type spatial;
render_mode unshaded, cull_front, blend_mix;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 fresnel_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float fresnel_amount = 4.0;
uniform float fresnel_intensity = 4.5;

vec4 fresnel_glow(float amount, float intensity, vec4 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	vec4 fresnel = fresnel_glow(fresnel_amount, fresnel_intensity, fresnel_color, NORMAL, VIEW);
	ALBEDO = base_color.rgb + fresnel.rgb;
	ALPHA = base_color.a + fresnel.a;
}

