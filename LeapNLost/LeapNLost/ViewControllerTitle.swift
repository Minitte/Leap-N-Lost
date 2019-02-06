//
//  ViewController.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-01-31.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerTitle: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Animates Fade In and Fade Out on button
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse, .repeat, .allowUserInteraction
            ], animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)    }
    
}

