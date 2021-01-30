// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float rect_mask( vec2 p1, vec2 p2) {
    //
    
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    // Box around coordinates (a,b), (c,d)
    float x_bound = step(p1[0], st.x) *  (1.0-step(p2[0], st.x));
    float y_bound = step(p1[1], st.y) *  (1.0-step(p2[1], st.y));
    return x_bound * y_bound;
}

float rect_mask(vec2 p, float l, float w) {
    return rect_mask(p, vec2(p[0] + l, vec2(p[1]+w)));
}

float smooth_rect_mask( vec2 p1, vec2 p2) {
    // Creates a smoothened rectangular binary mask given two points.
    //
    // Args:
    //  p1: bottom, left coordinate of rectangle
    //  p2: top, right coordinate of rectangle
    //
    // Returns:
    //  1 if the point is within the rectangle defined by p1, p2, whilst points 
    //  close to the rectangle exponentially decreasing from 1.0 to 0.0.    
    // 
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    float diff = 0.05;
    // Box around coordinates (a,b), (c,d)
    float x_bound = smoothstep(p1[0]-diff, p1[0], st.x) *  (1.0-smoothstep(p2[0], p2[0] +  diff, st.x));
    float y_bound = smoothstep(p1[1] - diff, p1[1], st.y) *  (1.0-smoothstep(p2[1], p2[1] + diff, st.y));
    
    return x_bound * y_bound;
}

float smooth_rect_mask(vec2 p, float w, float l) {
    // Creates a smoothened rectangular binary mask given one point and the dimensions of the rectangle. 
    //
    // Args:
    //  p1: bottom, left coordinate of rectangle
    //  w: The horizontal width of the rectangle mask.
    //  l: The vertical height of the rectangle mask.
    // 
    // Returns:
    //  1 if the point is within the rectangle defined by p1, p2.    
    // 
    return smooth_rect_mask(p, vec2(p[0] + w, vec2(p[1]+l)));
}

vec3 add_rect(vec3 background, vec3 rectangle) {
    background += rectangle;
    return mix(background, rectangle, rectangle);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    // Base colour
    vec3 color = vec3(0.281,0.279,0.675);

    // Add two rectangles.
    color = add_rect(color, vec3(0.357,0.355,0.815) * rect_mask(vec2(0.20,0.120), 0.2, 0.75));
    color = add_rect(color, vec3(0.357,0.355,0.815) * smooth_rect_mask(vec2(0.60,0.120), 0.2, 0.75));
    
    gl_FragColor = vec4(color,0.856);
}