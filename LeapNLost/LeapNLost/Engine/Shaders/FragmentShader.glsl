uniform sampler2D u_Texture;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal; // World normal
varying lowp vec3 frag_Position; // World position

struct DirLight {
    lowp vec3 color;
    lowp vec3 direction;
    lowp float ambientIntensity;
    lowp float diffuseIntensity;
    lowp float specularIntensity;
};
uniform DirLight dirLight;

lowp vec4 calcDirLighting();

void main(void) {
    lowp vec4 dirLighting = calcDirLighting();
    gl_FragColor = texture2D(u_Texture, frag_TexCoord) * dirLighting;
}

lowp vec4 calcDirLighting() {
    // Ambient
    lowp vec3 ambientColor = dirLight.color * dirLight.ambientIntensity;
    
    // Diffuse
    lowp vec3 normal = normalize(frag_Normal);
    lowp float diffuseFactor = max(-dot(normal, dirLight.direction), 0.0);
    lowp vec3 diffuseColor = dirLight.color * dirLight.diffuseIntensity * diffuseFactor;
    
    // Specular
    lowp vec3 eye = normalize(frag_Position);
    lowp vec3 reflection = reflect(dirLight.direction, normal);
    lowp float specularFactor = pow(max(0.0, -dot(reflection, eye)), 1.0); //  Leave shininess at 1.0 for now
    lowp vec3 specularColor = dirLight.color * dirLight.specularIntensity * specularFactor;
    
    // Add all three for phong lighting
    return vec4((ambientColor + diffuseColor + specularColor), 1.0);
}
