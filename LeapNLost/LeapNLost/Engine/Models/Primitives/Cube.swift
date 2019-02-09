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
        Vertex( 1, -1, 1,  1, 0, 0, 1,  0.25, 0), // 0
        Vertex( 1,  1, 1,  0, 1, 0, 1,  0.25, 0.25), // 1
        Vertex(-1,  1, 1,  0, 0, 1, 1,  0, 0.25), // 2
        Vertex(-1, -1, 1,  0, 0, 0, 1,  0, 0), // 3
        
        // Back
        Vertex(-1, -1, -1, 0, 0, 1, 1,  0.5, 0), // 4
        Vertex(-1,  1, -1, 0, 1, 0, 1,  0.5, 0.25), // 5
        Vertex( 1,  1, -1, 1, 0, 0, 1,  0.25, 0.25), // 6
        Vertex( 1, -1, -1, 0, 0, 0, 1,  0.25, 0), // 7
        
        // Left
        Vertex(-1, -1,  1, 1, 0, 0, 1,  0.75, 0), // 8
        Vertex(-1,  1,  1, 0, 1, 0, 1,  0.75, 0.25), // 9
        Vertex(-1,  1, -1, 0, 0, 1, 1,  0.5, 0.25), // 10
        Vertex(-1, -1, -1, 0, 0, 0, 1,  0.5, 0), // 11
        
        // Right
        Vertex( 1, -1, -1, 1, 0, 0, 1,  1, 0), // 12
        Vertex( 1,  1, -1, 0, 1, 0, 1,  1, 0.25), // 13
        Vertex( 1,  1,  1, 0, 0, 1, 1,  0.75, 0.25), // 14
        Vertex( 1, -1,  1, 0, 0, 0, 1,  0.75, 0), // 15
        
        // Top
        Vertex( 1,  1,  1, 1, 0, 0, 1,  0.25, 0.25), // 16
        Vertex( 1,  1, -1, 0, 1, 0, 1,  0.25, 0.5), // 17
        Vertex(-1,  1, -1, 0, 0, 1, 1,  0, 0.5), // 18
        Vertex(-1,  1,  1, 0, 0, 0, 1,  0, 0.25), // 19
        
        // Bottom
        Vertex( 1, -1, -1, 1, 0, 0, 1,  0.5, 0.25), // 20
        Vertex( 1, -1,  1, 0, 1, 0, 1,  0.5, 0.5), // 21
        Vertex(-1, -1,  1, 0, 0, 1, 1,  0.25, 0.5), // 22
        Vertex(-1, -1, -1, 0, 0, 0, 1,  0.25, 0.25), // 23
    ]
    
    static let indexList : [GLubyte] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        
        // Back
        4, 5, 6,
        6, 7, 4,
        
        // Left
        8, 9, 10,
        10, 11, 8,
        
        // Right
        12, 13, 14,
        14, 15, 12,
        
        // Top
        16, 17, 18,
        18, 19, 16,
        
        // Bottom
        20, 21, 22,
        22, 23, 20
    ]
}
