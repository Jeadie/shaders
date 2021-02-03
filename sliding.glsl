#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 brickTile(vec2 _st, float _zoom){
    _st *= _zoom;

    // Slide x and y, with offset: step(fract(u_time/5.0 + 2.5), 0.5) *
    _st.x +=  step(fract(u_time/5.0 + 2.5), 0.5) *step(1.00, mod(_st.y,2.)) * 2.*fract(0.2* u_time);
    _st.y += step(fract(u_time/5.0), 0.5) * step(1.00, mod(_st.x,2.)) * 2.*fract(0.2* u_time);
	// return _st;
    return fract(_st);
}

float box(vec2 _st, vec2 _size){
    _size = vec2(0.5)-_size*0.5;
    vec2 uv = smoothstep(_size,_size+vec2(1e-4),_st);
    uv *= smoothstep(_size,_size+vec2(1e-4),vec2(1.0)-_st);
    return uv.x*uv.y;
}

float circle(vec2 _st, float radius) {    
 	float c = length(_st - vec2(0.5))*2.0;
    return step(c,radius);
}

float parabola( float x, float k ){
    return pow( 4.0* x*(1.0-x), k );
}


void main(void){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);

    // Modern metric brick of 215mm x 102.5mm x 65mm
    // http://www.jaharrison.me.uk/Brickwork/Sizes.html
    // st /= vec2(2.15,0.65)/1.5;

    // Apply the brick tiling
    st = brickTile(st, 5.0);

	// color = vec3(box(st,vec2(0.9)));
	float radius = length(st - vec2(0.5))*2.0;
    color = vec3(circle(st, 0.3));
    gl_FragColor = vec4(color,1.0);
}

