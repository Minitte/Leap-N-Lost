//
//  Jungle.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-03-26.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Parses rows and returns the appropriate game object types for a jungle theme.
 */
class Jungle : Theme {
    
    // Specify number of objects per row here
    private let bouldersPerRow : Int = 2;
    private let logsPerRow : Int = 3;
    
    func parseRowObjects(row: Row, rowIndex: Int) -> [GameObject] {
        let rowType : String = row.type;
        
        // Initialize an empty game objects array
        var gameObjects : [GameObject] = [];
        
        // Generate game objects depending on row type
        switch rowType {
        case "road":
            // Section for each boulder
            let sectionWidth : Float = (Float(Level.tilesPerRow) * 2.0) / Float(bouldersPerRow);
            
            // Create and append car object
            for i in 0...bouldersPerRow - 1 {
                gameObjects.append(Boulder(pos: Vector3(sectionWidth * Float(i) - Float(Level.tilesPerRow), -3.0, -Float(rowIndex) * 2), speed: row.speed));
            }
        case "water":
            // Section for each log
            let sectionWidth : Float = (Float(Level.tilesPerRow) * 2.0) / Float(logsPerRow);
            
            // Create and append log object
            for i in 0...logsPerRow - 1 {
                gameObjects.append(Log(pos: Vector3(sectionWidth * Float(i) - Float(Level.tilesPerRow), -4.2, -Float(rowIndex) * 2), speed: row.speed));
            }
        case "grass":
            break; // Do nothing
        default:
            print("ERROR: Invalid row type for Jungle theme");
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
            textureName = "dirt.jpg";
            rowDepth = -5;
        case "water":
            textureName = "water.jpg";
            rowDepth = -5.5;
        case "grass":
            textureName = "darkgrass.jpg";
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
            if (gameObject is Log) {
                let log : Log = gameObject as! Log;
                pointLights.append(log.glow);
            }
            
            // Add memory fragment point lights
            if (gameObject is MemoryFragment) {
                let memoryFragment : MemoryFragment = gameObject as! MemoryFragment;
                pointLights.append(memoryFragment.glow);
            }
            
            if (gameObject is Boulder) {
                let boulder : Boulder = gameObject as! Boulder;
                pointLights.append(boulder.glow);
            }
        }
        
        return pointLights;
    }
    
    func setupSpotLights(gameObjects : [GameObject]) -> [SpotLight] {
        let spotLights : [SpotLight] = [];
        // No spotlights in jungle theme
        return spotLights;
    }
}
