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
    sampler2D diffuse;
    sampler2D specular;
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

struct FocusLight {
    vec3 position;
    vec3 direction;
    float cutOff;
    float outCutOff;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform FocusLight focusLight;

// 采样
// uniform sampler2D texture1;

vec3 calcFocusLight(FocusLight light, vec3 fragPos, vec3 norm) {

    vec3 ambient = light.ambient * vec3(texture(material.diffuse, TexCoord));

    vec3 lightDir = normalize(light.position - fragPos); // 光线方向
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));

    vec3 viewDir = normalize(viewPos - fragPos);  // 视线方向
    vec3 reflectDir = reflect(-lightDir, norm);  // 反射光方向
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);  // 反射光强度
    vec3 specular = light.specular * spec * vec3(texture(material.specular, TexCoord));

    float theta = dot(lightDir, normalize(-light.direction));
    float epsilon = light.cutOff - light.outCutOff;
    float intensity = clamp((theta - light.outCutOff) / epsilon, 0.0, 1.0); 
    diffuse *= intensity;
    specular *= intensity;

    return vec3(ambient + diffuse + specular);
}

void main() {

    // vec4 objectColor = texture(texture1, TexCoord);
    vec4 objectColor = vec4(1.0, 1.0, 1.0, 1.0);

    vec3 ambient = light.ambient * vec3(texture(material.diffuse, TexCoord));

    vec3 norm = normalize(Normal); // 法线
    vec3 lightDir = normalize(light.position - FragPos); // 光线方向

    // 计算漫反射影响
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));  // 漫反射

    // 镜面光强度
    // float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);  // 视线方向
    vec3 reflectDir = reflect(-lightDir, norm);  // 反射光方向

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);  // 反射光强度
    vec3 specular = vec3(texture(material.specular, TexCoord)) * (spec * light.specular);  // 反射光

    vec3 result = (ambient + diffuse + specular);
    result += calcFocusLight(focusLight, FragPos, norm);
    // FragColor = texture(texture1, TexCoord);
    FragColor = vec4(result * vec3(objectColor), 1.0);
}