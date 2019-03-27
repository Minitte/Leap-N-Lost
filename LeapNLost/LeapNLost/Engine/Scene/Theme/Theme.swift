//
//  Theme.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-03-21.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Interface for the different level themes of the game.
 */
protocol Theme {
    
    /**
     * Parses and returns an array of game objects depending on the row.
     * row - reference to the row
     * rowIndex - the row's index in the level
     */
    func parseRowObjects(row: Row, rowIndex: Int) -> [GameObject];
    
    /**
     * Parses and returns an array of tiles depending on the row.
     * row - reference to the row
     * rowIndex - the row's index in the level
     */
    func parseRowTiles(row: Row, rowIndex: Int) -> [Tile];
    
    /**
     * Iterates through an array of game objects and groups up their point lights.
     * gameObjects - the list of game objects to iterate through
     * Returns all the point lights as an array
     */
    func setupPointLights(gameObjects : [GameObject]) -> [PointLight];
    
    /**
     * Iterates through an array of game objects and groups up their spot lights.
     * gameObjects - the list of game objects to iterate through
     * Returns all the spot lights as an array
     */
    func setupSpotLights(gameObjects : [GameObject]) -> [SpotLight];
    
}
