//
//  Light.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-09.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Class that stores lighting properties.
 */
class Light {
    
    // Color of the light
    var color : Vector3;
    
    // Intensities of the light
    var ambientIntensity : Float;
    var diffuseIntensity : Float;
    var specularIntensity : Float;
    
    /**
     * Default constructor, initializes all variables to zero.
     * Visibility is protected to prevent initializaiton by classes
     * that aren't subclasses of this.
     */
    internal init() {
        // Initialize variables
        self.color = Vector3();
        self.ambientIntensity = 0;
        self.diffuseIntensity = 0;
        self.specularIntensity = 0;
    }
    
    /**
     * Constructor with parameters for each variable.
     * Visibility is protected to prevent being initialization by classes
     * that aren't subclasses of this.
     *
     * color - the color of the light
     * ambientIntensity - scalar for the ambient light
     * diffuseIntensity - scalar for the diffuse light
     * specularIntensity - scalar for the specular light
     */
    internal init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float) {
        self.color = color;
        self.ambientIntensity = ambientIntensity;
        self.diffuseIntensity = diffuseIntensity;
        self.specularIntensity = specularIntensity;
    }
    
}
