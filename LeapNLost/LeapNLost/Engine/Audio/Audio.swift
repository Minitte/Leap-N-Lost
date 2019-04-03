//
//  Audio.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-11.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import AVFoundation

class Audio {
    
    private var player: AVAudioPlayer?;
    private var url: URL;
    public var fileName: String;
    var volume : Float;
    
    // Initialize variables
    internal init() {
        url = URL(fileURLWithPath: "");
        volume = 1.0;
        fileName = "";
    }
    
    // Initialize variables
    internal init(fileName: String, fileType: String) {
        url = Bundle.main.url(forResource: fileName, withExtension: fileType, subdirectory: "Audio")!;
        volume = 1.0;
        self.fileName = fileName;
    }
    
    // Initialize with values
    internal init(fileName: String, fileType: String, gameVolume: Float){
        url = Bundle.main.url(forResource: fileName, withExtension: fileType, subdirectory: "Audio")!;
        volume = gameVolume;
        self.fileName = fileName;
    }
    
    
    // Plays a sound (mp3) i.e. playSound("MainTheme","mp3", true)
    func play(loop: Bool) {
        do {
            player = try AVAudioPlayer(contentsOf: url);
            guard let player = player else { return }
            player.volume = volume;
            player.prepareToPlay();
            player.play();
            
            if(loop){
                player.numberOfLoops = -1;
            }
            
        } catch let error as NSError {
            print(error.description);
        }
    }
    
    // Set player volume
    func setVolume(volume: Float){
        self.volume = volume;
        if #available(iOS 10.0, *) {
            player?.setVolume(volume, fadeDuration: 1)
        } else {
            // Fallback on earlier versions
            player?.volume = volume;
        };
    }
    
    // Stops the player and resets audio clips to start
    func stop(){
        guard let player = player else { return }
        player.stop();
        player.currentTime = 0;
    }
    
    func setURL(fileName: String, fileType: String){
        url = Bundle.main.url(forResource: fileName, withExtension: fileType, subdirectory: "Audio")!;
        self.fileName = fileName;
    }
}

/** Class of audio players for global access.
 *  Use only for music and ambience!
 *  If you need to play a sound effect a lot in a view,
 *  make an audio source with let audioSource = Audio();
 */
class AudioPlayers{
    // Singleton
    static let shared: AudioPlayers = AudioPlayers();
    var players = [Audio(fileName: "click", fileType: "wav"), Audio(fileName: "click", fileType: "wav")];
    
    // Adds a new audio player
    func add(){
        players.append(Audio(fileName: "click", fileType: "wav"));
    }
    
    // Removes the last audio player
    func remove(){
        players.removeLast();
    }
    
    // Sets the audio file of the player at index
    func set(index: Int, fileName: String, fileType: String){
        players[index].setURL(fileName: fileName, fileType: fileType);
    }
    
    // Plays audio player at index, loop?
    func play(index: Int, loop: Bool){
        players[index].play(loop: loop);
    }
    
    // Stops audio player at index, loop?
    func stop(index: Int){
        players[index].stop();
    }
    
    // Stops all audio players
    func stopAll(){
        for player in players{
            player.stop();
        }
    }
    
    // Returns number of players
    func size() -> Int {
        return players.count;
    }
}
