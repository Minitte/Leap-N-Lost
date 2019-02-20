//
//  PlayerGameObject.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class PlayerGameObject : GameObject {
 
    private var gravity : Vector3 = Vector3.init(0, -9.81 * 3, 0);
    
    private var leap : Vector3 = Vector3.init(0, 5, 1);
    
    private var velocity : Vector3 = Vector3.init(0, 0, 0);
    
    private var hopping : Bool = false;
    
    private var frameTime : Float = 1/30;
    
    /**
     * Overrided base update
     */
    override func update(delta: Float) {
        if (InputManager.singleTap && !hopping) {
            hopForward();
        }
        
        if (hopping) {
            velocity = velocity + (gravity * frameTime);
            
            let scaledVelocity : Vector3 = velocity * frameTime;
            
            position = position + scaledVelocity;
            
            if (position.y < 0) {
                position.y = 0;
                hopping = false;
            }
        }
    }
    
    public func hopForward() {
        velocity = leap * 1;
        
        hopping = true;
    }
    
}
