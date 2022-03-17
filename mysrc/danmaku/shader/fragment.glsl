#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoord;

float circleShape(vec2 position, float radius) {
    return 1- step(radius, length(position - 0.5));
}

float lightShape(vec2 position) {
    return 0.1 / length(position - 0.5) - 0.3;
}

void main() {
    float alpha = 0.0;
    alpha += lightShape(gl_PointCoord);
    FragColor = vec4(ourColor, alpha);
}