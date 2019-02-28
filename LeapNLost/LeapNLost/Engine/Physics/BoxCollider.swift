//
//  BoxCollider.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-02-23.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

//Box collider used for collision and implements the Collider protocol.
class BoxCollider : Collider {

    var halfLengths : Vector3;
    
    func CheckCollision(first: GameObject, second: GameObject) -> Bool {
        
        //Checking if the x axis overlaps.
        let collisionX : Bool = (first.position.x + (first.collider as! BoxCollider).halfLengths.x
                                 >= second.position.x - (second.collider as! BoxCollider).halfLengths.x)
                                 &&
                                 (second.position.x + (second.collider as! BoxCollider).halfLengths.x
                                 >= first.position.x - (first.collider as! BoxCollider).halfLengths.x);
        
        //Checking if the y axis overlaps.
        let collisionY : Bool = (first.position.y + (first.collider as! BoxCollider).halfLengths.y
                                >= second.position.y - (second.collider as! BoxCollider).halfLengths.y)
                                &&
                                (second.position.y + (second.collider as! BoxCollider).halfLengths.y
                                >= first.position.y - (first.collider as! BoxCollider).halfLengths.y);
        
        //Checking if the z axis overlaps.
        let collisionZ : Bool = (first.position.z + (first.collider as! BoxCollider).halfLengths.z
                                >= second.position.z - (second.collider as! BoxCollider).halfLengths.z)
                                &&
                                (second.position.z + (second.collider as! BoxCollider).halfLengths.z
                                >= first.position.z - (first.collider as! BoxCollider).halfLengths.z);
        
        //return booleans.
        return collisionX && collisionY && collisionZ;
        
    }
    
    init() {
        halfLengths = Vector3(0.5,0.5,0.5);
    
    }
    
    init(halfLengths: Vector3) {
        self.halfLengths = halfLengths;
    }
}
