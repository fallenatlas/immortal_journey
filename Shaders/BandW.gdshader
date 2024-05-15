shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

void fragment(){
	vec4 color = texture(screen_texture, SCREEN_UV);
	color.rgb = vec3(color.r + color.g + color.b) / 3.0;
	COLOR = color;
}
