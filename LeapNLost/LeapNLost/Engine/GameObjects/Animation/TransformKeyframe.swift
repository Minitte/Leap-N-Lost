//
//  Keyframe.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-17.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class TransformKeyframe {
    
    // A position change for the keyframe in animation
    var position : Vector3;
    
    // A rotation change for the keyframe in animation
    var rotation : Vector3;
    
    // A scale change for the keyframe in animation
    var scale : Vector3;
    
    // The time which the animation will play the keyframe at
    var atTime : Float;
    
    /**
     * Default initalizer
     */
    init() {
        position = Vector3();
        
        rotation = Vector3();
        
        scale = Vector3();
        
        atTime = 0.0;
    }
    
    /**
     * Init. with all transform changes
     */
    init(withPosition pos:Vector3, withRotation rot:Vector3, withScale scale:Vector3, atTime time:Float) {
        position = pos;
        
        rotation = rot;
        
        self.scale = scale;
        
        atTime = time;
    }
    
    /**
     * Init. with only position changes
     */
    init(withPosition pos:Vector3, atTime time:Float) {
        position = pos;
        
        rotation = Vector3();
        
        scale = Vector3();
        
        atTime = time;
    }
    
    /**
     * Init. with only rotation changes
     */
    init(withRotation rot:Vector3, atTime time:Float) {
        position = Vector3();
        
        rotation = rot;
        
        self.scale = Vector3();
        
        atTime = time;
    }
    
    /**
     * Init. with only scale changes
     */
    init(withScale scale:Vector3, atTime time:Float) {
        position = Vector3();
        
        rotation = Vector3();
        
        self.scale = scale;
        
        atTime = time;
    }
}
