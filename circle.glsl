
float circle_diff(vec2 point, float r) {
    // Returns the relative distance from the point. difference is as a
    // multiple of r. i.e. 1.0 iff (x,y) is exactly r from point.
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    return distance(st, point) / r;
}

float circle_mask(vec2 point, float r) {
    // 1.0 if (x,y) is within radius r, from postition pos.

    return -1.0 * sign((circle_diff(point, r)) - 1.0);
}

vec3 add_circle(vec3 background, vec3 circle) {
    background += circle; 
    return mix(background, circle, circle);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    // Base colour
    vec3 color = vec3(0.281,0.279,0.675);

    color = add_circle(color, vec3(0.281,0.779,0.675) * circle_mask(vec2(0.5, 0.3), 0.2))
    
    gl_FragColor = vec4(color,0.856);
}