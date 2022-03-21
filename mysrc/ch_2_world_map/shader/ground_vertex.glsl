#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aNormal;
layout(location = 2) in vec2 aTexCoord;

out vec2 TexCoord;
out vec3 Normal;
out vec3 FragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    gl_Position = vec4(projection * view * model * vec4(aPos, 1.0f));
    FragPos = vec3(model * vec4(aPos, 1.0f));
    TexCoord = aTexCoord;
    // 解决不等比缩放对法向量产生的影响
    Normal = mat3(transpose(inverse(model))) * aNormal;
}