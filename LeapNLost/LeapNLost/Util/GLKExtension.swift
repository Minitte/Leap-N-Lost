//
//  GLKExtension.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Extensions to GLK functions.
 * Code referenced from https://github.com/skyfe79/LearningOpenGLES2
 */
extension GLKMatrix4 {
    
    // Gets all the values of the matrix as a Float array.
    var array: [Float] {
        return (0..<16).map { i in self[i]; }
    }
}
