//
//  CameraFollowTarget.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-25.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class CameraFollowTarget : Camera {
    
    // Gameobject for the camera to follow
    public var target : GameObject?;
    
    // camera offset from target
    public var offset : Vector3;
    
    /**
     * Ini a camera that follows a target if any
     */
    init(cameraOffset offset:Vector3, trackTarget target:GameObject?) {
        self.offset = offset;
        self.target = target;
        
        super.init();
    }
    
    /**
     * updates the camera's position with the target and offset
     */
    public func updatePosition() {
        if (target == nil) {
            return;
        }
        
        var newPos : Vector3 = target!.position * -1;
        
        newPos = newPos + offset;
        
        setPosition(xPosition: newPos.x, yPosition: offset.y, zPosition: newPos.z);
    }
    
    
}
