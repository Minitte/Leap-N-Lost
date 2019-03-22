//
//  PhysicsEngine.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-28.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

class PhysicsEngine {
    
    // Toggle for enabling debug buxes
    private(set) var debug : Bool = false;
    
    // Reference to the collider shader
    private var colliderShader : Shader;
    
    // Reference to the current scene
    private var currentScene : Scene;
    
    /**
     * Constructor, initializes variables.
     * currentScene - the current scene of the game
     */
    init(currentScene: Scene) {
        self.currentScene = currentScene;
        
        // Initialize the collision shader
        let programHandle : GLuint = ShaderLoader().compile(vertexShader: "ColliderVertexShader.glsl", fragmentShader: "ColliderFragmentShader.glsl");
        self.colliderShader = Shader(programHandle: programHandle);
    }
    
    /**
     * Checks for collisions between the player and other game objects.
     */
    func checkCollisions() {
        var onLilypad : Bool = false;
        let player = currentScene.player;
        let collisionDictionary = currentScene.collisionDictionary;
        
        // Iterate through every game object in the player's current row
        for gameObject in collisionDictionary[Int(player.tileRow)]!{
            
            if((gameObject.collider!.CheckCollision(first: player, second: gameObject))) {
                
                if (gameObject.type == "Lilypad") {
                    //player.position = gameObject.position + Vector3(0, 0.5, 0);
                    onLilypad = true;
                    break;
                } else {
                    currentScene.player.isDead = true;
                }
            }
        }
        
        // Check if the player landed on water
        if (currentScene.tiles[player.tileRow * Level.tilesPerRow].type == "water" && !onLilypad) {
            player.isDead = true;
        }
    }
    
    /**
     * Update loop for collisions.
     */
    func update(delta : Float) {
        // Check collisions based on which row the player is on.
        if (!currentScene.player.hopping) {
            checkCollisions();
        }
    }
    
    /**
     * Render loop for collisions.
     */
    func render() {
        if (debug) {
            // Unbind textures
            glBindTexture(GLenum(GL_TEXTURE_2D), 0);
            
            // Switch to collider shader
            glUseProgram(colliderShader.programHandle);
            
            // Enable blending (transparency)
            glEnable(GLenum(GL_BLEND));
            glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
            
            // Set camera matrices in shader
            colliderShader.setMatrix(variableName: "u_ProjectionMatrix", value: currentScene.mainCamera.projectionMatrix);
            colliderShader.setMatrix(variableName: "u_ViewMatrix", value: currentScene.mainCamera.transformMatrix);
            
            // Loop through every object in scene and call render
            for gameObject in currentScene.gameObjects {
                
                // Assume every collider is a box collider for now
                let collider : BoxCollider = gameObject.collider as! BoxCollider;
                
                // Get the game object's position as a matrix
                let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
                
                // Multiply together to get transformation matrix
                let objectMatrix = GLKMatrix4Scale(positionMatrix, collider.halfLengths.x, collider.halfLengths.y, collider.halfLengths.z); // Scaling
                
                // Render the object after passing model view matrix and texture to the shader
                colliderShader.setMatrix(variableName: "u_ModelMatrix", value: objectMatrix);
                
                // Render the collider
                collider.model!.render();
            }
        }
    }
}
