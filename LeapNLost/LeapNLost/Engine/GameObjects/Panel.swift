//
//  Panel.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-04-03.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Panel : GameObject {
    // Game object speed
    var speed : Float;
    
    // Glow effect for night levels
    var glow : PointLight;
    
    init(pos: Vector3, speed: Float){
        self.speed = speed;
        self.glow = PointLight(color: Vector3(0.2, 0.2, 0.8), ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(), constant: 2.0, linear: 1.5, quadratic: 1);
        super.init(ModelCacheManager.loadModel(withMeshName: "panel", withTextureName: "panel.png", saveToCache: true)!);
        
        // Spawn in a random position for testing purposes
        position = pos;
        rotation = Vector3(0, Float.pi, 0);
        scale = Vector3(1, 1, 1);
        type = "Panel";
        self.collider = BoxCollider(halfLengths: Vector3(1,1,1));
        
    }
    
    // Update function
    override func update(delta: Float) {
        // If speed is positive, move right
        if(speed > 0.0){
            // If x pos is smaller than farthest right tile
            if(position.x < Float(Level.tilesPerRow)){
                position.x += 1 * delta * speed;
            } else {
                position.x = Float(-Level.tilesPerRow);
            }
        }
            // If speed is negative, move left
        else{
            if(position.x > Float(-Level.tilesPerRow)){
                position.x += 1 * delta * speed;
            } else {
                position.x = Float(Level.tilesPerRow);
            }
        }
        
        // Update glow light position
        glow.position = position;
    }
}
