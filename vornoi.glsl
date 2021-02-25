// Author: @patriciogv
// Title: 4 cells voronoi

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main() {
    
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    // pos -= vec2(0.5);
    // pos *= rotate2d(.5);
    // float scale_factor = 4.0;
    float scale_factor = 2.413 * (sin(u_time) + 2.);
    vec2 st = scale_factor  * pos; 
    st.x *= u_resolution.x/u_resolution.y;
    
    vec2 random_theta = random2(st);
    vec3 color = vec3(0.0);
    
    // Tile the space
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
    
    vec2 mouse =  (u_mouse + vec2(0.5)) /(u_resolution)/ (scale_factor/2.);
    
    float m_dist = distance(pos, mouse) * scale_factor;
    vec2 m_point =  mouse; 
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
            if (dist < m_dist) {
            	m_dist = dist;    
                m_point = (i_st + neighbour +  point)/scale_factor;
            }
        }
    }
    

    // Add distance field to closest point center
    color += m_dist*2.;
	color.r += step(.98, f_st.x) + step(.98, f_st.y);
    // tint acording the closest point position
    color.rg = m_point;

    // Show isolines
    // color -= abs(sin(80.0*m_dist))*0.07;
	// color.r += step(.98, f_st.x) + step(.98, f_st.y);
    // Draw point center
    color += 1.-step(.02, m_dist);

    gl_FragColor = vec4(color,1.0);
}
