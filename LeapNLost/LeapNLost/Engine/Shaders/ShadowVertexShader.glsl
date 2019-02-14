uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

attribute vec4 a_Position;

void main() {
    // we only care about the vertex position
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
}
