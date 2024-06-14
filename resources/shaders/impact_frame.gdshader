shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D alpha_texture;
uniform float step_value: hint_range(0.0, 1.0, 0.01);


void fragment() {
	vec2 screen_uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;

	float texture_alpha = texture(alpha_texture, UV).a;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, screen_uv).rbg;
	
	float grayscale = clamp((screen_color.r + screen_color.g + screen_color.b) * 0.3333, 0.0, 1.0);
	
	float final_value = step(step_value, 1.0 - grayscale);
	
	COLOR = vec4(vec3(final_value), texture_alpha);
}