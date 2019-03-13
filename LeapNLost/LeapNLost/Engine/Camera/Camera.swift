//
//  Camera.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-05.
//  Copyright © 2019 Ozma Inc. All rights reserved.
//

import Foundation
import GLKit

/**
 * A class holding the data required for a camera
 */
class Camera {
    
    // position matrix
    private var positionMatrix : GLKMatrix4;
    
    // camera's "Position"
    private(set) var position : Vector3;
    
    // rotation matrix
    private var rotationMatrix : GLKMatrix4;
    
    // camera's rotation
    private(set) var rotation : Vector3;
    
    // The viewing angle of the camera
    public var projectionMatrix : GLKMatrix4;
    
    // combined position and rotation matrix.
    public var transformMatrix : GLKMatrix4;
    
    /**
     * Initalizer for a camera class
     */
    init() {
        positionMatrix = GLKMatrix4Identity;
        rotationMatrix = GLKMatrix4Identity;
        projectionMatrix = GLKMatrix4Identity;
        transformMatrix = GLKMatrix4Identity;
        
        position = Vector3.init();
        rotation = Vector3.init();
        
        updateTransformMatrix();
    }
    
    /**
     * Initializer for a camera class with a set position.
     */
    init(posX x:Float, posY y:Float, posZ z:Float) {
        positionMatrix = GLKMatrix4Identity;
        rotationMatrix = GLKMatrix4Identity;
        projectionMatrix = GLKMatrix4Identity;
        transformMatrix = GLKMatrix4Identity;
        
        // Set the position matrix
        positionMatrix.m30 = x;
        positionMatrix.m31 = y;
        positionMatrix.m32 = z;
        
        position = Vector3(-x, -y, -z);
        rotation = Vector3.init();
        
        updateTransformMatrix();
    }
    
    /**
     * Sets the position of the camera.
     */
    public func setPosition(xPosition x:Float, yPosition y:Float, zPosition z:Float) {
        positionMatrix = GLKMatrix4Translate(GLKMatrix4Identity, x, y, z);
        
        position = Vector3(x, y, z);
        
        updateTransformMatrix();
    }
    
    /**
     * Translate the position of the camera.
     */
    public func translate(xTranslation x:Float, yTranslation y:Float, zTranslation z:Float) {
        positionMatrix = GLKMatrix4Translate(positionMatrix, x, y, z);
        
        position = position + Vector3(-x, -y, -z);
        
        updateTransformMatrix();
    }
    
    /**
     * Sets the rotation of the camera.
     */
    public func setRotation(xRotation x:Float, yRotation y:Float, zRotation z:Float) {
        rotationMatrix = GLKMatrix4RotateX(GLKMatrix4Identity, x);
        rotationMatrix = GLKMatrix4RotateY(rotationMatrix, y);
        rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, z);
        
        rotation = Vector3(x, y, z);
        
        updateTransformMatrix();
    }
    
    /**
     * Rotates the camera.
     */
    public func rotate(xRotation x:Float, yRotation y:Float, zRotation z:Float) {
        rotationMatrix = GLKMatrix4RotateX(rotationMatrix, x);
        rotationMatrix = GLKMatrix4RotateY(rotationMatrix, y);
        rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, z);
        
        rotation = rotation + Vector3(x, y, z);
    
        updateTransformMatrix();
    }
    
    /**
     * Sets the perspective matrix.
     */
    public func setPerspectiveMatrix(perspective m:GLKMatrix4) {
        projectionMatrix = m;
    }
    
    /**
     * calculates the perspective matrix based on the args
     */
    public func calculatePerspectiveMatrix(viewWidth w:Int, viewHeight h:Int, fieldOfView fov:Int, nearClipZ nearZ:Int, farClipZ farZ:Int) {
        let aspect = Float(w) / Float(h);
        projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), aspect, Float(nearZ), Float(farZ));
    }
    
    /**
     * Calculates a orthographic projection matrix based on the arguments.
     * viewWidth - the width of the screen
     * viewHeight - the height of the screen
     * orthoWidth - desired width of the orthographic camera
     * orthoHeight - desired height of the orthographic camera
     * nearClipZ - how close objects need to be from the camera before being clipped out
     * farClipZ - how far objects need to be from the camera before being clipped out
     */
    public func calculateOrthographicMatrix(viewWidth:Int, viewHeight:Int, orthoWidth: Float, orthoHeight: Float, nearClipZ nearZ: Float, farClipz farZ: Float) {
        let aspect : Float = Float(viewWidth) / Float(viewHeight);
        
        // Calculate half width and height of the camera
        var halfWidth = orthoWidth / 2;
        var halfHeight = orthoHeight / 2;
        
        // Adjust width and height by aspect ratio
        if (aspect >= 1.0) {
            halfWidth *= aspect;
        } else {
            halfHeight /= aspect;
        }
        
        // Set the projection matrix to orthographic
        projectionMatrix = GLKMatrix4MakeOrtho(-halfWidth, halfWidth, -halfHeight, halfHeight, nearZ, farZ);
    }
    
    /**
     * Updates the transform matrix by multiplying position and rotation.
     */
    private func updateTransformMatrix() {
        transformMatrix = GLKMatrix4Multiply(rotationMatrix, positionMatrix);
    }
}
