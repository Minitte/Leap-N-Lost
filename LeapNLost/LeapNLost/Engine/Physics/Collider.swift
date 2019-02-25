//
//  Collider.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-02-23.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

protocol Collider {
    var scale : Vector3 { get set };
    
    func CheckCollision(first: GameObject, second: GameObject) -> Bool;
}
