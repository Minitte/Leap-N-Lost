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
    
    var renderer: Renderer = Renderer()
    var ozma: GLKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = self
        
        renderer = Renderer()
        var viewz = self.view as? GLKView
        
        renderer.setup(self.view as? GLKView)
        
        renderer.loadModels()
        
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        renderer.update()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        renderer.draw(rect)
    }
}
