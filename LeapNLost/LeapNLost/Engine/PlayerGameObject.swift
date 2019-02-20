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
    
    private var leapForward : Vector3 = Vector3.init(0, 9.81/2, -2);
    
    private var leapLeft : Vector3 = Vector3.init(-2, 9.81/2, 0);
    
    private var leapRight : Vector3 = Vector3.init(2, 9.81/2, 0);
    
    private var velocity : Vector3 = Vector3.init(0, 0, 0);
    	
    private var hopping : Bool = false;
    
    public var groupPositionY : Float = -3;
    
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
            velocity = velocity + (gravity * delta);
            
            let scaledVelocity : Vector3 = velocity * delta;
            
            position = position + scaledVelocity;
            
            if (position.y < groupPositionY) {
                position.y = groupPositionY;
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
