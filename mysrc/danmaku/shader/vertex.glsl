#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aColor;
layout(location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 TexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float utime;

void main() {
    gl_Position = vec4(projection * view * model * vec4(aPos, 1.0));
    gl_PointSize = 40.0 * (length(gl_Position.xy * 0.5) + 0.1);
    ourColor = abs(vec3(sin(gl_Position.x + utime), sin(gl_Position.y), cos(gl_Position.x - utime)));
    // ourColor = vec3(1.0);
    TexCoord = aTexCoord;
}