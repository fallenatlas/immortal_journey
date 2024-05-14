shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

uniform float brightness : hint_range(-1, 1) = 0;
uniform float contrast : hint_range(0, 3) = 1.0;
uniform float saturation : hint_range(0, 3) = 1.0;

uniform float redVal : hint_range(0, 1) = 1.0;
uniform float greenVal : hint_range(0, 1) = 1.0;
uniform float blueVal : hint_range(0, 1) = 1.0;

uniform vec4 tint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_effect_factor : hint_range(0, 1) = 0.0;

uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_rgb = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D offset_image;
uniform float strength = 1.0;


//---------------------------------------------
//CONTRAST
//---------------------------------------------
mat4 contrastMatrix( float _contrast ){
	float t = ( 1.0 - _contrast ) / 2.0;
    return mat4( 
		vec4(_contrast, 0, 0, 0),
		vec4(0, _contrast, 0, 0),
		vec4(0, 0, _contrast, 0),
		vec4(t, t, t, 1));
}
//---------------------------------------------
//BRIGHTNESS
//---------------------------------------------
mat4 brightnessMatrix( float _brightness ){
    return mat4( vec4(1, 0, 0, 0),
                 vec4(0, 1, 0, 0),
                 vec4(0, 0, 1, 0),
                 vec4(_brightness, _brightness, _brightness, 1));
}
//---------------------------------------------
//SATURATION
//---------------------------------------------
mat4 saturationMatrix( float _saturation ){
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    float oneMinusSat = 1.0 - _saturation;
	
    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3(_saturation, 0, 0)*redVal;
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0,_saturation, 0 )*greenVal;
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0,_saturation )*blueVal;
	
    return mat4(vec4(red, 0),vec4(green,0),vec4(blue,0),vec4(0, 0, 0, 1));
}

float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 15.0;
	return pow(vignette, vignette_intensity * vignette_opacity);
}


//---------------------------------------------
//fragment
//---------------------------------------------
void fragment() {
	
	vec4 c = texture(screen_texture, UV);
	vec4 c2 = c * tint_color;

	vec4 filterColor = brightnessMatrix( brightness ) * contrastMatrix( contrast ) *saturationMatrix( saturation ) * mix(c, c2, tint_effect_factor);
	
	COLOR = filterColor;
	
}

