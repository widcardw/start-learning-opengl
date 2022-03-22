#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoord;

// uniform float utime;

vec2 z_square(vec2 v, vec2 c) {
    return vec2(v.x * v.x - v.y * v.y, 2.0 * v.x * v.y) + c;
}

vec3 mandebrot(vec2 z, vec2 c) {
    vec3 color = vec3(0.0);
    vec3 base_color = vec3(1, 0.3, 0.3);
    float rate = 0.02;
    for (int i = 0; i < 4.0 / rate; i++) {
        if (length(z) < 2.0) {
            color += base_color * rate;
        }
        z = z_square(z, c);
    }
    return color;
}

void main() {
    float alpha = 1.0;
    vec2 coord = vec2(TexCoord);
    vec3 color = mandebrot(vec2(0.0), vec2(TexCoord-0.5) * 4);
    // vec3 color = vec3(TexCoord.x, TexCoord.y, 0.0);
    FragColor = vec4(color, alpha);
}