//
//  Vector3.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * This is a class for vector objects that contain three floating point numbers.
 */
class Vector3 : CustomStringConvertible {
    
    // Minimum difference for checking if two Floats are equal.
    fileprivate static let Epsilon : Float = 0.001;
    
    // Returns a String representation of the vector (i.e. toString).
    var description : String { return "x: \(x) y: \(y) z: \(z)"};
    
    // Vector shorthands
    private(set) static var Forward : Vector3 = Vector3 (0, 0, 1)
    private(set) static var Up : Vector3 = Vector3(0, 1, 0)
    private(set) static var Left : Vector3 = Vector3(-1, 0, 0)
    private(set) static var Right : Vector3 = Vector3(1, 0, 0)
    
    // Vector components
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
    init(_ x: Float, _ y: Float, _ z: Float) {
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
        return Vector3(x / magnitude, y / magnitude, z / magnitude);
    }
    
    /**
     * other - the other vector
     * Returns the dot product of the two vectors.
     */
    func dot(other: Vector3) -> Float {
        return (x * other.x + y * other.y + z * other.z);
    }
    
    /**
     * other - the other vector
     * Returns the projection of this vector onto the other vector.
     */
    func project(other: Vector3) -> Vector3 {
        let dotProduct = self.dot(other: other);
        return other * (dotProduct / (powf(other.magnitude(), 2)));
    }
}

/**
 * Operator overloader for checking if two vectors are equal using ==
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns true if the vectors are equal, false otherwise
 */
func ==(left: Vector3, right: Vector3) -> Bool {
    if (fabsf(left.x - right.x) < Vector3.Epsilon && fabsf(left.y - right.y) < Vector3.Epsilon && fabsf(left.z - right.z) < Vector3.Epsilon) {
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
    let sum = Vector3(left.x + right.x, left.y + right.y, left.z + right.z);
    return sum;
}

/**
 * Operator overloader for subtracting two vectors using -
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns the difference of the two vectors.
 */
func -(left: Vector3, right: Vector3) -> Vector3 {
    let sum = Vector3(left.x - right.x, left.y - right.y, left.z - right.z);
    return sum;
}

/**
 * Operator overloader for multiplying two vectors together using *
 * left - the vector on the left side
 * right - the float scalar on the right side
 * Returns the vector after multiplying.
 */
func *(left: Vector3, right: Vector3) -> Vector3 {
    let product = Vector3(left.x * right.x, left.y * right.y, left.z * right.z);
    return product;
}

/**
 * Operator overloader for scaling a vector with a float using *
 * left - the vector on the left side
 * right - the float scalar on the right side
 * Returns the vector after scaling.
 */
func *(left: Vector3, right: Float) -> Vector3 {
    let product = Vector3(left.x * right, left.y * right, left.z * right);
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
    let product = Vector3(left.x * intScalar, left.y * intScalar, left.z * intScalar);
    return product;
}

/**
 * Operator overloader for dividng a vector with another vector using /
 * left - the vector on the left side
 * right - the vector on the right side
 * Returns the vector after dividing.
 */
func /(left: Vector3, right: Vector3) -> Vector3 {
    let product = Vector3(left.x / right.x, left.y / right.y, left.z / right.z);
    return product;
}

/**
 * Operator overloader for dividing a vector with a float using /
 * left - the vector on the left side
 * right - the float divisor on the right side
 * Returns the vector after dividing.
 */
func /(left: Vector3, right: Float) -> Vector3 {
    let product = Vector3(left.x / right, left.y / right, left.z / right);
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
    let product = Vector3(left.x / intDivisor, left.y / intDivisor, left.z / intDivisor);
    return product;
}
