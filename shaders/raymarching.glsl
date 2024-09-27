#version 330 core

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

out vec4 colour;

float sdf_sphere(vec3 p, float s) {
    return length(p) - s;
}

float sdf_box(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)), 0.0);
}

float smooth_min(float a, float b, float k) {
    float h = max(k-abs(a-b), 0.0)/k;
    return min(a,b) - h*h*h*k*(1.0/6.0);
}

mat2 rotate_2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float map(vec3 p) {
    vec3 sphere_position = vec3(sin(time)*3, 0, cos(time)*3);
    float sphere = sdf_sphere(p - sphere_position, .5);

    vec3 q = p;
    q.z -= time * .2;
    q = fract(q) - .5;

    float box = sdf_box(q, vec3(.25));

    return smooth_min(sphere, box, 1.5);
}

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b * cos(6.28318*(c*t+d));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2. - resolution.xy) / resolution.y;
    vec2 m = (mouse.xy * 2. - resolution.xy) / resolution.y;

    // init
    vec3 ro = vec3(0, 0, 0); // ray origin
    vec3 rd = normalize(vec3(uv, 1)); //ray direction
    vec3 col = vec3(0); // final pixel colour

    float t = 0.; // total distance

    ro.z += time;

    // camera rotation
    // ro.yz *= rotate_2d(-m.y);
    // rd.yz *= rotate_2d(-m.y);

    // ro.xz *= rotate_2d(-m.x);
    // rd.xz *= rotate_2d(-m.x);


    // raymarching
    int i;
    for (i = 0; i < 100; i++) {
        vec3 p = ro + rd * t; // position along the ray

        p.xy *= rotate_2d(t*sin(time)*.4);
        p.y += sin(t)*.4;

        float d = map(p); // current distance to the scene

        t += d; // march the ray

        if (d < .0001 || t > 100.) break; // exit if ray hits object or leaves scene
    }

    col = palette(t*.2 + time*.5 + float(i)*.008);

    colour = vec4(col, 1);
}
