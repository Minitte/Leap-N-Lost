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
    var position : GLKVector3;
    
    // Local rotation of this game object.
    var rotation : GLKVector3;
    
    /**
     * Construtor for the game object.
     * model - the model of the game object.
     */
    init(_ model : Model) {
        self.model = model;
        
        // Spawn in a random position for testing purposes
        position = GLKVector3Make(Float.random(in: -2...2), Float.random(in: -2...2), Float.random(in: -2...2));
        rotation = GLKVector3Make(0,0,0);
    }
    
    /**
     * Update loop.
     */
    func update() {
        rotation.y += Float.random(in: 0...0.5);
    }
}
