#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(float x) {
    return fract(sin(x)*5300.0);
}

float noise(float x) {
  float f = fract(x);
  float curve = f * f * (3.0 - 2.0 * f) ;
  return mix(random(floor(x)), random(floor(x + 1.0)), curve);   
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    st = 5.0*st;
    vec3 color = vec3(0.0);

    vec2 pos = vec2(st*10.0);
    
	color = vec3(noise(st.x), st.x, 1);
	color += vec3(1.,1.,1.) * step(st.y, pow(noise(st.x), 2.));
    gl_FragColor = vec4(color,1.0);
}
