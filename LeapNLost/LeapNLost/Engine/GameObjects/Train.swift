//
//  Train.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-04-03.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Train : GameObject {
    // Game object speed
    var speed : Float;
    
    var headlight : SpotLight;
    
    init(pos: Vector3, speed: Float){
        self.speed = speed;
        self.headlight = SpotLight(color: Vector3(1, 1, 0.8), ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(), direction: Vector3(), innerRadius: Float.pi / 3, outerRadius: Float.pi / 3 + 0.2, constant: 1.0, linear: 0.8, quadratic: 0.5);
        super.init(ModelCacheManager.loadModel(withMeshName: "train", withTextureName: "train.png", saveToCache: true)!);
        
        // Spawn in a random position for testing purposes
        position = pos;
        
        // Set train rotation depending on direction
        if(speed > 0.0){
            rotation = Vector3(0, -Float.pi/2, 0);
        }else{
            rotation = Vector3(0, Float.pi/2, 0);
        }
        scale = Vector3(0.2, 0.3, 0.2);
        type = "Train";
        
        self.collider = BoxCollider(halfLengths: Vector3(2.25,1.25,1.25), canKillPlayer: true);
    }
    
    // Update function
    override func update(delta: Float) {
        // If speed is positive, move right
        if(speed > 0.0){
            // If x pos is smaller than farthest right tile
            if(position.x < Float(Level.tilesPerRow)){
                // Move right
                position.x += 1 * delta * speed;
            } else {
                // Reset position
                position.x = Float(-Level.tilesPerRow) + (position.x - Float(Level.tilesPerRow));
            }
        }
            // If speed is negative, move left
        else{
            // If x pos is larger than farthest left tile
            if(position.x > Float(-Level.tilesPerRow)){
                // Move left
                position.x += 1 * delta * speed;
            } else {
                // Reset position
                position.x = Float(Level.tilesPerRow) + (position.x + Float(Level.tilesPerRow));
            }
        }
        
        // Update headlight position and direction
        headlight.position = position + (forward * 1.5) + Vector3(0, 0, -0.75);
        headlight.direction = forward;
    }
}
