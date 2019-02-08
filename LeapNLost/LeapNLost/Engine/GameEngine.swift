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
    
    // Reference to the shader loader.
    private var shaderLoader : ShaderLoader;
    
    // Array of all game objects in the scene.
    var gameObjects : [GameObject];
    
    // Camera matrices
    var modelViewMatrix : GLKMatrix4;
    var projectionMatrix : GLKMatrix4;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        // Initialize properties
        self.view = view;
        modelViewMatrix = GLKMatrix4Identity;
        projectionMatrix = GLKMatrix4Identity;
        
        // Load shaders
        shaderLoader = ShaderLoader(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        
        // Populate with gameobjects for testing purposes
        gameObjects = [GameObject]();
        for _ in 1...10 {
            gameObjects.append(GameObject(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube)));
        }
        
        setupGL();
    }
    
    /**
     * Any additional setup for openGL is done here
     */
    func setupGL() {
        // Enable depth buffer
        view.drawableDepthFormat = GLKViewDrawableDepthFormat.format24;
        glEnable(GLbitfield(GL_DEPTH_TEST));
    }
    
    /**
     * The update loop
     */
    func update() {
        // Create a model view matrix
        modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -10.0);
 
        // Create a projection matrix
        let aspect = Float(view.drawableWidth) / Float(view.drawableHeight);
        projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), aspect, 1, 20);
        
        // Loop through every object in scene and call update
        for gameObject in gameObjects {
            gameObject.update();
        }
    }
    
    /**
     * The render loop.
     */
    func render(_ draw : CGRect) {
        // Clear screen and buffers
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        // Loop through every object in scene and call render
        for gameObject in gameObjects {
            
            // Get the game object's rotation as a matrix
            var rotationMatrix = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            var positionMatrix = GLKMatrix4Identity;
            positionMatrix = GLKMatrix4Translate(positionMatrix, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix
            var objectMatrix = GLKMatrix4Multiply(modelViewMatrix, positionMatrix);
            objectMatrix = GLKMatrix4Multiply(objectMatrix, rotationMatrix);
            objectMatrix = GLKMatrix4Scale(objectMatrix, 0.2, 0.2, 0.2);
            
            // Render the object after passing the matrices to the shader
            shaderLoader.modelViewMatrix = objectMatrix;
            shaderLoader.projectionMatrix = projectionMatrix;
            shaderLoader.prepareToDraw();
            gameObject.model.render();
        }
    }
}
