shader_type canvas_item;

instance uniform bool is_flash = false;

void fragment() {
	if (COLOR.a > 0.0 && COLOR==vec4(0,1,0,1)) {
		if (is_flash) {
			COLOR = vec4(1,1,1,1);
		} else {
			COLOR = vec4(11.0/255.0,28.0/255.0,46.0/255.0,1);
		}
	}
}
