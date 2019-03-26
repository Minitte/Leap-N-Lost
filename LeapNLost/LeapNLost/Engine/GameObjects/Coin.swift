//
//  Coin.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-03-21.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Coin : GameObject {
    // Coin's velocity
    var velocity : Vector3;
    var row : Int;
    init(position: Vector3, row: Int) {
        self.velocity = Vector3.init(0, 0, 1.5);
        self.row = row;
        super.init(ModelCacheManager.loadModel(withMeshName: "coin", withTextureName: "coin.jpg")!);
        
        self.scale = Vector3(0.5, 0.5, 0.5);
        self.position = position;
        self.collider = BoxCollider(halfLengths: Vector3(1, 1, 1));
        self.rotation = Vector3(Float(Double.pi * 0.5), 0, 0);
        self.type = "Coin";
       
    }
    
    override func update(delta: Float) {
        rotation = rotation + self.velocity * delta;
        
        //If rotation goes over 2 PI set rotation.z to 0
        if(Double(exactly:self.rotation.z)! > (2.0 * Double.pi)) {
            rotation.z = 0;
           
            
        }
    }
    /**
     * Destroying coins.
     **/
    func destroy() {
        
    }
}
