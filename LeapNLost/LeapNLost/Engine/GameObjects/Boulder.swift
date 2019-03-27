//
//  Boulder.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-03-26.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Boulder : GameObject{
    
    // Game object speed
    var speed : Float;
    
    var glow : PointLight;
    
    init(pos: Vector3, speed: Float){
        self.speed = speed;
        self.glow = PointLight(color: Vector3(0.7, 0.7, 0.7), ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 1, position: pos, constant: 2.0, linear: 1.5, quadratic: 1.0);
        super.init(ModelCacheManager.loadModel(withMeshName: "rock", withTextureName: "rock.png", saveToCache: true)!);
        
        position = pos;
        
        scale = Vector3(1, 1, 1);
        type = "Boulder";
        
        self.collider = BoxCollider(halfLengths: Vector3(1.25,1.25,1.25), canKillPlayer: true);
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
        
        // Rotate boulder based on rolling speed
        rotation.z -= (speed * 1.5) * delta;
        
        // Update light position
        glow.position = position;
    }
}
