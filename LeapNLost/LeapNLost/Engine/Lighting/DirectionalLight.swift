//
//  DirectionalLight.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-10.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

/**
 * Class for directional lights that emit a constant light in a certain direction.
 * This light applies to all game objects in the scene.
 * More information at: https://learnopengl.com/Lighting/Light-casters
 */
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
        self.direction = direction.normalize();
        super.init(color: color, ambientIntensity: ambientIntensity,
                   diffuseIntensity: diffuseIntensity, specularIntensity: specularIntensity);
    }
    
    /**
     * Renders this directional light by setting all the directional
     * light variables in the shaders.
     */
    func render(shader: Shader) {
        shader.setVector(variableName: "dirLight.color", value: color);
        shader.setVector(variableName: "dirLight.direction", value: direction);
        shader.setFloat(variableName: "dirLight.ambientIntensity", value: ambientIntensity);
        shader.setFloat(variableName: "dirLight.diffuseIntensity", value: diffuseIntensity);
        shader.setFloat(variableName: "dirLight.specularIntensity", value: specularIntensity);
    }
}
