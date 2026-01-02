shader_type canvas_item;

void fragment() {
    vec2 p = UV * 2.0 - 1.0; // center
    float d = length(p);
    if (d > 1.0) {
        discard;
    }
    COLOR = texture(TEXTURE, UV);
}
