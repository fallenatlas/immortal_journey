shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float time;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, time);
	COLOR = color;
}