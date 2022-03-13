#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aColor;
layout(location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 TexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    gl_Position = vec4(projection * view * model * vec4(aPos, 1.0));
    gl_PointSize = 10.0;
    ourColor = vec3(1.0, 1.0, 1.0);
    TexCoord = aTexCoord;
}