//
//  Spotlight.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-10.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Class for lights that have a direction but limited radius.
 */
class Spotlight : Light {
    
    // Position of the spotlight
    var position : Vector3;
    
    // Direction of the spotlight
    var direction : Vector3;
    
    // Radius of the inner ring
    var innerRadius : Float;
    
    // Radius of the outer ring
    var outerRadius : Float;
    
    /**
     * Default constructor, initializes all variables to zero.
     */
    override init() {
        self.position = Vector3();
        self.direction = Vector3();
        self.innerRadius = 0;
        self.outerRadius = 0;
        super.init();
    }
    
    /**
     * Constructor with parameters for each variable.
     *
     * color - the color of the light
     * ambientIntensity - scalar for the ambient light
     * diffuseIntensity - scalar for the diffuse light
     * specularIntensity - scalar for the specular light
     * position - the position of the light
     * direction - the direction of the light
     * innerRadius - radius of the inner cone
     * outerRadius - radius of the outer cone
     */
    init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float,
         position: Vector3, direction: Vector3, innerRadius: Float, outerRadius: Float) {
        self.position = position;
        self.direction = direction;
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
        super.init(color: color, ambientIntensity: ambientIntensity,
                   diffuseIntensity: diffuseIntensity, specularIntensity: specularIntensity);
    }
    
    override func render(shader: Shader) {
        
    }
}
