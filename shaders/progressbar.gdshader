shader_type canvas_item;

uniform float percent = 0.;

void fragment() {
	COLOR = COLOR * step(1. - percent, 1. - UV.x);
}
