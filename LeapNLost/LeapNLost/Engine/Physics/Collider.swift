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
    // Function used to return a bool to determine if collision occurs.
    func CheckCollision(first: GameObject, second: GameObject) -> Bool;
}
