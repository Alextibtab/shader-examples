#version 330 core

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

out vec4 colour;

float plot(vec2 st, float pct) {
    return smoothstep(pct-0.02, pct, st.y) - smoothstep(pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy / resolution;
    float y = step(0.5,st.x);
    vec3 col = vec3(y);
    float pct = plot(st,y);
    col = (1.0-pct)*col+pct*vec3(0.0,1.0,0.0);

    colour = vec4(col, 1.0);
}
