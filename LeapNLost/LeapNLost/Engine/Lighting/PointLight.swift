//
//  PointLight.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-10.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Class for point lights that emit an attenuating light in all directions.
 * More information at: https://learnopengl.com/Lighting/Light-casters
 */
class PointLight : Light {
    
    // Position of the point light
    var position : Vector3;
    
    // The constant attenuation term, Kc
    var constant : Float;
    
    // The linear attenuation term, Kl
    var linear : Float;
    
    // The quadratic attenuation term, Kq
    var quadratic : Float;
    
    /**
     * Default constructor, initializes all variables to zero.
     */
    override init() {
        self.position = Vector3();
        constant = 0;
        linear = 0;
        quadratic = 0;
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
     * constant - the constant term, Kc
     * linear - the linear term, Kl
     * quadratic - the quadratic term, kq
     */
    init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float,
         position: Vector3, constant: Float, linear: Float, quadratic: Float) {
        self.position = position;
        self.constant = constant;
        self.linear = linear;
        self.quadratic = quadratic;
        super.init(color: color, ambientIntensity: ambientIntensity,
                   diffuseIntensity: diffuseIntensity, specularIntensity: specularIntensity);
    }
}
