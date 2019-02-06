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
        super.viewDidLoad()
        setupGL();
    }
    
    /**
     * Sets up the openGL engine.
     */
    func setupGL() {
        // Set the context
        glkView = self.view as? GLKView
        glkView!.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(glkView!.context)
        delegate = self
        
        // Start the engine
        gameEngine = GameEngine(self.view as! GLKView);
    }
    
    /**
     * Updates the game.
     */
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        gameEngine!.update()
    }
    
    /**
     * Renders the game.
     */
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        gameEngine!.render(rect)
    }
}
