//
//  GameObject.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for game objects.
 * Each game object contains a model.
 */
class GameObject : NSObject {
    
    // The model of the game object.
    var model : Model;
    
    // World position of this game object.
    var position : Vector3 {
        didSet {
            updateTransform();
        }
    };
    
    // Local rotation of this game object.
    var rotation : Vector3 {
        didSet {
            updateTransform();
        }
    };
    
    // Scale of this game object.
    var scale : Vector3 {
        didSet {
            updateTransform();
        }
    };
    
    // This game object's transformation matrix.
    var transformMatrix : GLKMatrix4;
    
    // Game object type
    var type : String;
    
    //Optional collider used for collisions.
    var collider : Collider?;
    
    /**
     * Construtor for the game object.
     * model - the model of the game object.
     */
    init(_ model : Model) {
        self.model = model;
        self.transformMatrix = GLKMatrix4Identity;
        
        // Spawn in a random position for testing purposes
        position = Vector3(0, 0, 0);
        rotation = Vector3(0, 0, 0);
        scale = Vector3(1, 1, 1);
        type = "Default";
    }
    
    /**
     * Update loop.
     */
    func update(delta: Float) {
        // Continuously rotate around y axis for testing purposes
        //rotation.y += 1 * delta;
        //position.y += Float.random(in: -0.1...0.2);
        //position.z += Float.random(in: -0.1...0.2);
    }
    
    /**
     * Updates this game object's transformation matrix.
     */
    func updateTransform() {
        // Get the game object's rotation as a matrix
        var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, rotation.x);
        rotationMatrix = GLKMatrix4RotateY(rotationMatrix, rotation.y);
        rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, rotation.z);
        
        // Get the game object's position as a matrix
        let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, position.x, position.y, position.z);
        
        // Calculate transformation matrix
        transformMatrix = GLKMatrix4Multiply(positionMatrix, rotationMatrix);
        transformMatrix = GLKMatrix4Scale(transformMatrix, scale.x, scale.y, scale.z); // Scaling
    }
}
