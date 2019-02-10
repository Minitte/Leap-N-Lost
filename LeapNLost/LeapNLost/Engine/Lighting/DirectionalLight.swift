//
//  DirectionalLight.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-10.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class DirectionalLight : Light {
    
    // Direction of the light
    var direction: Vector3;
    
    /**
     * Default constructor, initializes all variables to zero.
     */
    override init() {
        self.direction = Vector3();
        super.init();
    }
    
    /**
     * Constructor with parameters for each variable.
     *
     * color - the color of the light
     * ambientIntensity - scalar for the ambient light
     * diffuseIntensity - scalar for the diffuse light
     * specularIntensity - scalar for the specular light
     * direction - the direction that the light is facing
     */
    init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float,
        direction: Vector3) {
        self.direction = direction;
        super.init(color: color, ambientIntensity: ambientIntensity,
                   diffuseIntensity: diffuseIntensity, specularIntensity: specularIntensity);
    }
}
