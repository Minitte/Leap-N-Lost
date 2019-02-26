//
//  CameraFollowTarget.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-25.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class CameraFollowTarget : Camera {
    
    // camera offset from target
    public var offset : Vector3;
    
    /**
     * Ini a camera that follows a target if any
     */
    init(cameraOffset offset:Vector3) {
        self.offset = offset;
        
        super.init();
    }
    
    /**
     * updates the camera's position with a target (given) and offset (already set)
     */
    public func updatePosition(trackingTarget target:GameObject) {
        var newPos : Vector3 = target.position + offset;
        
        setPosition(xPosition: newPos.x, yPosition: newPos.y, zPosition: newPos.z);
    }
    
    
}
