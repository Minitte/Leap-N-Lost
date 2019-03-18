//
//  ViewControllerMainMenu.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-01-31.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerMainMenu: UIViewController {
    let buttonAudio = Audio();
    let initAudio = Audio();
    var profile = PlayerProfile.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        initAudio.setURL(fileName: "fluteUp", fileType: "wav");
        initAudio.play(loop: false);
        
        if(PlayerProfile.profileExists()){
            NSLog("Loading save...");
            profile = PlayerProfile.loadFromFile()!;
        } else{
            NSLog("No save file. Making default save...");
            profile.saveToFile();
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewControllerLevelSelect
        {
            let vc = segue.destination as? ViewControllerLevelSelect
            vc?.profile = profile;
        }
    }
    
    /*@IBAction func testJSON(_ sender: Any) {
        var level = Level();
        let data = level.readLevel(withArea: 0, withLevel: 0);
        level = level.parseJSON(data: data);
        print(level.rows[0].type);
    }*/
    @IBAction func playButton(_ sender: Any) {
        buttonAudio.play(loop: false);
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        buttonAudio.play(loop: false);
    }
    
    @IBAction func highScoreButton(_ sender: Any) {
        buttonAudio.play(loop: false);
    }
    
    // Exits app when Exit button is pressed
    @IBAction func exitApp(_ sender: Any) {
        buttonAudio.play(loop: false);
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
}
