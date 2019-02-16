uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

attribute vec4 a_Position;

void main() {
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
}
