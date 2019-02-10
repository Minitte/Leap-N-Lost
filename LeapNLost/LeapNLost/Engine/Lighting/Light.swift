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
    
    // Position of the light
    var position : Vector3;
    
    // Direction that the light is facing
    var direction : Vector3;
    
    // Color of the light
    var color : Vector3;
    
    // Intensities of the light
    var ambientIntensity : Float;
    var diffuseIntensity : Float;
    var specularIntensity : Float;
    
    /**
     * Default constructor, sets all variables to zero.
     */
    init() {
        // Initialize variables
        position = Vector3();
        direction = Vector3();
        color = Vector3();
        ambientIntensity = 0;
        diffuseIntensity = 0;
        specularIntensity = 0;
    }
    
    /**
     * Constructor with parameters for each variable.
     * position - the position of the light
     * direction - the direction that the light is facing
     * color - the color of the light
     * ambientIntensity - scalar for the ambient light
     * diffuseIntensity - scalar for the diffuse light
     * specularIntensity - scalar for the specular light
     */
    init(position: Vector3, direction: Vector3, color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float) {
        self.position = position;
        self.direction = direction;
        self.color = color;
        self.ambientIntensity = ambientIntensity;
        self.diffuseIntensity = diffuseIntensity;
        self.specularIntensity = specularIntensity;
    }
}
