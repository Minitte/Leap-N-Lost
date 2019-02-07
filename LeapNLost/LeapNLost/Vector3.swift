//
//  Vector3.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

// Minimum difference for checking if two Floats are equal.
let epsilon : Float = 0.001;

/**
 * This is a class for vector objects that contain three floating point numbers.
 */
class Vector3 : CustomStringConvertible {
    
    public var description : String { return "x: \(x) y: \(y) z: \(z)"};
    
    var x : Float;
    var y : Float;
    var z : Float;
    
    /*
     * Default constructor, sets all variables to zero.
     */
    init() {
        x = 0.0;
        y = 0.0;
        z = 0.0;
    }
    
    /**
     * Constructor with parameters for each instance variable.
     * x - the x value of the vector
     * y - The y value of the vector
     * z - the z value of the vector
     */
    init(withX x: Float, withY y: Float, withZ z: Float) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    
    /*
     * Returns a GLK representation of this vector.
     */
    func toGLK() -> GLKVector3 {
        return GLKVector3Make(x, y, z);
    }
    
    /*
     * Returns the magnitude of this vector.
     */
    func magnitude() -> Float {
        return sqrtf(powf(x, 2) + powf(y, 2) + powf(z, 2));
    }
    
    /**
     * Returns the unit representation of this vector.
     */
    func normalize() -> Vector3 {
        let magnitude : Float = self.magnitude();
        return Vector3(withX: x / magnitude, withY: y / magnitude, withZ: z / magnitude);
    }
}

func ==(left: Vector3, right: Vector3) -> Bool {
    if (fabsf(left.x - right.x) < epsilon && fabsf(left.y - right.y) < epsilon && fabsf(left.z - right.z) < epsilon) {
        return true;
    } else {
        return false;
    }
}

/**
 * Operator overloader for adding two vectors using +
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns the sum of the two vectors.
 */
func +(left: Vector3, right: Vector3) -> Vector3 {
    let sum = Vector3(withX: left.x + right.x, withY: left.y + right.y, withZ: left.z + right.z);
    return sum;
}

/**
 * Operator overloader for subtracting two vectors using -
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns the difference of the two vectors.
 */
func -(left: Vector3, right: Vector3) -> Vector3 {
    let sum = Vector3(withX: left.x - right.x, withY: left.y - right.y, withZ: left.z - right.z);
    return sum;
}

/**
 * Operator overloader for multiplying two vectors together using *
 * left - the vector on the left side
 * right - the float scalar on the right side
 * Returns the vector after multiplying.
 */
func *(left: Vector3, right: Vector3) -> Vector3 {
    let product = Vector3(withX: left.x * right.x, withY: left.y * right.y, withZ: left.z * right.z);
    return product;
}

/**
 * Operator overloader for scaling a vector with a float using *
 * left - the vector on the left side
 * right - the float scalar on the right side
 * Returns the vector after scaling.
 */
func *(left: Vector3, right: Float) -> Vector3 {
    let product = Vector3(withX: left.x * right, withY: left.y * right, withZ: left.z * right);
    return product;
}

/**
 * Operator overloader for scaling a vector with a float using *
 * left - the vector on the left side
 * right - the int scalar on the right side
 * Returns the vector after scaling.
 */
func *(left: Vector3, right: Int) -> Vector3 {
    let intScalar = Float(right);
    let product = Vector3(withX: left.x * intScalar, withY: left.y * intScalar, withZ: left.z * intScalar);
    return product;
}

/**
 * Operator overloader for dividng a vector with another vector using /
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns the vector after dividing.
 */
func /(left: Vector3, right: Vector3) -> Vector3 {
    let product = Vector3(withX: left.x / right.x, withY: left.y / right.y, withZ: left.z / right.z);
    return product;
}

/**
 * Operator overloader for dividing a vector with a float using /
 * left - the vector on the left side
 * right - the float divisor on the right side
 * Returns the vector after dividing.
 */
func /(left: Vector3, right: Float) -> Vector3 {
    let product = Vector3(withX: left.x / right, withY: left.y / right, withZ: left.z / right);
    return product;
}

/**
 * Operator overloader for dividng a vector with an Int using /
 * left - the vector on the left side
 * right - the int divisor on the right side
 * Returns the vector after dividing.
 */
func /(left: Vector3, right: Int) -> Vector3 {
    let intDivisor = Float(right);
    let product = Vector3(withX: left.x / intDivisor, withY: left.y / intDivisor, withZ: left.z / intDivisor);
    return product;
}
