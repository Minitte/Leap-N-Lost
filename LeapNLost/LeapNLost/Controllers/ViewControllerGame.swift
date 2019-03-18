//
//  ViewControllerGame.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-04.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit
import Swift

class ViewControllerGame : GLKViewController, GLKViewControllerDelegate {
    
    // The openGL game engine.
    private var gameEngine : GameEngine?;
    
    // This view as a GLKView
    private var glkView : GLKView?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupGL();
    }
    
    /**
     * Sets up the openGL engine.
     */
    func setupGL() {
        // Set the context
        glkView = self.view as? GLKView;
        glkView!.context = EAGLContext(api: .openGLES2)!;
        EAGLContext.setCurrent(glkView!.context);
        delegate = self;
        
        // Enable depth buffer
        glkView!.drawableDepthFormat = GLKViewDrawableDepthFormat.format24;
        glEnable(GLbitfield(GL_DEPTH_TEST));
        
        // Start the engine
        gameEngine = GameEngine(self.view as! GLKView);
    }
    
    /**
     * Sends us back to the main menu.
     */
    func dismissScene() {
        // Dismiss this scene
        navigationController?.popViewController(animated: true);
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func OnTapGesture(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            let tapPos : CGPoint = sender.location(in: self.view);
            let tapPosVec : Vector3 = Vector3.init(Float(tapPos.x), Float(tapPos.y), 0);
            InputManager.registerSingleTap(at: tapPosVec);
        }
    }

    @IBAction func OnSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            InputManager.registerRightSwipe();
        }
    }
    
    @IBAction func OnSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            InputManager.registerLeftSwipe();
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputManager.registerTouch()
    }
    
    /**
     * Updates the game.
     */
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        InputManager.nextFrame();
        gameEngine?.update();
        
        // Check if the player is dead
        if ((gameEngine?.currentScene.player.isDead)!) {
            dismissScene();
        }
    }
    
    /**
     * Renders the game.
     */
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        gameEngine?.render(rect);
    }
    
    deinit {
        print("ViewControllerGame deinit");
        gameEngine = nil;
        glkView = nil;
        EAGLContext.setCurrent(nil);
    }
}
