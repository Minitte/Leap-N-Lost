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
class GameObject {
    
    // The model of the game object.
    var model : Model;
    
    // World position of this game object.
    var position : Vector3;
    
    // Local rotation of this game object.
    var rotation : Vector3;
    
    // Scale of this game object.
    var scale : Vector3;
    
    /**
     * Construtor for the game object.
     * model - the model of the game object.
     */
    init(_ model : Model) {
        self.model = model;
        
        // Spawn in a random position for testing purposes
        position = Vector3(Float.random(in: -2...2), Float.random(in: -2...2), Float.random(in: -2...2));
        rotation = Vector3(0, 0, 0);
        scale = Vector3(0.5, 0.5, 0.5);
    }
    
    /**
     * Update loop.
     */
    func update(delta: Float) {
        // Continuously rotate around y axis for testing purposes
        rotation.y += 1 * delta;
        position.y += Float.random(in: -0.1...0.2);
    }
}
