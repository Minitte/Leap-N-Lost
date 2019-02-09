uniform sampler2D u_Texture;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal; // World normal
varying lowp vec3 frag_Position; // World position


void main(void) {
    gl_FragColor = texture2D(u_Texture, frag_TexCoord);
}
