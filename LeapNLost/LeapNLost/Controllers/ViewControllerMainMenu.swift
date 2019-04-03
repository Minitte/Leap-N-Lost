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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        initAudio.volume = profile.volumeSFX;
        buttonAudio.volume = profile.volumeSFX;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is ViewControllerLevelSelect{
            let vc = segue.destination as? ViewControllerLevelSelect
            vc?.profile = profile;
        }
        
        if segue.destination is ViewControllerSettings{
            let vc = segue.destination as? ViewControllerSettings
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
