#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float grid_factor = 2.0;

// vec2 random2(vec2 st){
//     st = vec2( dot(st,vec2(127.1,311.7)),
//               dot(st,vec2(269.5,143.3 + 140.*sin(u_time))) );
//     return -1.0 + 2.0*fract(sin(st)*43758.5453123);
// }

// float random2d(vec2 pos) {
//     return fract(sin(dot( pos, vec2(0.710 + 0.2*sin(u_time),0.740 + 0.2 *cos(2.* u_time-1.)))));
// }



float random(float x) {
    return fract(sin(x)*5300.0);
}

float noise(float x) {
  float f = fract(x);
  float curve = f * f * (3.0 - 2.0 * f) ;
  return mix(random(floor(x)), random(floor(x + 1.0)), curve);   
}

float random2d(vec2 pos) {
    return fract(sin(dot( pos, vec2(1., 2.))));
}

float value_noise2d(vec2 pos) {
    vec2 i = floor(pos);
    i -= grid_factor * u_mouse/u_resolution.xy;
    // i -= 2. *  sin(2.*3.14*fract(u_time/100.));
    vec2 f = fract(pos);
    
    float a = random2d(i);
    float b = random2d(i + vec2(1.,0.));
    float c = random2d(i + vec2(0., 1.));
    float d = random2d(i + vec2(1.,1.));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float gradient_noise2d(vec2 pos) {
    vec2 i = floor(pos);
    // i -= grid_factor * u_mouse/u_resolution.xy;
    // i -= 2. *  sin(2.*3.14*fract(u_time/100.));
    vec2 f = fract(pos);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}


mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec3 color = vec3(0.0);

    vec2 pos = vec2(st*10.0);
    pos = rotate2d( noise(pos) ) * pos; // rotate the space
	
    color = vec3( noise(pos)*.5+.5 );
    color = sign(color-0.5);
    
    gl_FragColor = vec4(color,1.0);
}