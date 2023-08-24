shader_type spatial;

void vertex() {
	vec3 fuckIfIKnow = NODE_POSITION_WORLD - CAMERA_POSITION_WORLD;
	VERTEX.y += sin((TIME + VERTEX.x) * 2.0) * 0.1;
}

void fragment() {
	EMISSION = vec3(0.5);
}