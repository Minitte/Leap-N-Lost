/**
 * Structure that holds directional light variables.
 * See DirectionalLight.swift
 */
struct DirLight {
    lowp vec3 color;
    lowp vec3 direction;
    lowp float ambientIntensity;
    lowp float diffuseIntensity;
    lowp float specularIntensity;
};

/**
 * Structure that holds point light variables.
 * See PointLight.swift
 */
struct PointLight {
    lowp vec3 color;
    lowp vec3 position;
    
    lowp float constant;
    lowp float linear;
    lowp float quadratic;
    
    lowp float ambientIntensity;
    lowp float diffuseIntensity;
    lowp float specularIntensity;
};

/**
 * Maximum number of point lights that can affect
 * a fragment is defined here.
 */
#define NR_POINT_LIGHTS 4

// Lighting variables
uniform PointLight pointLights[NR_POINT_LIGHTS];
uniform DirLight dirLight;

// The texture map
uniform sampler2D u_Texture;

uniform lowp vec3 view_Position; // Position of the camera

// Variables that are passed in from the vertex shader
varying lowp vec4 frag_Color; // Fragment color
varying lowp vec2 frag_TexCoord; // Texture coordinate
varying lowp vec3 frag_Normal; // World normal
varying lowp vec3 frag_Position; // World position

// Function declarations
lowp vec4 calcDirLighting(lowp vec3 normal);
lowp vec4 calcPointLighting(PointLight pointLight, lowp vec3 normal, lowp vec3 viewDir);


void main(void) {
    // Properties
    lowp vec3 normal = normalize(frag_Normal);
    lowp vec3 viewDir = normalize(view_Position - frag_Position);
    
    // Calculate total lighting
    lowp vec4 lighting = calcDirLighting(normal);
    for (int i = 0; i < NR_POINT_LIGHTS; i++) {
        lighting +=calcPointLighting(pointLights[i], normal, viewDir);
    }

    // Set fragment colour
    gl_FragColor = texture2D(u_Texture, frag_TexCoord) * lighting;
}

/**
 * Calculates and returns the effect that directional lighting will have on this fragment.
 * normal - the normal vector of this fragment
 */
lowp vec4 calcDirLighting(lowp vec3 normal) {
    // Ambient
    lowp vec3 ambientColor = dirLight.color * dirLight.ambientIntensity;
    
    // Diffuse
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

/**
 * Calculates and returns the effect that point lighting will have on this fragment.
 * pointLight - the point light being calculated
 * normal - the normal vector of this fragment
 * viewDir - the viewing direction from the camera to this fragment
 */
lowp vec4 calcPointLighting(PointLight pointLight, lowp vec3 normal, lowp vec3 viewDir) {
    // Ambient
    lowp vec3 ambientColor = pointLight.color * pointLight.ambientIntensity;
    
    lowp vec3 lightDir = normalize(pointLight.position - frag_Position);
    
    // Diffuse
    lowp float diffuseFactor = max(dot(normal, lightDir), 0.0);
    lowp vec3 diffuseColor = pointLight.color * pointLight.diffuseIntensity * diffuseFactor;
    
    // Specular
    lowp vec3 reflectDir = reflect(-lightDir, normal);
    lowp float specularFactor = pow(max(dot(viewDir, reflectDir), 0.0), 1.0); // Leave shininess at 1.0 for now
    lowp vec3 specularColor = pointLight.color * pointLight.specularIntensity * specularFactor;
    
    // Point light attenuation
    lowp float dist = length(pointLight.position - frag_Position);
    lowp float attenuation = 1.0 / (pointLight.constant + pointLight.linear * dist +
                               pointLight.quadratic * (dist * dist));
    
    // Combine results
    return vec4((ambientColor + diffuseColor + specularColor) * attenuation, 1.0);
}
