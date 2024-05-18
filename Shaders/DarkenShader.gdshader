shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,repeat_disable,filter_nearest;

uniform vec4 other_color: source_color = vec4(1.0);
uniform float isOtherWorld;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if(isOtherWorld == 1.0){
		color.rbga = other_color;
	}
	COLOR = color;
}

