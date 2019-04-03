//
//  ViewControllerSettings.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-04-03.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerSettings: UIViewController {
    var profile = PlayerProfile.init();
    var buttonAudio = Audio();
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var soundSlider: UISlider!
    
    
    override func viewDidLoad() {
        musicSlider.value = profile.volumeBGM;
        soundSlider.value = profile.volumeSFX;
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        buttonAudio.setVolume(volume: profile.volumeSFX);
    }
    
    @IBAction func backToMainMenu(_ sender: Any) {
        buttonAudio.play(loop: false);
        NSLog("Saving settings...");
        profile.saveToFile();
        self.presentingViewController!.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func deletePlayerProfile(_ sender: Any){
        buttonAudio.play(loop: false);
        NSLog("Making new player profile...");
        profile = PlayerProfile.init();
        profile.volumeBGM = musicSlider.value;
        profile.volumeSFX = soundSlider.value;
    }
    
    @IBAction func musicVolumeChange(_ sender: Any) {
        profile.volumeBGM = musicSlider.value;
        AudioPlayers.shared.players[0].setVolume(volume: musicSlider.value);
        buttonAudio.play(loop: false);
        AudioPlayers.shared.volumeBGM = musicSlider.value;
    }
    
    @IBAction func soundVolumeChange(_ sender: Any) {
        profile.volumeSFX = soundSlider.value;
        buttonAudio.setVolume(volume: profile.volumeSFX);
        buttonAudio.play(loop: false);
        AudioPlayers.shared.volumeSFX = soundSlider.value;
    }
}
