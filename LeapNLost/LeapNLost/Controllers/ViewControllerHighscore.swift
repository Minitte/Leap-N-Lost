//
//  ViewControllerHighscore.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-04-03.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerHighscore: UIViewController{
    var profile = PlayerProfile.init();
    var buttonAudio = Audio();
    @IBOutlet weak var score: UILabel!
    var scoreNum: Int = 0;
    
    override func viewDidLoad() {
        buttonAudio.setVolume(volume: AudioPlayers.shared.volumeSFX);
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        for currArea in profile.scoreboard.scores{
            for currLevel in currArea{
                for num in currLevel.scoreArray{
                    scoreNum += num;
                    score.text = String(scoreNum);
                }
            }
        }
    }
    @IBAction func backToMainMenu(_ sender: Any) {
        buttonAudio.play(loop: false);
        self.presentingViewController!.dismiss(animated: true, completion: nil);
    }
}
