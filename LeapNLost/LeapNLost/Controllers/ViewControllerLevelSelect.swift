//
//  ViewControllerLevelSelect.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-03-17.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerLevelSelect: UIViewController {
    let buttonAudio = Audio();
    let initAudio = Audio();
    var area: Int = 0;
    var level: Int = 0;
    var profile = PlayerProfile.init();
    
    // Level buttons
    @IBOutlet weak var level11Button: UIButton!
    @IBOutlet weak var level12Button: UIButton!
    @IBOutlet weak var level13Button: UIButton!
    @IBOutlet weak var level14Button: UIButton!
    @IBOutlet weak var level15Button: UIButton!
    var levelButtons: [UIButton] = [];
    override func viewDidLoad() {
        levelButtons = [level11Button, level12Button, level13Button, level14Button, level15Button];
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        initAudio.setURL(fileName: "fluteUp", fileType: "wav");
        initAudio.play(loop: false);
        for(index, button) in levelButtons.enumerated(){
            if(profile.reachedLevel >= index+1){
                button.alpha = 1.0;
                button.isEnabled = true;
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(PlayerProfile.profileExists()){
            NSLog("Loading save...");
            profile = PlayerProfile.loadFromFile()!;
        } else{
            NSLog("No save file. Making default save...");
            profile.saveToFile();
        }
        for(index, button) in levelButtons.enumerated(){
            if(profile.reachedLevel >= index+1){
                button.alpha = 1.0;
                button.isEnabled = true;
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewControllerGame
        {
            let vc = segue.destination as? ViewControllerGame
            vc?.area = area;
            vc?.level = level;
            vc?.profile = profile;
        }
        
    }

    
    @IBAction func level1_1(_ sender: Any) {
        buttonAudio.play(loop: false);
        AudioPlayers.shared.stop(index: 0);
        AudioPlayers.shared.set(index: 0, fileName: "Level1", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
        area = 1;
        level = 1;
    }
    
    @IBAction func level1_2(_ sender: Any) {
        buttonAudio.play(loop: false);
        AudioPlayers.shared.stop(index: 0);
        AudioPlayers.shared.set(index: 0, fileName: "Level1", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
        area = 1;
        level = 2;
        performSegue(withIdentifier: "levelSelected", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
