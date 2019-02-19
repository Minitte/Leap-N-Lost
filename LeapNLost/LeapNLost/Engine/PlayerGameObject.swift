//
//  PlayerGameObject.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class PlayerGameObject : GameObject {
 
    private var gravity : Vector3 = Vector3.init(0, -9.81, 0);
    
    private var leap : Vector3 = Vector3.init(1, 3, 0);
    
    private var velocity : Vector3 = Vector3.init(0, 0, 0);
    
    private var time : Float = 0;
    
    private var hopTime : Float = 0;
    
    private var hopping : Bool = false;
    
    private var frameTime : Float = 1/60;
    
    /**
     * Overrided base update
     */
    override func update(delta: Float) {
        time += frameTime;
        
        if (!hopping && time > 2) {
            time = 0;
            
            hopForward();
        }
        
        if (hopping) {
            hopTime += frameTime;
            
            velocity = velocity + (gravity * frameTime);
            
            let scaledVelocity : Vector3 = velocity * frameTime;
            
            position = position + scaledVelocity;
            
            if (position.y < 0) {
                hopping = false;
                time = 0;
            }
        }
    }
    
    public func hopForward() {
        hopTime = 0;
        
        velocity = leap * 1;
        
        hopping = true;
    }
    
}
