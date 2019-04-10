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
    
    // Boolean to show if the user has swiped to the left
    public static var leftSwipe : Bool {
        get {
            return currentInputFrame.leftSwipe;
        }
    }
    
    // Boolean to show if the user has swiped to the right
    public static var rightSwipe : Bool {
        get {
            return currentInputFrame.rightSwipe;
        }
    }
    
    public static var upSwipe : Bool {
        get {
            return currentInputFrame.upSwipe;
        }
    }
    
    public static var touched : Bool {
        get {
            return currentInputFrame.touched;
        }
    }
    
    // Boolean to show if the user has swiped to the right
    public var rightSwipe : Bool = false;
    
    // The current input frame
    private static var currentInputFrame : InputFrame = InputFrame.init();
    
    // The input frame for the next update
    private static var storedInputFrame : InputFrame = InputFrame.init();
    
    // frame counter
    private static var frame : Int = 0;
    
    /**
     * Registers a single tap at a certain location
     */
    public static func registerSingleTap(at position:Vector3) {
        storedInputFrame.singleTap = true;
        
        storedInputFrame.singleTapData = InputData.init(startPosition: position, endPosition: position, touchID: 0);
    }
    
    /**
     * Registers a left swipe for the next frame
     */
    public static func registerLeftSwipe() {
        storedInputFrame.leftSwipe = true;
    }
    
    /**
     * Registers a right swipe for the next frame
     */
    public static func registerRightSwipe() {
        storedInputFrame.rightSwipe = true;
    }
    
    public static func registerUpSwipe() {
        storedInputFrame.upSwipe = true;
    }
    
    public static func registerTouch() {
        storedInputFrame.touched = true;
    }
    
    /**
     * Moves the stored input to the next frame
     */
    public static func nextFrame() {
        frame += 1;
        currentInputFrame = storedInputFrame;
        
        if (frame >= 4) {
            storedInputFrame = InputFrame.init();
            frame = 0;
        }
    }

    /**
     * Struct holding input info about the current frame
     */
    struct InputFrame {
        
        // Boolean to show if the user has tapped on the screen.
        public var singleTap : Bool = false;
        
        // Data about the single tap.
        public var singleTapData : InputData?;
        
        // Boolean to show if the user has swiped to the left
        public var leftSwipe : Bool = false;
        
        // Boolean to show if the user has swiped to the right
        public var rightSwipe : Bool = false;
        
        public var upSwipe : Bool = false;
        
        public var touched : Bool = false;
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
