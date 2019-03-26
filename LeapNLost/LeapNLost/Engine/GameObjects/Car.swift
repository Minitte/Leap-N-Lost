//
//  Car.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-19.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Car: GameObject{
    
    // Game object speed
    var speed : Float;
    
    // Color of the car
    var color: String;
    
    var headlight : SpotLight;
    
    init(pos: Vector3, speed: Float){
        self.speed = speed;
        self.headlight = SpotLight(color: Vector3(1, 0, 0), ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 1, position: pos, direction: pos, innerRadius: Float.pi / 4, outerRadius: Float.pi / 4 + 0.1);
        color = Car.randomColor();
        super.init(ModelCacheManager.loadModel(withMeshName: "car", withTextureName: "car" + color + ".png", saveToCache: true)!);
        
        // Spawn in a random position for testing purposes
        position = pos;
        
        // Set car rotation depending on direction
        if(speed > 0.0){
            rotation = Vector3(0, -Float.pi/2, 0);
        }else{
            rotation = Vector3(0, Float.pi/2, 0);
        }
        scale = Vector3(1, 1, 1);
        type = "Car";
        
        self.collider = BoxCollider(halfLengths: Vector3(1.25,1.25,1.25));
    }
    
    // Update function
    override func update(delta: Float) {
        // If speed is positive, move right
        if(speed > 0.0){
            // If x pos is smaller than farthest right tile
            if(position.x < Float(Level.tilesPerRow)/2){
                // Move right
                position.x += 1 * delta * speed;
            } else {
                // Reset position
                position.x = Float(-Level.tilesPerRow);
                // Change texture when car goes off screen
                model.loadTexture(fileName: "car" + Car.randomColor() + ".png");
            }
        }
        // If speed is negative, move left
        else{
            // If x pos is larger than farthest left tile
            if(position.x > Float(-Level.tilesPerRow)/2){
                // Move left
                position.x += 1 * delta * speed;
            } else {
                // Reset position
                position.x = Float(Level.tilesPerRow);
                // Change texture when car goes off screen
                model.loadTexture(fileName: "car" + Car.randomColor() + ".png");
            }
        }
        
        // Update headlight position and direction
        headlight.position = position + forward + Vector3(0, -0.5, 0);
        headlight.direction = forward;
    }
    
    // Pick a random color
    class func randomColor() -> String{
        let colors = ["Blue", "Red", "Green"];
        return colors[Int(arc4random_uniform(UInt32(colors.count)))];
    }
}
