#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoord;

// 采样
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float utime;

void main() {
    FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), abs(sin(utime)));
    // FragColor = vec4(ourColor, 1.0f);
}