#version 330 core

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

out vec4 colour;

mat2 rotate_2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

vec2 isphere( in vec4 sph, in vec3 ro, in vec3 rd ) {
    vec3 oc = ro - sph.xyz;
	float b = dot(oc,rd);
	float c = dot(oc,oc) - sph.w*sph.w;
    float h = b*b - c;
    if( h<0.0 ) return vec2(-1.0);
    h = sqrt( h );
    return -b + vec2(-h,h);
}

float map(vec3 p, vec4 trap) {
    vec3 w = p;
    float m = dot(w,w);

    vec4 trap = vec4(abs(w),m);
	float dz = 1.0;
    
	for(int i=0; i<4; i++) {
        dz = 8.0*pow(m,3.5)*dz + 1.0;
      
        // z = z^8+c
        float r = length(w);
        float b = 8.0*acos( w.y/r);
        float a = 8.0*atan( w.x, w.z );
        w = p + pow(r,8.0) * vec3( sin(b)*sin(a), cos(b), sin(b)*cos(a) );
        trap = min( trap, vec4(abs(w),m) );

        m = dot(w,w);
		if( m > 256.0 )
            break;
    }    
    return 0.25*log(m)*sqrt(m)/dz;
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

    vec2 dis = isphere( vec4(0.0,0.0,0.0,1.25), ro, rd );
    if( dis.y<0.0 ) return -1.0;
    dis.x = max( dis.x, 0.0 );
    dis.y = min( dis.y, 10.0 );

    vec4 trap;

    float t = dis.x; // total distance

    ro.z += time;

    // camera rotation
    ro.yz *= rotate_2d(-m.y);
    rd.yz *= rotate_2d(-m.y);

    ro.xz *= rotate_2d(-m.x);
    rd.xz *= rotate_2d(-m.x);


    // raymarching
    int i;
	for(i=0; i<128; i++) { 
        vec3 pos = ro + rd*t;
        float th = 0.25*px*t;
		float h = map(pos, trap);
		if( t>dis.y || h<th ) break;
        t += h;
    }
    
    if( t<dis.y ) {
        rescol = trap;
        res = t;
    }

    col = palette(t*.04 + float(i)*.008);

    colour = vec4(col, 1);
}
