shader_type canvas_item;

uniform float white_amount: hint_range(0.0, 1.0, 0.05) = 1.0;
uniform bool enabled = false;

void fragment(){
    if (enabled) {
   	    COLOR.rgb = (COLOR.r + COLOR.g + COLOR.b) / vec3(3.0);
        COLOR.rgb *= white_amount;
    }
}