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
    
    private var leapForward : Vector3 = Vector3.init(0, 5, -1);
    
    private var leapLeft : Vector3 = Vector3.init(-1, 5, 0);
    
    private var leapRight : Vector3 = Vector3.init(1, 5, 0);
    
    private var velocity : Vector3 = Vector3.init(0, 0, 0);
    	
    private var hopping : Bool = false;
    
    private var frameTime : Float = 1/30;
    
    /**
     * Overrided base update
     */
    override func update(delta: Float) {
        if (!hopping) {
            if (InputManager.singleTap) {
                hopForward();
            }
            
            if (InputManager.leftSwipe) {
                hopLeft();
            }
            
            if (InputManager.rightSwipe) {
                hopRight();
            }
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
    
    /**
     * hops forward
     */
    public func hopForward() {
        velocity = leapForward * 1;
        
        hopping = true;
    }
    
    /**
     * hops left
     */
    public func hopLeft() {
        velocity = leapLeft * 1;
        
        hopping = true;
    }
    
    /**
     * hops right
     */
    public func hopRight() {
        velocity = leapRight * 1;
        
        hopping = true;
    }
    
}
