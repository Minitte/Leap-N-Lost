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
    var area: Int = 1;
    var level: Int = 1;
    var profile = PlayerProfile.init();
    
    // Level buttons
    @IBOutlet weak var level11Button: UIButton!
    @IBOutlet weak var level12Button: UIButton!
    @IBOutlet weak var level13Button: UIButton!
    @IBOutlet weak var level14Button: UIButton!
    @IBOutlet weak var level15Button: UIButton!
    @IBOutlet weak var nextAreaButton: UIButton!
    @IBOutlet weak var previousAreaButton: UIButton!
    
    @IBOutlet weak var currentAnimalTextView: UITextView!
    
    var levelButtons: [UIButton] = [];
    override func viewDidLoad() {
        levelButtons = [level11Button, level12Button, level13Button, level14Button, level15Button];
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        initAudio.setURL(fileName: "fluteUp", fileType: "wav");
        initAudio.play(loop: false);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(PlayerProfile.profileExists()){
            NSLog("Loading save...");
            profile = PlayerProfile.loadFromFile()!;
        } else{
            NSLog("No save file. Making default save...");
            profile.saveToFile();
        }
        if(profile.reachedArea > area){
            nextAreaButton.isEnabled = true;
            nextAreaButton.alpha = 1.0;
        } else{
            nextAreaButton.isEnabled = false;
            nextAreaButton.alpha = 0.5;
        }
        for(index, button) in levelButtons.enumerated(){
            if(profile.reachedLevel >= index+1){
                button.alpha = 1.0;
                button.isEnabled = true;
            }else{
                button.alpha = 0.5;
                button.isEnabled = false;
            }
        }
        if(area > 1){
            previousAreaButton.isHidden = false;
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
        level = 1;
    }
    
    @IBAction func level1_2(_ sender: Any) {
        buttonAudio.play(loop: false);
        AudioPlayers.shared.stop(index: 0);
        AudioPlayers.shared.set(index: 0, fileName: "Level1", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
        level = 2;
        performSegue(withIdentifier: "levelSelected", sender: self)
    }
    
    // For next area
    @IBAction func nextArea(_ sender: Any) {
        area += 1;
        for(index, button) in levelButtons.enumerated(){
            if(profile.reachedLevel >= index+1){
                if(index+1 == 5){
                    button.setTitle("Level " + String(area) + "-" + String(index+1) + "\u{1F480}", for: .normal);
                }else{
                    button.setTitle("Level " + String(area) + "-" + String(index+1), for: .normal);
                }
                button.alpha = 1.0;
                button.isEnabled = true;
            }else{
                button.alpha = 0.5;
                button.isEnabled = false;
            }
        }
        nextAreaButton.isEnabled = false;
        nextAreaButton.alpha = 0.5;
        
    }
    
    @IBAction func previousArea(_ sender: Any) {
        area -= 1;
        for(index, button) in levelButtons.enumerated(){
            if(index+1 == 5){
                button.setTitle("Level " + String(area) + "-" + String(index+1) + "\u{1F480}", for: .normal);
            }else{
                button.setTitle("Level " + String(area) + "-" + String(index+1), for: .normal);
            }
            button.alpha = 1.0;
            button.isEnabled = true;
        }
        previousAreaButton.isHidden = true;
    }
    
    //
    // Animal Selection
    //
    
    @IBAction func onPrevAnimalBtnPressed() {
        currentAnimalTextView.text = "PREV";
    }
    
    @IBAction func onNextAnimalBtnPressed() {
        currentAnimalTextView.text = "NEXT";
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
