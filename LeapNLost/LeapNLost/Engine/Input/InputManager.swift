//
//  Input.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class InputManager {
    
    // Boolean to show if the user has tapped on the screen.
    public static var singleTap : Bool {
        get {
            return currentInputFrame.singleTap;
        }
    }
    
    // The current input frame
    private static var currentInputFrame : InputFrame = InputFrame.init();
    
    // The input frame for the next update
    private static var storedInputFrame : InputFrame = InputFrame.init();
    
//    init() {
//        currentInputFrame = InputFrame.init();
//        
//        storedInputFrame = InputFrame.init();
//    }
    
    /**
     * Registers a single tap at a certain location
     */
    public static func registerSingleTap(at position:Vector3) {
        storedInputFrame.singleTap = true;
        
        storedInputFrame.singleTapData = InputData.init(startPosition: position, endPosition: position, touchID: 0);
    }
    
    /**
     * Moves the stored input to the next frame
     */
    public static func nextFrame() {
        currentInputFrame = storedInputFrame;
        
        storedInputFrame = InputFrame.init();
    }

    /**
     * Struct holding input info about the current frame
     */
    struct InputFrame {
        
        // Boolean to show if the user has tapped on the screen.
        public var singleTap : Bool = false;
        
        // Data about the single tap.
        public var singleTapData : InputData?;
    }
    
    /**
     * struct holding info about an input
     */
    struct InputData {
        
        // start position of input.
        public var startPosition : Vector3;
        
        // start position of input.
        public var endPosition : Vector3;
        
        // The id of the touch. eg. first touch, 2nd touch, etc
        public var touchID : Int;
        
    }
    
}
