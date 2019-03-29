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
 * Structure that holds spot light variables.
 * See SpotLight.swift
 */
struct SpotLight {
    lowp vec3 color;
    lowp vec3 position;
    lowp vec3 direction;
    
    lowp float innerRadius;
    lowp float outerRadius;
    
    lowp float constant;
    lowp float linear;
    lowp float quadratic;
    
    lowp float ambientIntensity;
    lowp float diffuseIntensity;
    lowp float specularIntensity;
};

/**
 * Maximum number of lights that can affect
 * a fragment are defined here.
 */
#define MAX_POINT_LIGHTS 64
#define MAX_SPOT_LIGHTS 32

// Lighting variables
uniform PointLight pointLights[MAX_POINT_LIGHTS];
uniform SpotLight spotLights[MAX_SPOT_LIGHTS];
uniform DirLight dirLight;

uniform int u_totalPointLights;
uniform int u_totalSpotLights;

// The texture map
uniform sampler2D u_Texture;
uniform sampler2D u_ShadowMap;

uniform lowp vec3 view_Position; // Position of the camera

// Variables that are passed in from the vertex shader
varying lowp vec4 frag_Color; // Fragment color
varying lowp vec2 frag_TexCoord; // Texture coordinate
varying lowp vec3 frag_Normal; // Normal relative to the camera
varying lowp vec3 frag_Position; // World position
varying highp vec4 frag_LightSpacePosition; // Shadow map coordinate

// Function declarations
lowp float calcShadow();
lowp vec4 calcDirLighting(lowp vec3 normal, lowp vec3 viewDir);
lowp vec4 calcPointLighting(PointLight pointLight, lowp vec3 normal, lowp vec3 viewDir);
lowp vec4 calcSpotLighting(SpotLight spotLight, lowp vec3 normal, lowp vec3 viewDir);

void main(void) {
    // Properties
    lowp vec3 normal = normalize(frag_Normal);
    lowp vec3 viewDir = normalize(view_Position - frag_Position);
    
    // Calculate directional lighting
    lowp vec4 lighting = calcDirLighting(normal, viewDir);
    
    // Calculate point lighting
    for (int i = 0; i < u_totalPointLights; i++) {
        lighting += calcPointLighting(pointLights[i], normal, viewDir);
    }
    
    // Calculate spot lighting
    for (int i = 0; i < u_totalSpotLights; i++) {
        lighting += calcSpotLighting(spotLights[i], normal, viewDir);
    }
    
    // Calculate shadows
    lowp float shadow = calcShadow();

    // Set fragment colour
    gl_FragColor = texture2D(u_Texture, frag_TexCoord) * lighting * vec4(vec3(shadow), 1.0);
    
    // edge fog
    lowp float fogColour = calcEdgeFog();
    gl_FragColor = clamp(gl_FragColor * fogColour, 0.0, 1.0);
}

lowp float calcShadow() {
    // Convert shadow map coordinates into uv format (0 to 1)
    lowp vec3 projCoords = frag_LightSpacePosition.xyz / frag_LightSpacePosition.w;
    projCoords = projCoords * 0.5 + 0.5;
    
    // Calculate depths
    highp float closestDepth = texture2D(u_ShadowMap, projCoords.xy).r;
    highp float currentDepth = projCoords.z;
    
    highp float bias = 0.005;
    return currentDepth - bias < closestDepth ? 1.0 : 0.3; // 1.0 means no shadow
}

/**
 * Calculates and returns the effect that directional lighting will have on this fragment.
 * normal - the normal vector of this fragment
 */
lowp vec4 calcDirLighting(lowp vec3 normal, lowp vec3 viewDir) {
    // Ambient
    lowp vec3 ambientColor = dirLight.color * dirLight.ambientIntensity;
    lowp vec3 direction = normalize(dirLight.direction);
    
    // Diffuse
    lowp float diffuseFactor = max(dot(normal, -direction), 0.0);
    lowp vec3 diffuseColor = dirLight.color * dirLight.diffuseIntensity * diffuseFactor;
    
    // Specular
    lowp vec3 reflection = reflect(direction, normal);
    lowp float specularFactor = pow(max(0.0, dot(reflection, viewDir)), 16.0);
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
    
    lowp vec3 lightDir = normalize(frag_Position - pointLight.position);
    
    // Diffuse
    lowp float diffuseFactor = max(dot(normal, -lightDir), 0.0);
    lowp vec3 diffuseColor = pointLight.color * pointLight.diffuseIntensity * diffuseFactor;
    
    // Specular
    lowp vec3 reflection = reflect(lightDir, normal);
    lowp float specularFactor = pow(max(dot(reflection, viewDir), 0.0), 16.0);
    lowp vec3 specularColor = pointLight.color * pointLight.specularIntensity * specularFactor;
    
    // Point light attenuation
    lowp float dist = length(pointLight.position - frag_Position);
    lowp float attenuation = 1.0 / (pointLight.constant + pointLight.linear * dist +
                               pointLight.quadratic * (dist * dist));
    
    // Combine results
    return vec4((ambientColor + diffuseColor + specularColor) * attenuation, 1.0);
}

/**
 * Calculates and returns the effect that spot lighting will have on this fragment.
 * pointLight - the point light being calculated
 * normal - the normal vector of this fragment
 * viewDir - the viewing direction from the camera to this fragment
 */
lowp vec4 calcSpotLighting(SpotLight spotLight, lowp vec3 normal, lowp vec3 viewDir) {
    
    // Vector from the light source to the fragment
    lowp vec3 fragDirection = frag_Position - spotLight.position;
    lowp float fragDistance = length(fragDirection);
    
    // Normalize the fragment direction
    fragDirection = normalize(fragDirection);
    
    lowp float attenuation = 1.0 / (spotLight.constant + spotLight.linear * fragDistance +
                                    spotLight.quadratic * (fragDistance * fragDistance));
    
    lowp float theta = acos(dot(fragDirection, spotLight.direction));
    lowp float epsilon = spotLight.innerRadius - spotLight.outerRadius;
    lowp float intensity = clamp((theta - spotLight.outerRadius) / epsilon, 0.0, 1.0) * attenuation;
    
    // Ambient
    lowp vec3 ambientColor = spotLight.color * spotLight.ambientIntensity;
    
    // Diffuse
    lowp float diffuseFactor = max(dot(normal, -fragDirection), 0.0);
    lowp vec3 diffuseColor = spotLight.color * spotLight.diffuseIntensity * diffuseFactor;
    
    // Specular
    lowp vec3 reflection = reflect(fragDirection, normal);
    lowp float specularFactor = pow(max(dot(reflection, viewDir), 0.0), 16.0);
    lowp vec3 specularColor = spotLight.color * spotLight.specularIntensity * specularFactor;
    
    // Combine results
    return vec4((ambientColor + diffuseColor + specularColor) * vec3(intensity), 1.0);
        
    
}

/**
 * Creates a negative colour vector based on the x distance from origin of 0.
 */
lowp float calcEdgeFog() {
    mediump float edgeDist = abs(frag_Position.x);

    if (edgeDist > 6.0) {
        // fog colour
        lowp float fogColour = (edgeDist - 6.0) * 0.5;
        fogColour = clamp(fogColour * fogColour, 0.0, 1.0);
        fogColour = 1.0 - fogColour;

        return fogColour;
    }

    return 0.0;
}
