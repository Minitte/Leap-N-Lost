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
    
    private var leapForward : Vector3 = Vector3.init();
    
    private var leapLeft : Vector3 = Vector3.init();
    
    private var leapRight : Vector3 = Vector3.init();
    
    private var velocity : Vector3 = Vector3.init();
    	
    private var hopping : Bool = false;
    
    private var groundPositionY : Float = -3;
    
    // tile position based on x-z where z is forwards and origin is bottom center
    private var tilePosition : Vector3 = Vector3.init();
    
    init(withModel model: Model, hopLength hl: Float = 2, hopTime ht: Float = 0.5) {
        super.init(model);
        
        let h : Float = 9.81 / hl
        
        leapForward = Vector3.init(0, h, -hl);
        leapLeft = Vector3.init(-hl, h, 0);
        leapRight = Vector3.init(hl, h, 0);
        
        scale = scale * 1.5;
        rotation = Vector3.init(0, Float.pi, 0);
    }
    
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
            
            if (position.y < groundPositionY) {
                position.y = groundPositionY;
                hopping = false;
            }
        }
    }
    
    /**
     * hops forward
     */
    public func hopForward() {
        velocity = leapForward * 1;
        
        rotation = Vector3.init(0, Float.pi, 0);
        
        tilePosition.z += 1;
        
        hopping = true;
    }
    
    /**
     * hops left
     */
    public func hopLeft() {
        if (tilePosition.x <= -2) {
            return;
        }
        
        velocity = leapLeft * 1;
        
        rotation = Vector3.init(0, -Float.pi/2.0, 0);
        
        tilePosition.x += -1;
        
        hopping = true;
    }
    
    /**
     * hops right
     */
    public func hopRight() {
        if (tilePosition.x >= 2) {
            return;
        }
        
        velocity = leapRight * 1;
        
        rotation = Vector3.init(0, Float.pi/2.0, 0);
        
        tilePosition.x += 1;
        
        hopping = true;
    }
    
}
