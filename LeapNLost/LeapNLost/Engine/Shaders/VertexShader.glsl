// Camera matrices, passed in from the engine
uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;
uniform highp mat4 u_LightSpaceMatrix;

// Vertex attributes
attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec2 a_TexCoord;
attribute vec3 a_Normal;

// Fragment attributes (the outputs)
varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;
varying highp vec4 frag_LightSpacePosition;

void main(void) {
    // Set colour and uv coordinates
    frag_Color = a_Color;
    frag_TexCoord = a_TexCoord;
    
    // Calculate world normal and position
    frag_Normal = (u_ModelViewMatrix * vec4(a_Normal, 0)).xyz;
    frag_Position = (u_ModelViewMatrix * a_Position).xyz;
    
    // Shadow mapping coordinates
    frag_LightSpacePosition = u_LightSpaceMatrix * vec4(frag_Position, 1.0);
    
    // Pass position after being multiplied by MVP matrix to fragment shader
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
}
