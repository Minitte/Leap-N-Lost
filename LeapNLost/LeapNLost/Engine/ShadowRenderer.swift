//
//  ShadowRenderer.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-14.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Handles the rendering of the shadow map.
 */
class ShadowRenderer {
    
    var shadowCamera : Camera;
    
    // The frame buffer for storing depth values.
    var shadowBuffer : ShadowBuffer;
    
    // The shader for shadow mapping
    var shadowShader : Shader;
    
    /**
     * Default constructor, initializes variables.
     */
    init() {
        // Initialize variables
        shadowBuffer = ShadowBuffer();
        shadowCamera = Camera();
        let programHandle : GLuint = ShaderLoader().compile(vertexShader: "ShadowVertexShader.glsl", fragmentShader: "ShadowFragmentShader.glsl");
        self.shadowShader = Shader(programHandle: programHandle);
        setupCamera();
        
        glEnable(GLenum(GL_CULL_FACE));
    }
    
    func setupCamera() {
        let nearPlane : Float = 1;
        let farPlane : Float = 60;
        
        let lightProjection : GLKMatrix4 = GLKMatrix4MakeOrtho(-10, 10, -10, 10, nearPlane, farPlane);
        let lightInvDirection = Vector3(0, 1, 10);
        let lightView : GLKMatrix4 = GLKMatrix4MakeLookAt(lightInvDirection.x, lightInvDirection.y, lightInvDirection.z, 0, 0, 0, 0, 1, 0);
        shadowCamera.perspectiveMatrix = GLKMatrix4Multiply(lightProjection, lightView);
        shadowCamera.setPosition(xPosition: 0, yPosition: 0, zPosition: -10);
    }
    
    /**
     * Renders the depth values of the scene onto the shadow texture.
     */
    func render(scene: Scene) {
        // Set viewport, shader, and frame buffer to shadow mappping settings
        glViewport(0, 0, 1024, 1024);
        glUseProgram(shadowShader.programHandle);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), shadowBuffer.bufferName);
        
        // Clear screen and depth buffer
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        // Render only back faces, this avoids self shadowing
        glCullFace(GLenum(GL_FRONT));
        
        // TODO - Change this to a orthographic matrix
        shadowShader.setMatrix(variableName: "u_ProjectionMatrix", value: shadowCamera.perspectiveMatrix);
        
        // Loop through every object in scene and call render
        for gameObject in scene.gameObjects {
            if (gameObject == scene.quad) {
                continue; // Testing
            }
            
            // Get the game object's rotation as a matrix
            var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix
            var objectMatrix : GLKMatrix4 = GLKMatrix4Multiply(scene.mainCamera.transformMatrix, positionMatrix);
            objectMatrix = GLKMatrix4Multiply(objectMatrix, rotationMatrix);
            objectMatrix = GLKMatrix4Scale(objectMatrix, gameObject.scale.x, gameObject.scale.y, gameObject.scale.z); // Scaling
            
            // Render the object after passing model view matrix to the shader
            shadowShader.setMatrix(variableName: "u_ModelViewMatrix", value: objectMatrix);
            gameObject.model.render();
        }
        
        // Unbind the shadow buffer
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0);
    }
}
