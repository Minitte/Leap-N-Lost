//
//  Animation.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-17.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class TransformAnimation {
    
    // Original position
    var originalPosition : Vector3;
    
    // Original rotation
    var originalRotation : Vector3;
    
    // Original scale
    var originalScale : Vector3;
    
    // Current position
    var position : Vector3;
    
    // Current rotation
    var rotation : Vector3;
    
    // Current scale
    var scale : Vector3;
    
    // Is the animation currently playing?
    private var playing : Bool;
    
    // Keyframes of the animation to linearly transition into
    private var keyframes : [TransformKeyframe];
    
    // Index of the keyframe thats currently playing
    private var playingIndex : Int = 0;
    
    // Time elapsed for the current keyframe
    private var currentKeyFrameTime : Float = 0.0;
    
    /**
     * Default initalizer
     */
    init() {
        originalPosition = Vector3();
        originalRotation = Vector3();
        originalScale = Vector3();
        
        position = Vector3();
        rotation = Vector3();
        scale = Vector3();
        
        playing = false;
        
        keyframes = [TransformKeyframe]();
    }
    
    /**
     * Adds a keyframe inorder to the list of keyframes
     */
    public func addKeyframe(newKeyframe kf:TransformKeyframe) {
        keyframes.append(kf);
        
        // sort the keyframes by time
        keyframes.sort(by: {$0.atTime > $1.atTime});
    }
    
    /**
     * Plays the animation from the start
     */
    public func playFromStart() {
        playingIndex = 0;
        currentKeyFrameTime = 0.0;
        
        position = originalPosition;
        rotation = originalRotation;
        scale = originalScale;
        
        playing = true;
    }
    
    /**
     * Plays from the current position
     */
    public func playFromCurrent() {
        playing = true;
    }
    
    /**
     * Stops the animation
     */
    public func stop() {
        playing = false;
    }
    
    /**
     * Updates the keyframes
     */
    public func update(delta: Float) {
        if (!playing) {
            return;
        }
        
        // check if out of keyframes
        if (playingIndex >= keyframes.count) {
            playing = false;
            return;
        }
        
        let currentFrame : TransformKeyframe = keyframes[playingIndex];
        
        position = position + (currentFrame.position * delta);
        rotation = rotation + (currentFrame.rotation * delta);
        scale = scale + (currentFrame.scale * delta);
        
        currentKeyFrameTime += delta;
        
        if (currentKeyFrameTime > currentFrame.atTime) {
            playingIndex += 1;
        }
    }
}
