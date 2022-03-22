#ifndef TGPLANE_GEOMETRY
#define TGPLANE_GEOMETRY

#include <geometry/BufferGeometry.h>
#include <glad/glad.h>

using namespace std;

class TgPlaneGeometry : public BufferGeometry
{
public:
    TgPlaneGeometry(float width = 1.0, float height = 1.0, float wSegment = 1.0, float hSegment = 1.0, bool enableTangent = true)
    {

        float width_half = width / 2.0f;
        float height_half = height / 2.0f;

        float gridX1 = wSegment + 1.0f;
        float gridY1 = hSegment + 1.0f;

        float segment_width = width / wSegment;
        float segment_height = height / hSegment;

        Vertex vertex;

        // generate Position Normal TexCoords
        for (int iy = 0; iy < gridY1; iy++)
        {

            float y = iy * segment_height - height_half;

            for (int ix = 0; ix < gridX1; ix++)
            {
                float x = ix * segment_width - height_half;
                vertex.Position = glm::vec3(x, -y, 0.0f);
                vertex.Normal = glm::vec3(0.0f, 0.0f, 1.0f);
                vertex.TexCoords = glm::vec2(ix / wSegment, 1.0f - (iy / hSegment));

                this->vertices.push_back(vertex);
            }
        }
        // generate indices
        for (int iy = 0; iy < hSegment; iy++)
        {
            for (int ix = 0; ix < wSegment; ix++)
            {
                float a = ix + gridX1 * iy;
                float b = ix + gridX1 * (iy + 1);
                float c = (ix + 1) + gridX1 * (iy + 1);
                float d = (ix + 1) + gridX1 * iy;
                this->calcTg(vertices, a - 1, b - 1, c - 1, d - 1);
                this->indices.push_back(a);
                this->indices.push_back(b);
                this->indices.push_back(d);
                this->indices.push_back(b);
                this->indices.push_back(c);
                this->indices.push_back(d);
            }
        }

        this->setupBuffers();
    }

private:
    void calcTg(vector<Vertex> &vertices,
                unsigned int a, unsigned int b, unsigned int c, unsigned int d)
    {
        glm::vec3 pos1 = vertices[a].Position;
        glm::vec3 pos2 = vertices[b].Position;
        glm::vec3 pos3 = vertices[c].Position;
        glm::vec3 pos4 = vertices[d].Position;
        glm::vec2 uv1 = vertices[a].TexCoords;
        glm::vec2 uv2 = vertices[b].TexCoords;
        glm::vec2 uv3 = vertices[c].TexCoords;
        glm::vec2 uv4 = vertices[d].TexCoords;

        glm::vec3 nm = glm::vec3(0.0, 0.0, 1.0);
        // calculate tangent/bitangent vectors of both triangles
        glm::vec3 tangent1, bitangent1;
        glm::vec3 tangent2, bitangent2;
        // - triangle 1
        glm::vec3 edge1 = pos2 - pos1;
        glm::vec3 edge2 = pos3 - pos1;
        glm::vec2 deltaUV1 = uv2 - uv1;
        glm::vec2 deltaUV2 = uv3 - uv1;

        GLfloat f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

        tangent1.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
        tangent1.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
        tangent1.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
        tangent1 = glm::normalize(tangent1);

        bitangent1.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
        bitangent1.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
        bitangent1.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
        bitangent1 = glm::normalize(bitangent1);

        // - triangle 2
        edge1 = pos3 - pos1;
        edge2 = pos4 - pos1;
        deltaUV1 = uv3 - uv1;
        deltaUV2 = uv4 - uv1;

        f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

        tangent2.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
        tangent2.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
        tangent2.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
        tangent2 = glm::normalize(tangent2);

        bitangent2.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
        bitangent2.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
        bitangent2.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
        bitangent2 = glm::normalize(bitangent2);

        vertices[a].Tangent = glm::vec3(tangent1);
        vertices[b].Tangent = glm::vec3(tangent1);
        vertices[c].Tangent = glm::vec3(tangent2);
        vertices[d].Tangent = glm::vec3(tangent2);
        vertices[a].Bitangent = glm::vec3(bitangent1);
        vertices[b].Bitangent = glm::vec3(bitangent1);
        vertices[c].Bitangent = glm::vec3(bitangent2);
        vertices[d].Bitangent = glm::vec3(bitangent2);
    }
    void setupBuffers()
    {
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
        glGenBuffers(1, &EBO);

        glBindVertexArray(VAO);

        // vertex attribute
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(Vertex), &vertices[0], GL_DYNAMIC_DRAW);

        // indixes
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(unsigned int), &indices[0], GL_STATIC_DRAW);

        // 设置顶点属性指针
        // Position
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)0);

        // Normal
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)offsetof(Vertex, Normal));

        // TexCoords
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)offsetof(Vertex, TexCoords));

        // vertex tangent
        glEnableVertexAttribArray(3);
        glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)offsetof(Vertex, Tangent));

        // vertex bitangent
        glEnableVertexAttribArray(4);
        glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)offsetof(Vertex, Bitangent));

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
    }
};

#endif
