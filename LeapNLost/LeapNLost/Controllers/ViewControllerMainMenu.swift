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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        initAudio.setURL(fileName: "fluteUp", fileType: "wav");
        initAudio.play(loop: false);
    }
    
    /*@IBAction func testJSON(_ sender: Any) {
        var level = Level();
        let data = level.readLevel(withArea: 0, withLevel: 0);
        level = level.parseJSON(data: data);
        print(level.rows[0].type);
    }*/
    @IBAction func playButton(_ sender: Any) {
        buttonAudio.play(loop: false);
        AudioPlayers.shared.stop(index: 0);
        AudioPlayers.shared.set(index: 0, fileName: "Level1", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
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
