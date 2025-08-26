shader_type spatial;
render_mode diffuse_lambert,specular_schlick_ggx,vertex_lighting ;

uniform float wave_length_arr[8] ;
uniform float ap_arr[8] ;
uniform float speed_arr[8];
uniform vec3 Albedo: source_color = vec3(1, 1, 1);
uniform float Roughness : hint_range(0.0, 1.0) = 1.0;
uniform float Metallicness : hint_range(0.0, 1.0) = 0.0;
uniform float normal_map ;
// the aputad must be lower then the wave length to make it look good

void fragment() {
	ALBEDO = Albedo;
	ROUGHNESS = Roughness;
	METALLIC = Metallicness;
	NORMAL_MAP_DEPTH = normal_map;
}

void vertex() {
	float phase_arr[8];
	float wave_used_arr[8];
	float _dir_ = (VERTEX.z) ;
	float _dir_2 = (VERTEX.z/2.0 +VERTEX.x);
	int arr_legth = wave_length_arr.length();
	for (int i = 0; i < 8; i++){
		wave_used_arr[i] = 2.0 /wave_length_arr[i];
		phase_arr[i] = speed_arr[i] * wave_used_arr[i];
		if (i == 0){
			VERTEX.y += ap_arr[i] * pow(E,sin(VERTEX.x * wave_used_arr[i] + TIME * phase_arr[i]));
		} else {
			VERTEX.y += ap_arr[i] * pow(E,sin(_dir_2 * wave_used_arr[i] + TIME * phase_arr[i]));
		}
	}
}

void light() {
	vec3 half_normal = NORMAL/2.0 ;
	vec3 half_light = LIGHT/2.0;
	DIFFUSE_LIGHT += dot(half_normal, half_light) * ATTENUATION * LIGHT_COLOR / PI;
}

//wave_used_arr[i] = (2.0) /wave_length_arr[i];
		//phase_arr[i] = speed_arr[i] * wave_used_arr[i];
		//DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
		//VERTEX.y += Brown_ab_u[i] * pow(E,sin(_dir_2 * wave_used_arr[i] + TIME * phase_arr[i]));
		//VERTEX.y += ap_arr[i] * pow(E,sin(_dir_2 * wave_used_arr[i] + TIME * phase_arr[i]));