//
//  GameEngine.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for the game engine.
 * Renders and updates all game objects every frame.
 */
class GameEngine {
    
    // Reference to the game view.
    private var view : GLKView;
    
    // Reference to the shader
    private var mainShader : Shader;
    
    // The current scene
    var currentScene : Scene;
    
    // Holds the timestamp for the last frame rendered
    var lastTime : UInt64;
    
    // Handles shadow mapping
    var shadowRenderer : ShadowRenderer;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        // Initialize variables
        self.view = view;
        self.shadowRenderer = ShadowRenderer();
        self.currentScene = Scene(view: view);
        lastTime = mach_absolute_time();

        // Load shaders
        let shaderLoader = ShaderLoader();
        let programHandle : GLuint = shaderLoader.compile(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        self.mainShader = Shader(programHandle: programHandle);
    }
    
    /**
     * The update loop.
     */
    func update() {
        // Calculate delta time
        let delta : Float = Float(mach_absolute_time() - lastTime) / 1000000000; // Convert nanoseconds to seconds
        lastTime = mach_absolute_time();
        
        // Update the scene
        currentScene.update(delta: delta);
    }
    
    /**
     * The render loop.
     */
    func render(_ draw : CGRect) {
        // Render shadows first
        shadowRenderer.render(scene: currentScene);
        
        // Switch view back to the default frame buffer
        view.bindDrawable();
        glUseProgram(mainShader.programHandle);
        
        // Clear screen and buffers, set viewport to correct size
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glViewport(0, 0, GLsizei(Float(draw.width * 2)), GLsizei(draw.height * 2));
        
        // Set camera variables in shader
        mainShader.setVector(variableName: "view_Position", value: Vector3(0, 0, 10));
        //mainShader.setMatrix(variableName: "u_ProjectionMatrix", value: currentScene.mainCamera.perspectiveMatrix);
        mainShader.setMatrix(variableName: "u_ProjectionMatrix", value: shadowRenderer.shadowCamera.perspectiveMatrix);
        
        // Bind shadow map texture
        mainShader.setTexture(textureName: "u_ShadowMap", textureNum: 1, texture: shadowRenderer.shadowBuffer.depthTexture);
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), shadowRenderer.shadowBuffer.depthTexture);
        
        // Loop through every object in scene and call render
        for gameObject in currentScene.gameObjects {
            if (gameObject != currentScene.quad) {
                continue; // Testing purposes
            }
            
            // Get the game object's rotation as a matrix
            var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix
            //var objectMatrix : GLKMatrix4 = GLKMatrix4Multiply(currentScene.mainCamera.transformMatrix, positionMatrix);
            var objectMatrix : GLKMatrix4 = GLKMatrix4Multiply(shadowRenderer.shadowCamera.transformMatrix, positionMatrix);
            objectMatrix = GLKMatrix4Multiply(objectMatrix, rotationMatrix);
            objectMatrix = GLKMatrix4Scale(objectMatrix, gameObject.scale.x, gameObject.scale.y, gameObject.scale.z); // Scaling
            
            // Apply all point lights to the rendering of this game object
            // TODO - Only apply point lights that are within range
            for i in 0..<currentScene.pointLights.count {
                currentScene.pointLights[i].render(shader: mainShader, lightNumber: i);
            }
            
            // Apply directional light
            currentScene.directionalLight.render(shader: mainShader);
            
            // Render the object after passing model view matrix and texture to the shader
            mainShader.setMatrix(variableName: "u_ModelViewMatrix", value: objectMatrix);
            mainShader.setTexture(textureName: "u_Texture", textureNum: 0, texture: gameObject.model.texture);
            glActiveTexture(GLenum(GL_TEXTURE0));
            glBindTexture(GLenum(GL_TEXTURE_2D), gameObject.model.texture);
            gameObject.model.render();
        }
    }
}
