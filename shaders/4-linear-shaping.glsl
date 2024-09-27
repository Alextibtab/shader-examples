#version 330 core

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

out vec4 colour;

float plot(vec2 st) {
    return smoothstep(0.02, 0.0, abs(st.y - st.x));
}

void main() {
    vec2 st = gl_FragCoord.xy / resolution;
    float y = st.x;
    vec3 col = vec3(y);
    float pct = plot(st);
    col = (1.0-pct)*col+pct*vec3(0.0,1.0,0.0);

    colour = vec4(col, 1.0);
}
