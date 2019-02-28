// Camera matrices, passed in from the engine
uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

// Vertex attributes
attribute vec4 a_Position;

void main(void) {
    // Pass position after being multiplied by MVP matrix to fragment shader
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
}
