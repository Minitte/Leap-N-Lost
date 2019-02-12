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
    case normal = 3;
}

/**
 * Vertex definition as a struct.
 */
struct Vertex {
    // Position
    var x : GLfloat;
    var y : GLfloat;
    var z : GLfloat;
    
    // Colour
    var r : GLfloat;
    var g : GLfloat;
    var b : GLfloat;
    var a : GLfloat;
    
    // Texture coordinates
    var u : GLfloat;
    var v : GLfloat;
    
    // Normals
    var nx : GLfloat;
    var ny : GLfloat;
    var nz : GLfloat;
    
    /**
     * Constructor, initializes all instance variables.
     * Vertex position is required, other parameters will default to zero if not used.
     */
    init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ r : GLfloat = 0.0, _ g : GLfloat = 0.0, _ b : GLfloat = 0.0, _ a : GLfloat = 1.0, _ u : GLfloat = 0.0, _ v : GLfloat = 0.0, _ nx : GLfloat = 0.0, _ ny : GLfloat = 0.0, _ nz : GLfloat = 0.0) {
        self.x = x;
        self.y = y;
        self.z = z;
        
        self.r = r;
        self.g = g;
        self.b = b;
        self.a = a;
        
        self.u = u;
        self.v = v;
        
        self.nx = nx;
        self.ny = ny;
        self.nz = nz;
    }
}
