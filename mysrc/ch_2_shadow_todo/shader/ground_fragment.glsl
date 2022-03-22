#version 330 core
out vec4 FragColor;
in vec2 TexCoord;
in vec3 Normal;
in vec3 FragPos;

uniform float ambientStrength;

uniform vec3 viewPos;  // 相机位置

struct Light {
    vec3 position;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float constant;
    float linear;
    float quadratic;
};

uniform Light light;

// 采样
uniform sampler2D texture2;

void main() {

    float distance = length(light.position - FragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance +
        light.quadratic * (distance * distance));

    vec4 objectColor = texture(texture2, TexCoord);
    // vec4 objectColor = vec4(1.0, 1.0, 1.0, 1.0);

    vec3 ambient = ambientStrength * light.ambient;

    vec3 norm = normalize(Normal); // 法线
    vec3 lightDir = normalize(light.position - FragPos); // 光线方向

    // 计算漫反射影响
    float diff = max(dot(norm, light.position), 0.0);
    vec3 diffuse = diff * light.diffuse;  // 漫反射

    // 镜面光强度
    // float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);  // 视线方向
    vec3 reflectDir = reflect(-lightDir, norm);  // 反射光方向

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 1);  // 反射光强度
    vec3 specular = spec * light.specular;  // 反射光

    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;

    vec3 result = (ambient + diffuse + specular) * vec3(objectColor);
    // vec3 result = vec3(objectColor);
    // FragColor = texture(texture2, TexCoord);
    FragColor = vec4(result, 1.0);
}