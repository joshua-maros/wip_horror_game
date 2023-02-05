shader_type spatial;
render_mode blend_add, depth_draw_never, specular_disabled, unshaded, cull_front;

float distance_from_line(
	vec3 point, 
	vec3 line_center,  
	float line_width,
) {
	point -= line_center;
	vec3 adjusted_point = point - vec3(0.0, 0.0, clamp(point.z, -line_width, line_width));
	return length(adjusted_point);
}

float saturate(float x) {
	return clamp(x, 0.0, 1.0);
}

float min_component(vec3 vec) {
	return min(vec.x, vec.z);
}

float light_at(vec3 model_pos, vec3 bounds) {
	float height = bounds.y - model_pos.y + 0.1;
	float start = 0.5 * height;
	float end = 2.0 * height;
	float dist_from_center = distance_from_line(vec3(model_pos.x, 0.0, model_pos.z), vec3(0.0), 1.6);
	float dist_from_light = distance_from_line(model_pos, vec3(0.0, bounds.y, 0.0), 1.6) - 0.1;
	float attenuation = 1.0 - saturate((dist_from_center - start) / (end - start));
	// float attenuation = saturate(10.0 * height);
	// attenuation = min(attenuation, saturate(0.5 * min_component(bounds - abs(model_pos))));
	attenuation = min(attenuation, saturate(1.0 - dist_from_light / 3.0));
	
	return attenuation / dist_from_light;
}

float random (vec3 seed) {
    return fract(sin(dot(seed.xyz,
        vec3(12.9898,78.233, 31.4159) + TIME)) * 43758.5453123);
}

void fragment() {
	// Where the pixel we're rendering is located in the world.
	vec4 original_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0));
	// The position the pixel we're rendering is at on the original mesh.
	vec3 model_pos = (inverse(MODEL_MATRIX) * original_pos).xyz;
	// The direction of a ray fired from the camera that hits the point we're
	// currently rendering.
	vec3 ray_direction = normalize(original_pos.xyz - CAMERA_POSITION_WORLD);
	float step_size = 0.4;
	// Go backwards because cull_front only renders the faces behind the object
	// instead of the faces in front of the object.
	vec3 step_ = -step_size * ray_direction;
	vec3 bounds = vec3(2.51, 1.98, 4.01);
	
	float light = 0.0;
	float initial_step = random(model_pos); 
	float z = length(original_pos.xyz - CAMERA_POSITION_WORLD) - initial_step * step_size;
	model_pos += initial_step * step_;
	
	for (int i = 0; i < 16; i++) {
		if (any(greaterThan(abs(model_pos), bounds)) || z < 0.0) {
			break;
		}
		light += light_at(model_pos, bounds) * sqrt(z);
		model_pos += step_;
		z -= step_size;
	}
	
	float exposure = 1.0 / 1000.0;
	
	ALBEDO = vec3(light * exposure) * vec3(0.6, 0.8, 1.0);
	// ALBEDO = ALBEDO.r > 0.0 ? vec3(1.0) : vec3(0.0);
	ALBEDO -= FOG.xyz;
}