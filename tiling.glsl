#ifdef GL_ES
precision mediump float;
#endif

// Using tilling to allow for better edge cases between the grid. 

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


vec2 random2( vec2 p ) {
    vec2 random_point = fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
    return random_point;
}

void main() {
	vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    
    float scale_factor = 3.0;
    
    // Scale
    vec2 st = scale_factor * pos;

    vec3 color = vec3(0.0);
    
    // Tile the space
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
    
    float m_dist = distance(pos, u_mouse/(u_resolution)) * scale_factor;
    
    // For all neighbouring cells, check if distance to
    // random point in cell adjacent is closer that random
    // point in its own cell. Use closest of all possible options
    for (int y= -1; y <= 1; y++) {
    for (int x= -1; x <= 1; x++) {
        
        // Get random point in neighbouring place in the grid
        vec2 neighbour = vec2(float(x),float(y));
     	vec2 point = random2(i_st + neighbour);
		
        // Check if distance to random point in cell adjacent is closer
        float dist = distance(neighbour +  point, f_st); 
		
        // Keep the closer distance
        m_dist = min(m_dist, dist);
        
    }
}
    // Add distance value
	color += m_dist;
    
    // Add dots at points that are close to 0.0. Interestingly random function acts as stabiliser at this point (analogous to Group stabilisers). 
    color += 1.-step(.02, m_dist);
    
    // Add red outline to individual cells
    // color.r += step(.98, f_st.x) + step(.98, f_st.y);
    
    // add concentric cirles around points
    // color -= step(.7,abs(sin(27.0*m_dist)))*.5;


	gl_FragColor = vec4( color, 1.0 );
}
