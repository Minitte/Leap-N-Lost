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
    
}
