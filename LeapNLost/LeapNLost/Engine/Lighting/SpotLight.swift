//
//  SpotLight.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-10.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Class for lights that have a direction but limited radius.
 */
class SpotLight : Light {
    
    // Position of the spotlight
    var position : Vector3;
    
    // Direction of the spotlight
    var direction : Vector3;
    
    // Radius of the inner ring
    var innerRadius : Float;
    
    // Radius of the outer ring
    var outerRadius : Float;
    
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
        self.direction = Vector3();
        self.innerRadius = 0;
        self.outerRadius = 0;
        self.constant = 0;
        self.linear = 0;
        self.quadratic = 0;
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
     * constant - the constant term, Kc
     * linear - the linear term, Kl
     * quadratic - the quadratic term, kq
     */
    init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float,
         position: Vector3, direction: Vector3, innerRadius: Float, outerRadius: Float,
         constant: Float, linear: Float, quadratic: Float) {
        self.position = position;
        self.direction = direction;
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
        self.constant = constant;
        self.linear = linear;
        self.quadratic = quadratic;
        super.init(color: color, ambientIntensity: ambientIntensity,
                   diffuseIntensity: diffuseIntensity, specularIntensity: specularIntensity);
    }
    
    /**
     * Renders this spot light by setting all the spot
     * light variables in the shaders.
     */
    func render(shader: Shader, lightNumber : Int) {
        shader.setVector(variableName: "spotLights[" + String(lightNumber) + "].color", value: color);
        shader.setVector(variableName: "spotLights[" + String(lightNumber) + "].position", value: position);
        shader.setVector(variableName: "spotLights[" + String(lightNumber) + "].direction", value: direction);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].innerRadius", value: innerRadius);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].outerRadius", value: outerRadius);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].constant", value: constant);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].linear", value: linear);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].quadratic", value: quadratic);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].ambientIntensity", value: ambientIntensity);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].diffuseIntensity", value: diffuseIntensity);
        shader.setFloat(variableName: "spotLights[" + String(lightNumber) + "].specularIntensity", value: specularIntensity);
    }
}
