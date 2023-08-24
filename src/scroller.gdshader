shader_type spatial;
render_mode world_vertex_coords;

void vertex() {
	float angle = atan(VERTEX.z, VERTEX.x);
	VERTEX.x += cos(angle);
	VERTEX.z += sin(angle);
}

void fragment() {
	EMISSION = vec3(0.5);
}
