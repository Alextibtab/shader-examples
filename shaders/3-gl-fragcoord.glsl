#version 330 core

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

out vec4 colour;

void main() {
    vec2 st = gl_FragCoord.xy / resolution;
    colour = vec4(st.x, st.y, 0.0, 1.0);
}
