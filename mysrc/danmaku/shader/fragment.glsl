#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoord;

// 采样
uniform sampler2D texture1;

void main() {
    // FragColor = texture(texture1, TexCoord);
    FragColor = vec4(ourColor, 1.0f);
}