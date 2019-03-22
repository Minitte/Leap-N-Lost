//
//  Scene.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class that holds information about scenes in the game.
 */
class Scene {
    
    // The directional light in the scene, i.e. the sun
    var directionalLight : DirectionalLight;
    
    // Arrays of all lights in the scene.
    var pointLights : [PointLight];

    // List of all game objects in the scene
    var gameObjects : [GameObject];
    
    // List of all tiles in the scene
    var tiles : [Tile];
    
    // Reference to the player object.
    var player : PlayerGameObject;
    
    // Dictionary containing references of objects.
    var collisionDictionary : [Int: [GameObject]];
    
    // Camera properties
    private(set) var mainCamera : CameraFollowTarget;
    
    // The level
    private(set) var level : Level;
    
    // Reference to the game view.
    private var view : GLKView;
    
    /**
     * Constructor, initializes the scene.
     * view - reference to the game view
     */
    init(view: GLKView) {
        // Initialize variables
        self.view = view;
        self.level = Level();
        self.gameObjects = [GameObject]();
        self.tiles = [Tile]();
        self.collisionDictionary = [Int:[GameObject]]();
        
        let frogModel : Model = ModelCacheManager.loadModel(withMeshName: "frog", withTextureName: "frogtex.png")!;
        
        player = PlayerGameObject.init(withModel: frogModel);
        player.type = "Player";
        gameObjects.append(player);
        
        // Initialize some test lighting ***
        pointLights = [PointLight]();
        pointLights.append(PointLight(color: Vector3(1, 0, 1), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(0, 0, -10), constant: 1.0, linear: 0.2, quadratic: 0.1));
        
        directionalLight = DirectionalLight(color: Vector3(1, 1, 0.8), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, direction: Vector3(0, -2, -5));
        
        // Setup the camera
        let camOffset : Vector3 = Vector3(0, -10, -8.5);
        mainCamera = CameraFollowTarget(cameraOffset: camOffset, trackTarget: player);
        
        // For testing purposes ***
        mainCamera.rotate(xRotation: Float.pi / 4, yRotation: 0, zRotation: 0)
        
        // Load the first level ***
        loadLevel(area: 1, level: 1);
        
        // Have to set current scene here because of swift
        player.currentScene = self;
        
        // Set player position
        player.teleportToTarget(target: getTile(row: 0, column: Level.tilesPerRow / 2)!);
    }
    
    /**
     * Gets a tile from the given row and column
     */
    func getTile(row: Int, column: Int) -> Tile? {
        // Check if row and column are valid
        if (row >= 0 && row < level.rows.count && column >= 0 && column < Level.tilesPerRow) {
            return tiles[Level.tilesPerRow * row + column];
        }
        
        return nil;
    }
    
    /**
     * Loads a level.
     * area - the level area
     * level - the level number
     */
    func loadLevel(area: Int, level: Int) {
        // Parse the level
        let data = self.level.readLevel(withArea: area, withLevel: level);
        self.level = self.level.parseJSON(data: data);
        
        // Generate tiles for each row
        for rowIndex in 0..<self.level.rows.count {
            let row = self.level.rows[rowIndex];
            var texture : String;
            var depth : Float;
            var currentObjects : [GameObject] = [GameObject]();
            // Spawn things
            switch(row.type){
            case "road":
                depth = -5;
                texture = "road.jpg";
                
                // Create car object
                let car = Car.init(pos: Vector3(Float(-Level.tilesPerRow), depth + 2, -Float(rowIndex) * 2), speed: row.speed);
                gameObjects.append(car);
                currentObjects.append(car)
                
                
            case "water":
                depth = -5.5;
                
                // Create lilypad object
                let lilypad = Lilypad.init(pos: Vector3(Float(-Level.tilesPerRow), depth + 2, -Float(rowIndex) * 2), speed: row.speed);
                texture = "water.jpg";
                gameObjects.append(lilypad);
                currentObjects.append(lilypad);
            default:
                depth = -5;
                texture = "grass.jpg";
            }
            
            collisionDictionary[rowIndex] = currentObjects;
            
            // Generate the row's tiles
            for tileIndex in 0..<Level.tilesPerRow {
                let tile = Tile(model: Model.CreatePrimitive(primitiveType: Model.Primitive.Cube), row: rowIndex, column: tileIndex);
                tile.model.loadTexture(fileName: texture);
                
                // Set the type
                tile.type = row.type;
                
                tile.position = Vector3(Float(tileIndex - Level.tilesPerRow / 2) * 2, depth, -Float(rowIndex) * 2);
                tiles.append(tile);
            }
        }
        
        //Creating a MemoryFragment and appending to gameobjects.
        let memoryFragment = MemoryFragment(position: getTile(row: self.level.rows.count - 1, column: Level.tilesPerRow / 2)!.position + Vector3(0, 2, 0));

        gameObjects.append(memoryFragment);
        
    }
    
    /**
     * Update loop.
     * delta - the time since last frame
     */
    func update(delta: Float) {
        // Create a projection matrix
        //mainCamera.calculatePerspectiveMatrix(viewWidth: view.drawableWidth, viewHeight: view.drawableHeight, fieldOfView: 60, nearClipZ: 1, farClipZ: 40);
        //mainCamera.calculateOrthographicMatrix(viewWidth: Int(view.window!.frame.width), viewHeight: Int(view.window!.frame.height), nearClipZ: 0.1, farClipz: 50);
        mainCamera.calculateOrthographicMatrix(viewWidth: view.drawableWidth, viewHeight: view.drawableHeight, orthoWidth: 10, orthoHeight: 10, nearClipZ: 0.1, farClipz: 50);
        
        // Loop through every object in scene and call update
        for gameObject in gameObjects {
            gameObject.update(delta: delta);
        }
        
        mainCamera.updatePosition();
    }
}
