uniform float wave_length_arr[16] ;
uniform float ap_arr[16] ;
uniform float speed_arr[16];
uniform float Roughness : hint_range(0.0, 1.0) = 0.01;
uniform float Metallicness : hint_range(0.0, 1.0) = 0.0;
uniform samplerCube reflect_cu ;
uniform float Roughness_clercoat: hint_range(0.0, 1.0) = 0.0;
uniform float wave__dir;
uniform vec3 scale_cubemap ;

// the aputad must be lower then the wave length to make it look good



vec3 hash(vec3 p) {
	p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
		dot(p, vec3(269.5, 183.3, 246.1)),
		dot(p, vec3(113.5, 271.9, 124.6)));
		return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	vec3 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(mix(dot(hash(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
 					dot(hash(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
					dot(hash(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
             mix(mix(dot(hash(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                     dot(hash(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                     dot(hash(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z );
}





float wave_ver(float ap, float wave_l , float phase, vec3 var) {
	float wave;
	vec3 w_n ;
	float h_wave = (var.z/75.0);
	w_n = vec3(ap,h_wave,wave_l);
	float wave_dir_ = (var.x + var.z) * noise(w_n);
	wave = sin(((wave_dir_) * wave_l + (TIME * phase/2.0)))+1.0;
	return wave;
}


void vertex() {
	float phase_arr[16];
	float wave_used_arr[16];
	for (int i = 0; i < 16; i++){
		wave_used_arr[i] = 2.0 /wave_length_arr[i];
		phase_arr[i] = speed_arr[i] * wave_used_arr[i];
		VERTEX.y += (2.0*ap_arr[i]) *(wave_ver(ap_arr[i],wave_used_arr[i],phase_arr[i],VERTEX)/2.0);

		}
	}


void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	ALBEDO = vec3(0.1, 0.3, 0.5) + (0.1 * fresnel);
	ROUGHNESS = Roughness * (1.0 - fresnel);
	METALLIC = Metallicness;
}
