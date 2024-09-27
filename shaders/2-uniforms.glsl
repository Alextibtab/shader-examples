#version 330 core

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

out vec4 colour;

void main() {
    colour = vec4(abs(sin(time)), 0.0, 0.0, 1.0);
}
