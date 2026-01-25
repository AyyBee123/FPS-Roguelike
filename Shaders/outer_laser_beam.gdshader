shader_type spatial;
render_mode unshaded, cull_front;

uniform vec3 base_color : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 fresnel_color : source_color = vec3(1.0, 1.0, 1.0);

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	vec3 fresnel = fresnel_glow(4.0, 4.5, fresnel_color, NORMAL, VIEW);
	ALBEDO = base_color + fresnel;
}

