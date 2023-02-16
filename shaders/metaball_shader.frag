/// ref: https://github.com/T99Rots/flutter_metaballs/blob/main/lib/metaballs_shader.glsl

#version 320 es

precision highp float;

out vec4 fragColor;

uniform vec3 metaball1;
uniform vec3 metaball2;
uniform float metaballs;
uniform float minimumGlowSum;
uniform float glowIntensity;
uniform vec3 metaball3;

float addSum(vec3 metaball, vec2 coords) {
    float dx = metaball.x - coords.x;
    float dy = metaball.y - coords.y;
    float radius = metaball.z;
    return ((radius * radius) / (dx * dx + dy * dy));
}

vec4 noise(vec4 v){
    // ensure reasonable range
    v = fract(v) + fract(v*1e4) + fract(v*1e-4);
    // seed
    v += vec4(0.12345, 0.6789, 0.314159, 0.271828);
    // more iterations => more random
    v = fract(v*dot(v, v)*123.456);
    v = fract(v*dot(v, v)*123.456);
    return v;
}

float getSum(vec2 coords) {
    float sum = 0.0;
    if (metaballs < 1.0) return sum;
    sum += addSum(metaball1, coords);
    if (metaballs < 2.0) return sum;
    sum += addSum(metaball2, coords);
    if (metaballs < 3.0) return sum;
    sum += addSum(metaball3, coords);
    return sum;
}

void main() {
    vec2 coords = gl_FragCoord.xy;
    float time = 0.5;
//    float minimumGlowSum = 1.5;
//    float glowIntensity = 5.0;
    float sum = getSum(coords);

//    if (sum >= 1.0) {
//         fragColor = vec4(1,1,1,1);
//    } else if (sum > minimumGlowSum) {
    float n = ((sum - minimumGlowSum) / (1.0 - minimumGlowSum)) * glowIntensity;

    fragColor = vec4(n) + ((noise(vec4(coords, time, 0.0)) - 0.5) / 255.0);
//    } else {
//         fragColor = vec4(0, 0, 0, 0);
//    }
}