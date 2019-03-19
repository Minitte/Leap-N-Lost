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
    private var hopVelocity : Vector3 = Vector3.init();
    
    // The time it takes to complete a hop
    private var maxHopTime : Float;
    
    // velocity of the hop
    private var velocity : Vector3 = Vector3.init();
    
    // hopping flag to block other input
    var hopping : Bool = false;
    
    var prepingHop : Bool = false;
    
    // Flag to represent if the player is dead
    var isDead : Bool;

    // tile position based on x-z where z is forwards and origin is bottom center
    //var tilePosition : Vector3 = Vector3.init();
    
    // The current tile that the player is on
    var currentTile : Tile?;
    
    // The current target object to home into
    var targetObject : GameObject?;
    
    // Reference to the current scene
    weak var currentScene : Scene?;

    // Animation for pre hop
    private var preHopAnimation : TransformAnimation = TransformAnimation();
    
    // Time to check hop time
    private var hopTime : Float = 0.0;
    
    /**
     * Inits the player object with a model
     */
    init(withModel model: Model, hopTime ht: Float = 0.5) {
        isDead = false;
        
        maxHopTime = ht;
        
        super.init(model);
        
        // Calculated from kinematic formula
        hopVelocity = Vector3(0, 0.5 * 9.81 * maxHopTime, 0);
        
        scale = scale * 1.5;
        rotation = Vector3.init(0, Float.pi, 0);
        self.collider = BoxCollider(halfLengths: Vector3.init(0.5, 0.5, 0.5));
        
        // animation setup
        preHopAnimation.originalScale = self.scale;
        
        // add keyframes
        preHopAnimation.addKeyframe(newKeyframe: TransformKeyframe(withScale: Vector3(0.2, -0.75, 0.2), atTime: 0.15));
    }
    
    /**
     * Sets the player's position directly on top of the given tile.
     * tile - the tile to teleport onto
     */
    func teleportToTile(tile : Tile) {
        currentTile = tile;
        self.position = tile.position + Vector3(0, 2, 0);
    }
    
    /**
     * Overrided base update
     */
    override func update(delta: Float) {
        if (!hopping) {
            if (InputManager.touched) {
                if (!prepingHop) {
                    preHopAnimation.playFromStart();
                }
                
                prepingHop = true;
            }
            
            if (InputManager.singleTap) {
                hopForward();
                stopPrepingHop();
            }
            
            if (InputManager.leftSwipe) {
                hopLeft();
            }
            
            if (InputManager.rightSwipe) {
                hopRight();
            }
        }
        
        if (prepingHop) {
            preHopAnimation.update(delta: delta);
            
            self.scale = preHopAnimation.scale;
        }
        
        // Riding the lilypad
        if (!hopping && targetObject != nil) {
            self.position = targetObject!.position + Vector3(0, 0.5, 0);
        }
        
        if (hopping) {
            hopTime = hopTime + delta;
            
            var limitedDelta : Float = delta;
            
            if (hopTime >= maxHopTime) {
                limitedDelta = limitedDelta - (maxHopTime - hopTime);
            }
            
            // Targeting a lilypad
            if (targetObject != nil) {
                jumpToTarget(target: targetObject!.position + Vector3(0, 0.5, 0), resetY: false);
            }
            
            velocity = velocity + (gravity * limitedDelta);
            
            let scaledVelocity : Vector3 = velocity * limitedDelta;
            
            position = position + scaledVelocity;
            
            if (hopTime >= maxHopTime) {
                if (targetObject == nil) {
                    teleportToTile(tile: currentTile!);
                }
                
                print("Player Landed on: \(currentTile!.position)");
                hopping = false;
            }
        }
    }
    
    /**
     * hops forward
     */
    public func hopForward() {
        var targetTile : Tile? = currentScene!.getTile(row: currentTile!.row + 1, column: currentTile!.column);
        
        // If we are on a lilypad already
        if (targetObject != nil) {
            targetTile = currentScene!.getTile(row: currentTile!.row + 1, column: Int((targetObject!.position.x + Float(Level.tilesPerRow)) / 2.0 - 0.5));
        }
        
        if (targetTile == nil) {
            return;
        }
        
        targetObject = nil;
        
        // copy velocity for y velocity for hopping
        velocity = hopVelocity;
        
        if (targetTile!.type == "water") {
            let lilypads : [GameObject] = currentScene!.collisionDictionary[targetTile!.row]!;
            
            var closestDist : Float = 1000000.0;
            
            var closest : GameObject?;
            
            for lilypad in lilypads {
                let dist : Float = (lilypad.position - self.position).magnitude();
                
                if (dist < 2.5 && dist < closestDist) {
                    closestDist = dist;
                    closest = lilypad;
                }
            }
            
            if (closest != nil) {
                targetObject = closest;
            } else {
                jumpToTarget(target: targetTile!.position);
            }
        } else {
            
            jumpToTarget(target: targetTile!.position);
        }
        rotation = Vector3.init(0, Float.pi, 0);
        
        currentTile = targetTile;
        
        // TODO: handle special case for targetTile.water == "water"
        
        hopTime = 0.0;
        
        hopping = true;
    }
    
    /**
     * hops left
     */
    public func hopLeft() {
        let targetTile : Tile? = currentScene!.getTile(row: currentTile!.row, column: currentTile!.column - 1);
        
        if (targetTile == nil) {
            return;
        }
        
        targetObject = nil;
        
        jumpToTarget(target: targetTile!.position);
        
        rotation = Vector3.init(0, -Float.pi/2.0, 0);
        
        currentTile = targetTile;
        
        hopTime = 0.0;
        
        hopping = true;
    }
    
    /**
     * hops right
     */
    public func hopRight() {
        let targetTile : Tile? = currentScene!.getTile(row: currentTile!.row, column: currentTile!.column + 1);
        
        if (targetTile == nil) {
            return;
        }
        
        targetObject = nil;
        
        jumpToTarget(target: targetTile!.position);
        
        rotation = Vector3.init(0, Float.pi/2.0, 0);
        
        currentTile = targetTile;
        
        hopTime = 0.0;
        
        hopping = true;
    }
    
    /**
     * Undos the prehop animation
     */
    private func stopPrepingHop() {
        prepingHop = false;
        preHopAnimation.stop();
        
        self.scale = preHopAnimation.originalScale;
    }
    
    private func jumpToTarget(target : Vector3, resetY : Bool = true) {
        if (resetY) {
            velocity = hopVelocity;
        }
            
        // the difference between our tile and the next
        var tileVelocity : Vector3 = target - self.position;
        tileVelocity = tileVelocity / maxHopTime;
        
        // copy values into velocity
        velocity.x = tileVelocity.x;
        velocity.z = tileVelocity.z;
        
        if (resetY) {
            hopTime = 0.0;
        }
        
        // scale velocity by time leftover
        var hopTimeLeft : Float = maxHopTime - hopTime;
        
        hopTimeLeft /= maxHopTime;
        
        velocity.x /= hopTimeLeft;
        velocity.z /= hopTimeLeft;
    }
    
}
