#version 330 core
layout(location = 0) in vec3 aPos;
layout(location = 1) in vec3 aColor;
out vec3 vColor;

uniform float utime;

mat4 rotateZ(float _angle) {
    return mat4(cos(_angle), -sin(_angle), 0.0, 0.0, sin(_angle), cos(_angle), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
}

mat4 rotateY(float _angle) {
    return mat4(cos(_angle), 0.0, sin(_angle), 0.0, 0.0, 1.0, 0.0, 0.0, -sin(_angle), 0.0, cos(_angle), 0.0, 0.0, 0.0, 0.0, 1.0);
}

mat4 rotateX(float _angle) {
    return mat4(1.0, 0.0, 0.0, 0.0, 0.0, cos(_angle), -sin(_angle), 0.0, 0.0, sin(_angle), cos(_angle), 0.0, 0.0, 0.0, 0.0, 1.0);
}

mat4 rotateXYZ(vec3 _angles) {
    return rotateX(_angles.x) * rotateY(_angles.y) * rotateZ(_angles.z);
}

void main() {
    gl_Position = vec4(rotateXYZ(vec3(utime)) * vec4(aPos, 1.0));
    vColor = aColor;
}