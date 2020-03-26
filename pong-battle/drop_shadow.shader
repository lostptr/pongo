shader_type canvas_item;

uniform float texture_width;
uniform float size : hint_range(0.0, 30.0);
uniform vec4 shadow_color : hint_color;


void fragment() 
{
	float s = size * 1.0 / texture_width;
	
	float alpha = (texture(TEXTURE, UV).a) * shadow_color.a;
	
	vec4 final_color = vec4(shadow_color.rgb, alpha);
	COLOR = vec4(final_color.rgb, clamp(abs(alpha), 0.0, 1.0));
}