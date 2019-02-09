//
//  ShaderLoader.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for loading and linking shaders to openGL. Basically the render engine.
 * Most of this code is referenced from https://github.com/skyfe79/LearningOpenGLES2
 */
class ShaderLoader {
    
    // The program handle as an int. Will be non-zero if there are no errors
    var programHandle : GLuint;
    
    // Locations of uniform variables in the shaders
    var modelViewMatrixUniform : Int32;
    var projectionMatrixUniform : Int32;
    var textureUniform : Int32;
    
    // Model, view, and projection matrices
    var modelViewMatrix : GLKMatrix4;
    var projectionMatrix : GLKMatrix4;
    
    /**
     * Constructor for this class. Compiles the shaders after initializing.
     * vertexShader - The name of the vertex shader file as a String
     * fragmentShader - the name of the fragment shader file as a String
     */
    init(vertexShader: String, fragmentShader: String) {
        // Initialize variables
        programHandle = 0;
        modelViewMatrixUniform = 0;
        projectionMatrixUniform = 0;
        textureUniform = 0;
        modelViewMatrix = GLKMatrix4Identity;
        projectionMatrix = GLKMatrix4Identity;
        
        // Compile shaders
        self.compile(vertexShader: vertexShader, fragmentShader: fragmentShader);
        glUseProgram(self.programHandle);
        //glActiveTexture(GLenum(GL_TEXTURE0))
    }
    
    /**
     * Prepares the render of the current frame in openGL.
     */
    func prepareToRender() {
        // Set uniform variables in the shaders
        glUniformMatrix4fv(self.projectionMatrixUniform, 1, GLboolean(GL_FALSE), self.projectionMatrix.array);
        glUniformMatrix4fv(self.modelViewMatrixUniform, 1, GLboolean(GL_FALSE), self.modelViewMatrix.array);
        glUniform1i(self.textureUniform, 0)
    }
    
    /**
     * Compiles a shader.
     * shaderName - The name of the shader file as a String.
     * shaderType - The shader type, e.g. vertex or fragment.
     * Returns a handle to the shader as a GLuint.
     */
    func compileShader(_ shaderName: String, shaderType: GLenum) -> GLuint {
        // Path to the shader file
        let path = Bundle.main.path(forResource: shaderName, ofType: nil)
        
        do {
            let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue);
            let shaderHandle = glCreateShader(shaderType);
            var shaderStringLength : GLint = GLint(Int32(shaderString.length));
            var shaderCString = shaderString.utf8String;
            glShaderSource(shaderHandle, GLsizei(1), &shaderCString, &shaderStringLength);
            
            glCompileShader(shaderHandle);
            var compileStatus : GLint = 0;
            glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus);
            
            if compileStatus == GL_FALSE {
                var infoLength : GLsizei = 0;
                let bufferLength : GLsizei = 1024;
                glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength);
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength));
                var actualLength : GLsizei = 0;
                
                glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info));
                NSLog(String(validatingUTF8: info)!);
                NSLog("*** SHADER COMPILE ERROR ***");
                exit(1);
            }
            
            return shaderHandle;
            
        } catch {
            NSLog("*** SHADER COMPILE ERROR ***");
            exit(1); // Error
        }
    }
    
    /**
     * Links the vertex and fragment shader to the openGL program.
     * vertexShader - the name of the vertex shader as a String.
     * fragmentShader - the name of the fragment shader as a String.
     */
    func compile(vertexShader: String, fragmentShader: String) {
        let vertexShaderName = self.compileShader(vertexShader, shaderType: GLenum(GL_VERTEX_SHADER));
        let fragmentShaderName = self.compileShader(fragmentShader, shaderType: GLenum(GL_FRAGMENT_SHADER));
        
        self.programHandle = glCreateProgram();
        glAttachShader(self.programHandle, vertexShaderName);
        glAttachShader(self.programHandle, fragmentShaderName);
        
        glBindAttribLocation(self.programHandle, VertexAttributes.position.rawValue, "a_Position");
        glBindAttribLocation(self.programHandle, VertexAttributes.color.rawValue, "a_Color");
        glBindAttribLocation(self.programHandle, VertexAttributes.texCoord.rawValue, "a_TexCoord")
        glLinkProgram(self.programHandle);
        
        // Get locations of uniform variables in shaders
        self.modelViewMatrixUniform = glGetUniformLocation(self.programHandle, "u_ModelViewMatrix");
        self.projectionMatrixUniform = glGetUniformLocation(self.programHandle, "u_ProjectionMatrix");
        self.textureUniform = glGetUniformLocation(self.programHandle, "u_Texture");
        
        var linkStatus : GLint = 0;
        glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus);
        if linkStatus == GL_FALSE {
            var infoLength : GLsizei = 0;
            let bufferLength : GLsizei = 1024;
            glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength);
            
            let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength));
            var actualLength : GLsizei = 0;
            
            glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info));
            NSLog(String(validatingUTF8: info)!);
            NSLog("*** SHADER LINKING ERROR ***");
            exit(1);
        }
    }
}
