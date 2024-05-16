shader_type canvas_item;
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, UV, blur_amount);
}