//
//  PlayerGameObject.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class PlayerGameObject : GameObject {
    
    // gravity acceralation vector
    private var gravity : Vector3 = Vector3.init(0, -9.81, 0);
    
    // leap forward velocity vector
    private var hopVelocity : Vector3 = Vector3.init();
    
    // The time it takes to complete a hop
    private var maxHopTime : Float;
    
    // velocity of the hop
    private var velocity : Vector3 = Vector3.init();
    
    // hopping flag to block other input
    var hopping : Bool = false;
    
    // preparing a hop
    var prepingHop : Bool = false;
    
    // Flag to represent if the player is dead
    var isDead : Bool;
    
    // Flag to represent if the game is over
    var isGameOver: Bool;

    // tile position based on x-z where z is forwards and origin is bottom center
    var tileRow : Int = 0;
    var tileCol : Int = 0;
    
    // The current target object to home into
    var targetObject : GameObject?;
    
    // The player's light that will be toggled on during night levels
    var nightLight : PointLight;
    
    // Reference to the current scene
    weak var currentScene : Scene?;

    // Animation for pre hop
    private var preHopAnimation : TransformAnimation = TransformAnimation();
    
    // animation for crushed death
    private var crushedDeathAnimation : TransformAnimation = TransformAnimation();
    private var playCrushedAnimation : Bool = false;
    
    private var drownDeathAnimation : TransformAnimation = TransformAnimation();
    private var playDrownAnimation : Bool = false;
    
    private var lastFloatableCheck : Bool = false;
    
    private let coinAudio = Audio();
    private let squishDieAudio = Audio();
    private let splashDieAudio = Audio();
    private let hopAudio = Audio();
    private let lilypadAudio = Audio();
  
    // Time to check hop time
    private var hopTime : Float = 0.0;

    /**
     * Inits the player object with a model
     */
    init(withModel model: Model, hopTime ht: Float = 0.25) {
        isDead = false;
        isGameOver = false;
        nightLight = PointLight(color: Vector3(1, 1, 1), ambientIntensity: 1, diffuseIntensity: 1, specularIntensity: 1, position: Vector3(), constant: 1.0, linear: 0.8, quadratic: 0.6);
        maxHopTime = ht;
        
        super.init(model);
        
        // Calculated from kinematic formula
        hopVelocity = Vector3(0, 0.5 * 9.81 * maxHopTime, 0);
        
        scale = scale * 1.5;
        rotation = Vector3.init(0, Float.pi, 0);
        self.collider = BoxCollider(halfLengths: Vector3.init(0.5, 0.5, 0.5));
        
        // animation setup
        preHopAnimation.originalScale = self.scale;
        
        // add keyframes
        preHopAnimation.addKeyframe(newKeyframe: TransformKeyframe(withScale: Vector3(0.2, -0.75, 0.2), atTime: 0.10));
        
        // crushed death animation
        crushedDeathAnimation.originalScale = self.scale;
        
        crushedDeathAnimation.addKeyframe(newKeyframe: TransformKeyframe(withScale: Vector3(0.5, -0.99, 0.5), atTime: 0.05));
        
        // drown death animation
        drownDeathAnimation.addKeyframe(newKeyframe: TransformKeyframe(withPosition: Vector3(0.0, -5.0, 0.0), atTime: 0.3));
        
        coinAudio.setURL(fileName: "coin", fileType: "wav");
        squishDieAudio.setURL(fileName: "squishDie", fileType: "wav");
        splashDieAudio.setURL(fileName: "splashDie", fileType: "wav");
        hopAudio.setURL(fileName: "boing", fileType: "wav");
        lilypadAudio.setURL(fileName: "splashLilypad", fileType: "wav");
    }
    
    /**
     * Overrided base update
     */
    override func update(delta: Float) {
        /*
         * INPUT SECTION
         */
        
        if (!hopping) {
            if (InputManager.touched) {
                if (!prepingHop) {
                    preHopAnimation.playFromStart();
                }
                
                prepingHop = true;
            }
            
            if (InputManager.singleTap || InputManager.upSwipe) {
                hopForward();
                stopPrepingHop();
            }
            
            if (InputManager.leftSwipe) {
                hopLeft();
            }
            
            if (InputManager.rightSwipe) {
                hopRight();
            }
        }
        
        /*
         * ANIMATION SECTION
         */
        
        if (prepingHop) {
            preHopAnimation.update(delta: delta);
            
            self.scale = preHopAnimation.scale;
        }
        
        if (playCrushedAnimation) {
            crushedDeathAnimation.update(delta: delta);
            
            self.scale = crushedDeathAnimation.scale;
        }
        
        if (playDrownAnimation) {
            drownDeathAnimation.update(delta: delta);
            
            self.position = drownDeathAnimation.position;
        }
        
        /*
         * POSITION SECTION
         */
        
        var topOffset : Vector3 = Vector3(0, 1.5, 0.5);
        
        if (targetObject!.type == "Lilypad" || targetObject!.type == "Log") {
            topOffset = Vector3(0, 0.5, 0);
        }
        
        // stick to the targetObject position
        if (!hopping && !isDead) {
            self.position = targetObject!.position + topOffset;
        }
        
        if (hopping) {
            hopAudio.play(loop: false);
            hopTime = hopTime + delta;
            
            var limitedDelta : Float = delta;
            
            if (hopTime >= maxHopTime) {
                limitedDelta = limitedDelta - (maxHopTime - hopTime);
            }
            
            // hop ratio time 0 - 1
            var hopTimeRatio : Float = hopTime / maxHopTime;
            
            // limit to 1 max
            if (hopTimeRatio > 1.0) {
                hopTimeRatio = 1.0;
            }
            
            // interpolate between target object and current
            let lerpPosition : Vector3 = Vector3.lerp(original: self.position, target: targetObject!.position + topOffset, time: hopTimeRatio);
            
            // change x and z
            position.x = lerpPosition.x;
            position.z = lerpPosition.z;
            
            // update position with velocity
            position = position + velocity * limitedDelta;
            
            // update velocity
            velocity = velocity + (gravity * limitedDelta);
            
            // last moment check
            if (!lastFloatableCheck && hopTimeRatio >= 0.9) {
                let floatable : GameObject? = findTargetFloatable(rowOffset: 1, colOffset: 0, searchDistance: 1.5);
                if (floatable != nil) {
                    targetObject = floatable;
                }
                lastFloatableCheck = true;
            }
            
            // landed
            if (hopTime >= maxHopTime) {
                positionToTilePosition();
                
                print("Player Landed on: r:\(tileRow) c:\(tileCol)");
                hopping = false;
            }
        }
        
        // Update night light position to current player position
        nightLight.position = position;
    }
    
    /**
     * hops forward
     */
    public func hopForward() {
        positionToTilePosition();
        let targetTile : Tile? = currentScene!.getTile(row: tileRow + 1, column: tileCol);
        
        if (targetTile == nil || isGameOver || isDead) {
            return;
        }
        
        var targetObjectToJumpTo : GameObject = targetTile!;
        
        // special case for water
        let closest : GameObject? = findTargetFloatable(rowOffset: 1, colOffset: 0, searchDistance: 3.0);
        
        if (closest != nil) {
            lilypadAudio.play(loop: false);
            targetObjectToJumpTo = closest!;
        }
        
        // jump to the target
        jumpToTarget(target: targetObjectToJumpTo);
        
        rotation = Vector3.init(0, Float.pi, 0);
        
        currentScene?.score += 1;
        
        /* WTF MODE
        for gameObject in (currentScene?.gameObjects)! {
            if (gameObject.type == "Boulder") {
                (gameObject as! Boulder).speed *= -1;
            }
            
            else if (gameObject.type == "Car") {
                (gameObject as! Car).speed *= -1;
            }
            
            else if (gameObject.type == "Log") {
                (gameObject as! Log).speed *= -1;
            }
            
            else if (gameObject.type == "Lilypad") {
                (gameObject as! Lilypad).speed *= -1;
            }
        }
         */
    }
    
    /**
     * hops left
     */
    public func hopLeft() {
        positionToTilePosition();
        let targetTile : Tile? = currentScene!.getTile(row: tileRow, column: tileCol - 1);
        
        if (targetTile == nil || isGameOver || isDead) {
            return;
        }
        
        jumpToTarget(target: targetTile!);
        
        rotation = Vector3.init(0, -Float.pi/2.0, 0);
    }
    
    /**
     * hops right
     */
    public func hopRight() {
        positionToTilePosition();
        let targetTile : Tile? = currentScene!.getTile(row: tileRow, column: tileCol + 1);
        
        if (targetTile == nil || isGameOver || isDead) {
            return;
        }
        
        jumpToTarget(target: targetTile!);
        
        rotation = Vector3.init(0, Float.pi/2.0, 0);
    }
    
    /**
     * Undos the prehop animation
     */
    private func stopPrepingHop() {
        prepingHop = false;
        preHopAnimation.stop();
        
        self.scale = preHopAnimation.originalScale;
    }
    
    
    /**
     * Sets the player's position directly on top of the given tile.
     * tile - the tile to teleport onto
     */
    func teleportToTarget(target : GameObject) {
        lastFloatableCheck = false;
        targetObject = target;
        self.position = target.position + Vector3(0, 2, 0);
        positionToTilePosition();
    }
    
    /**
     * Begin a basic hop to the tile
     */
    private func jumpToTarget(target : GameObject) {
        velocity = hopVelocity;
            
        targetObject = target;
        
        lastFloatableCheck = false;
        
        hopTime = 0.0;
        
        hopping = true;
    }
    
    /**
     * Estimates the tileposition based on world position
     */
    private func positionToTilePosition() {
//        tileCol = Int(position.x);
        tileCol = Int((self.position.x + Float(Level.tilesPerRow)) / 2.0);
        tileRow = -Int(position.z / 2.0 - 0.5);
    }
    
    /**
     * Picking up coins and removing it from the scene.
     */
    func pickup(object: GameObject) {
        //For loop checking list of all gameobject for this object.
        //Detect if yes.
        //Remove from list.
        let index = currentScene!.gameObjects.firstIndex(of: object)!;
        currentScene!.gameObjects.remove(at: index);
        
        //Remove the collider in the collision dictionairy.
        if object is Coin {
            coinAudio.play(loop: false);
            let rowIndex : Int = (object as! Coin).row;
            
            currentScene!.collisionDictionary[rowIndex]!.remove(at: currentScene!.collisionDictionary[rowIndex]!.firstIndex(of: object)!);
        }else if object is MemoryFragment {
            let rowIndex : Int = (object as! MemoryFragment).row;
            currentScene!.collisionDictionary[rowIndex]!.remove(at: currentScene!.collisionDictionary[rowIndex]!.firstIndex(of: object)!);
        }
        
    }
    
    /**
     * Plays the death animation
     */
    func runCrushedAnimation() {
        if (isDead) {
            return;
        }
        
        squishDieAudio.play(loop: false);
        prepingHop = false;
        playCrushedAnimation = true;
        scale = crushedDeathAnimation.originalScale;
        crushedDeathAnimation.playFromStart();
    }
    
    /**
     * Plays the drown animation
     */
    func runDrownAnimation() {
        if (isDead) {
            return;
        }
        
        splashDieAudio.play(loop: false);
        drownDeathAnimation.originalPosition = position;
        
        prepingHop = false;
        playDrownAnimation = true;
        drownDeathAnimation.playFromStart();
    }
    
    /**
     * Resets this player to default settings and position.
     */
    func reset() {
        // Reset flags
        isDead = false;
        playCrushedAnimation = false;
        playDrownAnimation = false;
        
        // Reset scale
        scale = crushedDeathAnimation.originalScale;
        
        // Teleport back to the start of the level
        teleportToTarget(target: currentScene!.getTile(row: 0, column: Level.tilesPerRow / 2)!);
    }
  
    /**
     * Searches for a floatable at the tile at the tile position player + offset
     */
    private func findTargetFloatable(rowOffset:Int, colOffset:Int, searchDistance:Float) -> GameObject? {
        let targetTile : Tile? = currentScene!.getTile(row: tileRow + rowOffset, column: tileCol + colOffset);
        let waterObjects : [GameObject] = currentScene!.collisionDictionary[targetTile!.row]!;
        
        // closest distance between the frog(player) and the lily pad
        var closestDist : Float = 1000000.0;
        var closest : GameObject?;
        
        // find closest
        for gameObject in waterObjects {
            if (gameObject.type != "Lilypad" && gameObject.type != "Log") {
                continue;
            }
            
            let dist : Float = (gameObject.position - self.position).magnitude();
            
            if (dist < searchDistance && dist < closestDist) {
                closestDist = dist;
                closest = gameObject;
            }
        }
        
        // check if there was a closest lilypad
        return closest;
    }
   
}
