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
    var profile = PlayerProfile.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Loading player profile
        if(PlayerProfile.profileExists()){
            NSLog("Loading save...");
            
            let pp : PlayerProfile? = PlayerProfile.loadFromFile();
            
            if (pp != nil) {
                NSLog("Successfully loaded a save file!");
                profile = pp!;
            } else {
                NSLog("Failed to load a save file! Making default save...");
                profile = PlayerProfile();
                profile.saveToFile();
            }
            
        } else{
            NSLog("No save file. Making default save...");
            profile.saveToFile();
        }
        
        // Play main theme
        AudioPlayers.shared.volumeSFX = profile.volumeSFX;
        AudioPlayers.shared.volumeBGM = profile.volumeBGM;
        AudioPlayers.shared.players[0].volume = profile.volumeBGM;
        AudioPlayers.shared.set(index: 0, fileName: "MainTheme", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
        
        
        //Animates Fade In and Fade Out on button
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse, .repeat, .allowUserInteraction
            ], animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
    }
    
    
    
}

