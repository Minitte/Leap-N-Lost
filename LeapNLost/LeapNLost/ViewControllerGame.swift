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
    
    private var gameEngine : GameEngine?;
    private var glkView : GLKView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupGL();
    }
    
    /**
     * Sets up the openGL engine.
     */
    func setupGL() {
        glkView = self.view as? GLKView
        glkView!.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(glkView!.context)
        delegate = self
        gameEngine = GameEngine(self.view as! GLKView);
    
        
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        gameEngine!.update()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        gameEngine!.render(rect)
    }
}
