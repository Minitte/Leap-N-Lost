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
    
    // camera properties
    var mainCamera : Camera;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        // Initialize properties
        self.view = view;
        
        // Load shaders
        shaderLoader = ShaderLoader(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        
        // Populate with gameobjects for testing purposes
        gameObjects = [GameObject]();
        for _ in 1...10 {
            //gameObjects.append(GameObject(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube)));
            
            var go : GameObject = GameObject.init(OBJLoader.loadModel(nameOfModel: "cube")!);
            
            gameObjects.append(go);
        }
        
        mainCamera = Camera();
        mainCamera.setPosition(xPosition: 0, yPosition: 0, zPosition: -10);
        
        
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
        // Create a projection matrix
        mainCamera.calculatePerspectiveMatrix(viewWidth: view.drawableWidth, viewHeight: view.drawableHeight, fieldOfView: 60, nearClipZ: 1, farClipZ: 20);
        
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
            var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix
            var objectMatrix : GLKMatrix4 = GLKMatrix4Multiply(mainCamera.transformMatrix, positionMatrix);
            objectMatrix = GLKMatrix4Multiply(objectMatrix, rotationMatrix);
            objectMatrix = GLKMatrix4Scale(objectMatrix, gameObject.scale.x, gameObject.scale.y, gameObject.scale.z); // Scaling
            
            // Render the object after passing the matrices and texture to the shader
            shaderLoader.modelViewMatrix = objectMatrix;
            shaderLoader.projectionMatrix = mainCamera.perspectiveMatrix;
            shaderLoader.currentTexture = gameObject.model.texture;
            shaderLoader.prepareToRender();
            gameObject.model.render();
        }
    }
}
