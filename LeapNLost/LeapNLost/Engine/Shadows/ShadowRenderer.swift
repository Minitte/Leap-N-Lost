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
     * directionalLight - reference to the scene's directional light
     */
    init(lightDirection : Vector3) {
        // Initialize variables
        shadowBuffer = ShadowBuffer();
        shadowCamera = Camera();
        let programHandle : GLuint = ShaderLoader().compile(vertexShader: "ShadowVertexShader.glsl", fragmentShader: "ShadowFragmentShader.glsl");
        self.shadowShader = Shader(programHandle: programHandle);
        setupCamera(lightDirection: lightDirection);
        
        // Enable culling
        glEnable(GLenum(GL_CULL_FACE));
    }
    
    /**
     * Sets up the shadow camera.
     * lightDirection - the direction of the scene's main light source
     */
    func setupCamera(lightDirection : Vector3) {
        let nearPlane : Float = 1;
        let farPlane : Float = 60;
        
        // Create the orthographic camera
        // TODO - Create it without hardcoding the view parameters
        let lightProjection : GLKMatrix4 = GLKMatrix4MakeOrtho(-20, 20, -20, 25, nearPlane, farPlane);
        let lightInvDirection = -lightDirection;
        let lightView : GLKMatrix4 = GLKMatrix4MakeLookAt(lightInvDirection.x, lightInvDirection.y, lightInvDirection.z, 0, 0, 0, 0, 1, 0);
        shadowCamera.projectionMatrix = GLKMatrix4Multiply(lightProjection, lightView);
    }
    
    /**
     * Renders the depth values of the scene onto the shadow texture.
     */
    func render(scene: Scene) {
        // Set viewport, shader, and frame buffer to shadow mappping settings
        glUseProgram(shadowShader.programHandle);
        glViewport(0, 0, shadowBuffer.textureSize, shadowBuffer.textureSize);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), shadowBuffer.bufferName);
        
        // Clear screen and depth buffer
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        // Render only back faces, this avoids self shadowing
        glCullFace(GLenum(GL_FRONT));
        
        // Set the projection matrix
        shadowShader.setMatrix(variableName: "u_ProjectionMatrix", value: shadowCamera.projectionMatrix);
        
        // Loop through every object in scene and call render
        for gameObject in scene.gameObjects {
            
            // Get the game object's rotation as a matrix
            var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix, use the main camera's transform matrix here
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
