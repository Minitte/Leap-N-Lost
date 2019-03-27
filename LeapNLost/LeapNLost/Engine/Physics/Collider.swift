//
//  Collider.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-02-23.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

//Protocol used to represents colliders.
protocol Collider {
    var model : Model? { get set };
    
    // Can this collider kill the player?
    var lethal : Bool? { get set };
    
    // Function used to return a bool to determine if collision occurs.
    func CheckCollision(first: GameObject, second: GameObject) -> Bool;
}
