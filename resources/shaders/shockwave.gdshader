shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


void fragment(){
	vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	vec4 screenColor = textureLod(SCREEN_TEXTURE, distortedUV, 0.0);
	COLOR = screenColor;
}


