shader_type canvas_item;

#define S smoothstep
#define IS(x,y,z) (1.0 - smoothstep(x,y,z))

uniform vec2 resolution = vec2(600.0, 400.0);
uniform vec3 line_color: source_color = vec3(0.58, 0.12, 0.78);
uniform float line_thickness: hint_range(0.01, 1.0, 0.01) = 0.14;
uniform float color_change_speed: hint_range(0.1, 2.5, 0.1) = 0.5;
uniform float color_change_amplitude: hint_range(0.1, 3.0, 0.01) = 0.5;
uniform float speed: hint_range(1.0, 3.0, 0.1) = 1.5;
uniform float wave_amplitude: hint_range(0.01, 0.3, 0.01) = 0.2;
uniform float wave_frequency: hint_range(0.1, 10.0, 0.1) = 1.0;
uniform int iterations: hint_range(1, 20, 1) = 5;

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

float visibility_of_point(vec2 uv, float frequency, float shift, float amplification) {
	uv.y += IS(0.0, 1.0, abs(uv.x)) * sin(uv.x * frequency + shift + (TIME*speed)) * amplification;
	return IS(0.0, line_thickness, abs(uv.y));
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - 0.5;
	float color_offset = mod(TIME*color_change_speed, 100.);
	vec3 color = line_color +
			vec3(noise(uv+color_offset), noise(uv+color_offset+1.), noise(uv+color_offset+2.))*color_change_amplitude;
	float visibility = 0.0;
	for (int i = 0; i < iterations; i += 1) {
		visibility += visibility_of_point(uv, wave_frequency, float(i) * 3.0 / float(iterations), wave_amplitude);
	}
	COLOR = vec4(color, visibility);
}
