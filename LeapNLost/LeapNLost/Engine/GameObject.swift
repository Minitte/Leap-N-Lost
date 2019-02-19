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
    var position : Vector3;
    
    // Local rotation of this game object.
    var rotation : Vector3;
    
    // Scale of this game object.
    var scale : Vector3;
    
    // Game object type
    var type : String;
    
    // Game object speed
    var speed : Float;
    
    /**
     * Construtor for the game object.
     * model - the model of the game object.
     */
    init(_ model : Model) {
        self.model = model;
        
        // Spawn in a random position for testing purposes
        position = Vector3(0, 0, 0);
        rotation = Vector3(0, 0, 0);
        scale = Vector3(1, 1, 1);
        type = "";
        speed = 1.0;
    }
    
    /**
     * Update loop.
     */
    func update(delta: Float) {
        
        // What type of game object is this?
        switch(type){
        // Game object is a car
        case "car":
            // If speed is positive, move right
            let colors = ["Blue", "Red", "Green"];
            if(speed > 0.0){
                rotation.y = -Float.pi/2;
                if(position.x < Float(Level.tilesPerRow)/2){
                    position.x += 1 * delta * speed;
                } else {
                    position.x = Float(-Level.tilesPerRow);
                    let carColor = colors[Int(arc4random_uniform(UInt32(colors.count)))];
                    model.loadTexture(filename: "car" + carColor + ".png");
                }
            }
            // If speed is negative, move left
            else{
                rotation.y = Float.pi/2;
                if(position.x > Float(-Level.tilesPerRow)/2){
                    position.x += 1 * delta * speed;
                } else {
                    position.x = Float(Level.tilesPerRow);
                    let carColor = colors[Int(arc4random_uniform(UInt32(colors.count)))];
                    model.loadTexture(filename: "car" + carColor + ".png");
                }
            }
        case "lilypad":
            if(speed > 0.0){
                rotation.y = Float.pi;
                if(position.x < Float(Level.tilesPerRow)/2){
                    position.x += 1 * delta * speed;
                } else {
                    position.x = Float(-Level.tilesPerRow);
                }
            }
                // If speed is negative, move left
            else{
                rotation.y = Float.pi;
                if(position.x > Float(-Level.tilesPerRow)/2){
                    position.x += 1 * delta * speed;
                } else {
                    position.x = Float(Level.tilesPerRow);
                }
            }
        default:
            // Continuously rotate around y axis for testing purposes
            //rotation.y += 1 * delta;
            //position.y += Float.random(in: -0.1...0.2);
            //position.z += Float.random(in: -0.1...0.2);
            break;
        }
    }
}
