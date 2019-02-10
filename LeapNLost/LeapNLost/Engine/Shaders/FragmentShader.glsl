uniform sampler2D u_Texture;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal; // World normal
varying lowp vec3 frag_Position; // World position

struct DirLight {
    lowp vec3 Color;
    lowp vec3 Direction;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp float SpecularIntensity;
};
uniform DirLight dirLight;

lowp vec4 calcDirLighting();

void main(void) {
    lowp vec4 dirLighting = calcDirLighting();
    gl_FragColor = texture2D(u_Texture, frag_TexCoord) * dirLighting;
}

lowp vec4 calcDirLighting() {
    // Ambient
    lowp vec3 AmbientColor = dirLight.Color * dirLight.AmbientIntensity;
    
    // Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp float DiffuseFactor = max(-dot(Normal, dirLight.Direction), 0.0);
    lowp vec3 DiffuseColor = dirLight.Color * dirLight.DiffuseIntensity * DiffuseFactor;
    
    // Specular
    lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 Reflection = reflect(dirLight.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection, Eye)), 1.0); //  Leave shininess at 1.0 for now
    lowp vec3 SpecularColor = dirLight.Color * dirLight.SpecularIntensity * SpecularFactor;
    
    // Add all three for phong lighting
    return vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);
}
