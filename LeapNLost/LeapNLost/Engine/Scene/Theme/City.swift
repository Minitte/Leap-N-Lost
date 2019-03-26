//
//  City.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-03-21.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Parses rows and returns the appropriate game object types for a city theme.
 */
class City : Theme {
    
    func parseRowObjects(row: Row, rowIndex: Int) -> [GameObject] {
        let rowType : String = row.type;
        
        // Initialize an empty game objects array
        var gameObjects : [GameObject] = [];
        
        // Generate game objects depending on row type
        switch rowType {
        case "road":
            // Create and append car object
            gameObjects.append(Car(pos: Vector3(Float(-Level.tilesPerRow), -3.0, -Float(rowIndex) * 2), speed: row.speed));
        case "water":
            // Create and append lilypad object
            gameObjects.append(Lilypad(pos: Vector3(Float(-Level.tilesPerRow), -4.0, -Float(rowIndex) * 2), speed: row.speed));
        case "grass":
            break; // Do nothing
        default:
            print("ERROR: Invalid row type for city theme");
        }
        
        return gameObjects;
    }
    
    func parseRowTiles(row: Row, rowIndex: Int) -> [Tile] {
        // Row properties
        let rowType : String = row.type;
        var rowDepth : Float = 0.0;
        var textureName : String?;
        
        // Initialize an empty game objects array
        var tiles : [Tile] = [];
        
        // Change texture and tile depth depending on row type
        switch rowType {
        case "road":
            textureName = "road.jpg";
            rowDepth = -5;
        case "water":
            textureName = "water.jpg";
            rowDepth = -5.5;
        case "grass":
            textureName = "grass.jpg";
            rowDepth = -5;
        default:
            print("ERROR: Invalid row type for city theme");
        }
        
        // Generate the row's tiles
        for tileIndex in 0..<Level.tilesPerRow {
            let tile = Tile(model: Model.CreatePrimitive(primitiveType: Model.Primitive.Cube), row: rowIndex, column: tileIndex);
            tile.model.loadTexture(fileName: textureName!);
            
            // Set the type
            tile.type = row.type;
            
            tile.position = Vector3(Float(tileIndex - Level.tilesPerRow / 2) * 2, rowDepth, -Float(rowIndex) * 2);
            tiles.append(tile);
        }
        
        return tiles;
    }
    
    func setupPointLights(gameObjects : [GameObject]) -> [PointLight] {
        var pointLights : [PointLight] = [];
        
        for gameObject in gameObjects {
            
            // Add lilypad point lights
            if (gameObject is Lilypad) {
                let lilypad : Lilypad = gameObject as! Lilypad;
                pointLights.append(lilypad.glow);
            }
            
            // Add memory fragment point lights
            if (gameObject is MemoryFragment) {
                let memoryFragment : MemoryFragment = gameObject as! MemoryFragment;
                pointLights.append(memoryFragment.glow);
            }
        }
        
        return pointLights;
    }

    func setupSpotLights(gameObjects : [GameObject]) -> [SpotLight] {
        var spotLights : [SpotLight] = [];
        
        for gameObject in gameObjects {
            
            // Add car headlights
            if (gameObject is Car) {
                let car : Car = gameObject as! Car;
                spotLights.append(car.headlight);
            }
        }
        
        return spotLights;
    }
    
    
}
