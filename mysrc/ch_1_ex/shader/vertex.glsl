#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aColor;
out vec3 vColor;

uniform float xOffset;
void main() {
    gl_Position = vec4(aPos.x + xOffset, aPos.y, aPos.z, 1.0);
    vColor = vec3(aColor.x + sin(xOffset) / 5.0, aColor.y + cos(xOffset) / 5.0, aColor.z + 0.5 / exp(xOffset));
}