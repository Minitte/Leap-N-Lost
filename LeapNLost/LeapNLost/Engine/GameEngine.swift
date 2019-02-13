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
    private var shader : Shader;
    
    // Array of all game objects in the scene.
    var gameObjects : [GameObject];
    
    // The directional light in the scene, i.e. the sun
    var directionalLight : DirectionalLight;
    
    // Arrays of all lights in the scene.
    var pointLights : [PointLight];
    //var spotlights : [Spotlight];
    
    // Camera properties
    var mainCamera : Camera;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        // Initialize properties
        self.view = view;
        
        // Load shaders
        let programHandle : GLuint = ShaderLoader().compile(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        self.shader = Shader(programHandle: programHandle);
        
        // Populate with gameobjects for testing purposes
        gameObjects = [GameObject]();
        for _ in 1...5 {
//            gameObjects.append(GameObject(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube)));
            
//            let model : Model = ModelCachManager.instance.loadModel(withMeshName: "frog", withTextureName: "frogTex.png")!;
            
//            let go : GameObject = GameObject.init(model);

            let go : GameObject = GameObject.init(OBJLoader.loadModel(nameOfModel: "frog")!);
            
            go.scale = Vector3(3,3,3);

            gameObjects.append(go);
        }
        
        // Initialize some test lighting
        pointLights = [PointLight]();
        pointLights.append(PointLight(color: Vector3(0, 0, 0), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(0, 0, -10), constant: 1.0, linear: 0.2, quadratic: 0.1));
        
        directionalLight = DirectionalLight(color: Vector3(1, 1, 1), ambientIntensity: 1, diffuseIntensity: 0, specularIntensity: 0, direction: Vector3(0, 0, -1));
        
        // Setup the camera
        mainCamera = Camera();
        mainCamera.setPosition(xPosition: 0, yPosition: 0, zPosition: -10);
    }
    
    /**
     * The update loop.
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
        
        // Set camera variables in shader
        
        shader.setVector(variableName: "view_Position", value: Vector3(0, 0, -10));
        shader.setMatrix(variableName: "u_ProjectionMatrix", value: mainCamera.perspectiveMatrix);
        
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
            
            // Apply all point lights to the rendering of this game object
            // TODO - Only apply point lights that are within range
            for i in 0..<pointLights.count {
                pointLights[i].render(shader: shader, lightNumber: i);
            }
            
            // Apply directional light
            directionalLight.render(shader: shader);
            
            // Render the object after passing model view matrix and texture to the shader
            shader.setMatrix(variableName: "u_ModelViewMatrix", value: objectMatrix);
            shader.setTexture(texture: gameObject.model.texture);
            gameObject.model.render();
        }
    }
}
