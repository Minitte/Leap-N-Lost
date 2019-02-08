//
//  Vertex.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

// Code referenced from https://github.com/skyfe79/LearningOpenGLES2

enum VertexAttributes : GLuint {
    case position = 0;
    case color = 1;
    case texCoord = 2;
}

/**
 * Vertex definition as a struct.
 */
struct Vertex {
    // Position
    var x : GLfloat = 0.0;
    var y : GLfloat = 0.0;
    var z : GLfloat = 0.0;
    
    // Color
    var r : GLfloat = 0.0;
    var g : GLfloat = 0.0;
    var b : GLfloat = 0.0;
    var a : GLfloat = 1.0;
    
    var u : GLfloat = 0.0;
    var v : GLfloat = 0.0;
    
    
    init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ r : GLfloat = 0.0, _ g : GLfloat = 0.0, _ b : GLfloat = 0.0, _ a : GLfloat = 1.0, _ u : GLfloat = 0.0, _ v : GLfloat = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        
        self.u = u
        self.v = v
    }
}
