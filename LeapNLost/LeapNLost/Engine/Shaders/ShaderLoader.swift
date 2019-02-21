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
    
    /**
     * Compiles a shader.
     * shaderName - The name of the shader file as a String.
     * shaderType - The shader type, e.g. vertex or fragment.
     * Returns a handle to the shader as a GLuint.
     */
    private func compileShader(_ shaderName: String, shaderType: GLenum) -> GLuint {
        // Path to the shader file
        let path = Bundle.main.path(forResource: shaderName, ofType: nil)
        
        do {
            // Read in the shader source code
            let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue);
            let shaderHandle = glCreateShader(shaderType);
            var shaderStringLength : GLint = GLint(Int32(shaderString.length));
            var shaderCString = shaderString.utf8String;
            glShaderSource(shaderHandle, GLsizei(1), &shaderCString, &shaderStringLength);
            
            // Compile the shader
            glCompileShader(shaderHandle);
            var compileStatus : GLint = 0;
            glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus);
            
            // Check if successfully compiled (non-zero compileStatus)
            if compileStatus == GL_FALSE {
                var infoLength : GLsizei = 0;
                let bufferLength : GLsizei = 1024;
                glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength);
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength));
                var actualLength : GLsizei = 0;
                
                // Print error information to the console
                glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info));
                NSLog(String(validatingUTF8: info)!);
                NSLog("*** SHADER COMPILE ERROR ***");
                exit(1);
            }
            
            return shaderHandle;
            
        } catch {
            NSLog("*** SHADER COMPILE ERROR ***");
            exit(1);
        }
    }
    
    /**
     * Links the vertex and fragment shader to the openGL program.
     * vertexShader - the name of the vertex shader as a String.
     * fragmentShader - the name of the fragment shader as a String.
     */
    func compile(vertexShader: String, fragmentShader: String) -> GLuint {
        let vertexShaderName = self.compileShader(vertexShader, shaderType: GLenum(GL_VERTEX_SHADER));
        let fragmentShaderName = self.compileShader(fragmentShader, shaderType: GLenum(GL_FRAGMENT_SHADER));
        let programHandle : GLuint = glCreateProgram();
        
        // Attach shaders to the program object
        glAttachShader(programHandle, vertexShaderName);
        glAttachShader(programHandle, fragmentShaderName);
        
        // Bind arbitruary vertex attribute indices to variables in the shaders
        glBindAttribLocation(programHandle, VertexAttributes.position.rawValue, "a_Position");
        glBindAttribLocation(programHandle, VertexAttributes.color.rawValue, "a_Color");
        glBindAttribLocation(programHandle, VertexAttributes.texCoord.rawValue, "a_TexCoord");
        glBindAttribLocation(programHandle, VertexAttributes.normal.rawValue, "a_Normal");
        glLinkProgram(programHandle);
        
        // Link the shaders
        var linkStatus : GLint = 0;
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linkStatus);
        
        // Check if successfully linked (non-zero linkStatus)
        if linkStatus == GL_FALSE {
            var infoLength : GLsizei = 0;
            let bufferLength : GLsizei = 1024;
            glGetProgramiv(programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength);
            
            let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength));
            var actualLength : GLsizei = 0;
            
            // Print error information to the console
            glGetProgramInfoLog(programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info));
            NSLog(String(validatingUTF8: info)!);
            NSLog("*** SHADER LINKING ERROR ***");
            exit(1);
        }
        
        // Successfully linked, use and return the handle
        //glUseProgram(programHandle);
        return programHandle;
    }
}
