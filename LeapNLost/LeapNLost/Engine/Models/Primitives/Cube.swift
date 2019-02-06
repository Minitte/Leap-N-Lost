//
//  Cube.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Struct for primitive cube models.
 */
struct Cube {
    
    static let vertexList : [Vertex] = [
        // Front
        Vertex(1, -1, 1,   1, 1, 1, 1),     // 0
        Vertex(1,  1, 1,   1, 1, 1, 1),     // 1
        Vertex(-1, 1, 1,   1, 1, 1, 1),     // 2
        Vertex(-1,-1, 1,   1, 1, 1, 1),     // 3
        
        // Back
        Vertex(-1,-1,-1,   1, 1, 1, 1),     // 4
        Vertex(-1, 1,-1,   1, 1, 1, 1),     // 5
        Vertex( 1, 1,-1,   1, 1, 1, 1),     // 6
        Vertex( 1,-1,-1,   1, 1, 1, 1)      // 7
    ]
    
    static let indexList : [GLubyte] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        
        // Back
        4, 5, 6,
        6, 7, 4,
        
        // Left
        3, 2, 5,
        5, 4, 3,
        
        // Right
        7, 6, 1,
        1, 0, 7,
        
        // Top
        1, 6, 5,
        5, 2, 1,
        
        // Bottom
        3, 4, 7,
        7, 0, 3
    ]
}
