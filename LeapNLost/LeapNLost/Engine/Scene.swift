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
    
    /**
     * Constructor, initializes the scene.
     * view - reference to the game view
     */
    init(view: GLKView) {
        // Initialize variables
        self.view = view;
        level = Level();
        gameObjects = [GameObject]();
        
        // Initialize some test lighting
        pointLights = [PointLight]();
        pointLights.append(PointLight(color: Vector3(1, 0, 1), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(0, 0, -10), constant: 1.0, linear: 0.2, quadratic: 0.1));
        
        directionalLight = DirectionalLight(color: Vector3(1, 1, 0.8), ambientIntensity: 0.2, diffuseIntensity: 1, specularIntensity: 1, direction: Vector3(0, 0, -1));
        
        // Setup the camera
        mainCamera = Camera();
        mainCamera.setPosition(xPosition: 0, yPosition: 0, zPosition: -10);
        
        loadLevel(area: 0, level: 0);
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
        
        // Row counter
        var rowCount : Int = 0;
        
        // Generate tiles for each row
        for _ in self.level.rows {
            for i in 0..<Level.tilesPerRow {
                let tile = GameObject.init(Model.CreatePrimitive(primitiveType: Model.Primitive.Cube));
                tile.position = Vector3(Float(i - Level.tilesPerRow / 2), -5, -Float(rowCount));
                gameObjects.append(tile);
            }
            rowCount += 1;
        }
    }
    
    /**
     * Update loop.
     * delta - the time since last frame
     */
    func update(delta: Float) {
        // Create a projection matrix
        mainCamera.calculatePerspectiveMatrix(viewWidth: view.drawableWidth, viewHeight: view.drawableHeight, fieldOfView: 60, nearClipZ: 1, farClipZ: 20);
        
        // Loop through every object in scene and call update
        for gameObject in gameObjects {
            gameObject.update(delta: delta);
        }
    }
}