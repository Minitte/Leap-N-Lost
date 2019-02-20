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
    
    // Camera properties
    private(set) var mainCamera : Camera;
    
    // The level
    private var level : Level;
    
    // Reference to the game view.
    private var view : GLKView;
    
    // For testing shadows***
    //var quad : GameObject;
    
    /**
     * Constructor, initializes the scene.
     * view - reference to the game view
     */
    init(view: GLKView) {
        // Initialize variables
        self.view = view;
        level = Level();
        gameObjects = [GameObject]();
        
        // Initialize a quad for testing purposes ***
        /*self.quad = GameObject(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube));
        quad.scale = Vector3(7.0, 7.0, 1.0);
        quad.position = Vector3(0, 0, -20);
        gameObjects.append(quad);*/
        
        let frogModel : Model = ModelCacheManager.loadModel(withMeshName: "frog", withTextureName: "frogtex.png")!;
        let playerGO : PlayerGameObject = PlayerGameObject.init(frogModel);
        gameObjects.append(playerGO);
        playerGO.position = Vector3(0, 0, 3);
        
        // Initialize some test lighting ***
        pointLights = [PointLight]();
        pointLights.append(PointLight(color: Vector3(1, 0, 1), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(0, 0, -10), constant: 1.0, linear: 0.2, quadratic: 0.1));
        
        directionalLight = DirectionalLight(color: Vector3(1, 1, 0.8), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, direction: Vector3(0, -2, -5));
        
        // Setup the camera
        mainCamera = Camera();
        
        // For testing purposes ***
        mainCamera.translate(xTranslation: 0, yTranslation: -5, zTranslation: -15);
        mainCamera.rotate(xRotation: Float.pi / 4, yRotation: 0, zRotation: 0)
        
        // Load the first level
        loadLevel(area: 1, level: 1);
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
            
            // Spawn things
            switch(row.type){
            case "road":
                let colors = ["Blue", "Red", "Green"];
                let carColor = colors[Int(arc4random_uniform(UInt32(colors.count)))];
                let model = ModelCacheManager.loadModel(withMeshName: "car", withTextureName: "car" + carColor + ".png", saveToCache: true);
                let model2 = Model.CreatePrimitive(primitiveType: Model.Primitive.Cube);
                let car = GameObject.init(model ?? model2);
                depth = -5;
                car.position = Vector3(Float(-Level.tilesPerRow), depth + 2, -Float(rowIndex) * 2);
                car.type = "car";
                car.speed = row.speed;
                texture = "road.jpg";
                gameObjects.append(car);
            case "water":
                let model = ModelCacheManager.loadModel(withMeshName: "Lilypad", withTextureName: "lilypad.png", saveToCache: true);
                let model2 = Model.CreatePrimitive(primitiveType: Model.Primitive.Cube);
                let lilypad = GameObject.init(model ?? model2);
                depth = -5.5;
                lilypad.position = Vector3(Float(-Level.tilesPerRow), depth + 2, -Float(rowIndex) * 2);
                lilypad.type = "lilypad";
                lilypad.speed = row.speed;
                texture = "water.jpg";
                gameObjects.append(lilypad);
            default:
                depth = -5;
                texture = "grass.jpg";
            }
            
            // Generate the row's tiles
            for tileIndex in 0..<Level.tilesPerRow {
                let tile = GameObject.init(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube));
                tile.model.loadTexture(filename: texture);
                tile.position = Vector3(Float(tileIndex - Level.tilesPerRow / 2) * 2, depth, -Float(rowIndex) * 2);
                gameObjects.append(tile);
            }
        }
    }
    
    /**
     * Update loop.
     * delta - the time since last frame
     */
    func update(delta: Float) {
        // Create a projection matrix
        mainCamera.calculatePerspectiveMatrix(viewWidth: view.drawableWidth, viewHeight: view.drawableHeight, fieldOfView: 60, nearClipZ: 1, farClipZ: 40);
        
        // Loop through every object in scene and call update
        for gameObject in gameObjects {
            gameObject.update(delta: delta);
        }
    }
}
