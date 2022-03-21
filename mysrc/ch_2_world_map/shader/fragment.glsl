#version 330 core
out vec4 FragColor;
in vec2 TexCoord;
in vec3 Normal;
in vec3 FragPos;

// uniform vec3 lightColor;
// uniform vec3 lightPos;
// uniform float ambientStrength;

uniform vec3 viewPos;  // 相机位置

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

uniform Material material;

struct Light {
    vec3 position;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Light light;

// 采样
uniform sampler2D texture1;

void main() {

    vec4 objectColor = texture(texture1, TexCoord);

    vec3 ambient = material.ambient * light.ambient;

    vec3 norm = normalize(Normal); // 法线
    vec3 lightDir = normalize(light.position - FragPos); // 光线方向

    // 计算漫反射影响
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * material.diffuse);  // 漫反射

    // 镜面光强度
    // float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);  // 视线方向
    vec3 reflectDir = reflect(-lightDir, norm);  // 反射光方向

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);  // 反射光强度
    vec3 specular = material.specular * (spec * light.specular);  // 反射光

    vec3 result = (ambient + diffuse + specular) * vec3(objectColor);
    // FragColor = texture(texture1, TexCoord);
    FragColor = vec4(result, 1.0);
}