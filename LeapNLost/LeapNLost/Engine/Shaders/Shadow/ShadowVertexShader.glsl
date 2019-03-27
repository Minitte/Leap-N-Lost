// Camera matrices, passed in from the engine
uniform highp mat4 u_ModelMatrix;
uniform highp mat4 u_ViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

attribute vec4 a_Position;

void main() {
    // Pass position after being multiplied by MVP matrix to fragment shader
    gl_Position = u_ProjectionMatrix * u_ViewMatrix * u_ModelMatrix * a_Position;
}
