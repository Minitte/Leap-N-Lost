//
//  PlayerGameObject.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class PlayerGameObject : GameObject {
    
    // gravity acceralation vector
    private var gravity : Vector3 = Vector3.init(0, -9.81, 0);
    
    // leap forward velocity vector
    private var leapForward : Vector3 = Vector3.init();
    
    // leap left velocity vector
    private var leapLeft : Vector3 = Vector3.init();
    
    // leap right velocity vector
    private var leapRight : Vector3 = Vector3.init();
    
    // velocity of the hop
    private var velocity : Vector3 = Vector3.init();
    
    // hopping flag to block other input
    var hopping : Bool = false;
    
    // ground position y value
    private var groundPositionY : Float = -3;
    
    // Flag to represent if the player is dead
    var isDead : Bool;
    
    // Flag to represent if the game is over
    var isGameOver: Bool;

    // tile position based on x-z where z is forwards and origin is bottom center
    var tilePosition : Vector3 = Vector3.init();

    init(withModel model: Model, hopLength hl: Float = 2, hopTime ht: Float = 0.5) {
        isDead = false;
        isGameOver = false;
        super.init(model);
        
        let h : Float = 9.81 / hl
        
        leapForward = Vector3.init(0, h, -hl);
        leapLeft = Vector3.init(-hl, h, 0);
        leapRight = Vector3.init(hl, h, 0);
        
        scale = scale * 1.5;
        rotation = Vector3.init(0, Float.pi, 0);
        self.collider = BoxCollider(halfLengths: Vector3.init(0.5, 0.5, 0.5));
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
                print("Player Landed on: \(tilePosition)");
                hopping = false;
            }
        }
    }
    
    /**
     * hops forward
     */
    public func hopForward() {
        if(isGameOver || isDead){
            return;
        }
        velocity = leapForward * 1;
        
        rotation = Vector3.init(0, Float.pi, 0);
        
        tilePosition.z += 1;
        
        hopping = true;

        
    }
    
    /**
     * hops left
     */
    public func hopLeft() {
        if (tilePosition.x <= -2 || isGameOver || isDead) {
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
        if (tilePosition.x >= 2 || isGameOver || isDead) {
            return;
        }
        
        velocity = leapRight * 1;
        
        rotation = Vector3.init(0, Float.pi/2.0, 0);
        
        tilePosition.x += 1;
        
        hopping = true;
    }
    
}
