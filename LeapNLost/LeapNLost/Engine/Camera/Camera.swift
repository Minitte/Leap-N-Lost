//
//  Camera.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * A class holding the data required for a camera
 */
class Camera {
    
    // position matrix
    private var positionMatrix : GLKMatrix4;
    
    // rotation matrix
    private var rotationMatrix : GLKMatrix4;
    
    // perspective matrix
    private var perspectiveMatrix : GLKMatrix4;
    
    // combined matrix of position, rotation and perspective
    private var combinedMatrix : GLKMatrix4;
    
    /**
     * initalizer for a camera class
     */
    init() {
        positionMatrix = GLKMatrix4Identity;
        rotationMatrix = GLKMatrix4Identity;
        perspectiveMatrix = GLKMatrix4Identity;
        combinedMatrix = GLKMatrix4Identity;
    }
    
    /**
     * Sets the position of the camera
     */
    public func setPosition(xPosition x:Float, yPosition y:Float, zPosition z:Float) {
        positionMatrix = GLKMatrix4Translate(GLKMatrix4Identity, x, y, z);
        
        updateCombined();
    }
    
    /**
     * Translate the position of the camera
     */
    public func translate(xTranslation x:Float, yTranslation y:Float, zTranslation z:Float) {
        positionMatrix = GLKMatrix4Translate(positionMatrix, x, y, z);
        
        updateCombined();
    }
    
    /**
     * Sets the rotation of the camera
     */
    public func setRotation(xRotation x:Float, yRotation y:Float, zRotation z:Float) {
        rotationMatrix = GLKMatrix4RotateX(GLKMatrix4Identity, x);
        rotationMatrix = GLKMatrix4RotateY(rotationMatrix, y);
        rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, z);
        
        updateCombined();
    }
    
    /**
     * Rotates the camera
     */
    public func rotate(xRotation x:Float, yRotation y:Float, zRotation z:Float) {
        rotationMatrix = GLKMatrix4RotateX(rotationMatrix, x);
        rotationMatrix = GLKMatrix4RotateY(rotationMatrix, y);
        rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, z);
        
        updateCombined();
    }
    
    /**
     * Sets the perspective matrix
     */
    public func setPerspectiveMatrix(perspective m:GLKMatrix4) {
        perspectiveMatrix = m;
        
        updateCombined();
    }
    
    /**
     * Returns the combined matrix for the camera. A perspective needs to be passed
     * in the camera using setPerspective for this to properly work.
     */
    public func getCombinedMatrix() -> GLKMatrix4 {
        return combinedMatrix;
    }
    
    /**
     * Updates the combined matrix by multiplying position, rotation and perspective together
     */
    private func updateCombined() {
        combinedMatrix = GLKMatrix4Multiply(positionMatrix, rotationMatrix);
        combinedMatrix = GLKMatrix4Multiply(perspectiveMatrix, combinedMatrix);
    }
}
