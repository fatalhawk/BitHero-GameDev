shader_type canvas_item;

uniform bool active = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 original_color = texture(TEXTURE, UV);
	vec4 new_color = original_color;

	if (active) {
		vec4 damage = vec4(1.0, original_color.g, original_color.b, original_color.a);
		new_color = damage;
	}
	COLOR = new_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
