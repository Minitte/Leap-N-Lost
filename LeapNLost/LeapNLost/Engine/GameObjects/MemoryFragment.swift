//
//  MemoryFragment.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-03-21.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class MemoryFragment : GameObject {
    // Game Object velocity
    var velocity : Vector3;
    var row : Int;
    init(position: Vector3, row : Int) {
        self.velocity = Vector3.init(0,0.3,0);
        self.row = row;
        super.init(ModelCacheManager.loadModel(withMeshName: "Prism", withTextureName: "memoryfragment.jpg", saveToCache: true)!);
        
        self.scale = Vector3(0.7, 0.7, 0.7);
        self.position = position;
        self.collider = BoxCollider(halfLengths: Vector3(1.25,1.25,1.25));
        self.rotation.x = -0.3;
        self.type = "MemoryFragment";
    }
    
    override func update(delta: Float) {
        rotation = rotation + self.velocity * delta;
        
        // If roation in radians goes over 2 PI set rotation.z to 0
        if(Double(exactly:self.rotation.z)! > (2.0 * Double.pi)) {
            rotation.z = 0;
        }
    }
}
