//
//  Lilypad.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-19.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Lilypad: GameObject{
    // Game object speed
    var speed : Float;
    
    init(pos: Vector3, speed: Float){
        self.speed = speed;
        super.init(ModelCacheManager.loadModel(withMeshName: "Lilypad", withTextureName: "lilypad.png", saveToCache: true)!);
        
        // Spawn in a random position for testing purposes
        position = pos;
        rotation = Vector3(0, Float.pi, 0);
        scale = Vector3(1, 1, 1);
        type = "Lilypad";
        self.collider = BoxCollider(scale: Vector3(1,1,1)
            , max: Vector3(1,1,1)
            , min: Vector3(0.1,0.1,0.1));
        
    }
    
    // Update function
    override func update(delta: Float) {
        // If speed is positive, move right
        if(speed > 0.0){
            // If x pos is smaller than farthest right tile
            if(position.x < Float(Level.tilesPerRow)/2){
                position.x += 1 * delta * speed;
            } else {
                position.x = Float(-Level.tilesPerRow);
            }
        }
        // If speed is negative, move left
        else{
            if(position.x > Float(-Level.tilesPerRow)/2){
                position.x += 1 * delta * speed;
            } else {
                position.x = Float(Level.tilesPerRow);
            }
        }
    }
}
