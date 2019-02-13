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
        
        // Play main theme
        AudioPlayers.shared.set(index: 0, fileName: "MainTheme", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
        
        //Animates Fade In and Fade Out on button
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse, .repeat, .allowUserInteraction
            ], animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
        
    }
    
}

