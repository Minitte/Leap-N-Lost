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

    var max : Vector3;
    var min : Vector3;
    
    func CheckCollision(first: GameObject, second: GameObject) -> Bool {
        
        //Checking if the x axis overlaps.
        let collisionX : Bool = (first.position.x + (first.collider as! BoxCollider).max.x
                                 >= second.position.x - (second.collider as! BoxCollider).min.x)
                                 &&
                                 (second.position.x + (second.collider as! BoxCollider).max.x
                                 >= first.position.x - (first.collider as! BoxCollider).min.x);
        
        //Checking if the y axis overlaps.
        let collisionY : Bool = (first.position.y + (first.collider as! BoxCollider).max.y
                                >= second.position.y - (second.collider as! BoxCollider).min.y)
                                &&
                                (second.position.y + (second.collider as! BoxCollider).max.y
                                >= first.position.y - (first.collider as! BoxCollider).min.y);
        
        //Checking if the z axis overlaps.
        let collisionZ : Bool = (first.position.z + (first.collider as! BoxCollider).max.z
                                >= second.position.z - (second.collider as! BoxCollider).min.z)
                                &&
                                (second.position.z + (second.collider as! BoxCollider).max.z
                                >= first.position.z - (first.collider as! BoxCollider).min.z);
        
        //return booleans.
        return collisionX && collisionY && collisionZ;
        
    }
    
    init() {
        max = Vector3(1,1,1);
        min = Vector3(-1,-1,-1);
    }
    
    init(max: Vector3, min: Vector3) {
        self.max = max;
        self.min = min;
    }
}
