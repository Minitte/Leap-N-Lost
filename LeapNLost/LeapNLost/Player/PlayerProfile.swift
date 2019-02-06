//
//  PlayerProfile.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class PlayerProfile : Codable {
    
    // Player's total coin count.
    var coins : Int;
    
    // Player's highest reached area or world
    var reachedArea : Int;
    
    // Player's highest reached level or level progression.
    var reachedLevel : Int;
    
    // Player's last area played
    var lastArea : Int;
    
    // Player's last level that they played
    var lastLevel : Int;
    
    var scoreboard : Scoreboard;
    
    /**
     * Initalization of a player profile where all the values are zero
     */
    init () {
        coins = 0;
        reachedArea = 0;
        reachedLevel = 0;
        lastArea = 0;
        lastLevel = 0;
        scoreboard = Scoreboard.init();
    }
    
    /**
     * Initalization of a player profile where the values are given
     */
    init (coinCount c:Int, reachedArea ra:Int, reachedLevel rl:Int, lastArea la:Int, lastLevel ll:Int, scoreboard sb:Scoreboard) {
        coins = c;
        reachedArea = ra;
        reachedLevel = rl;
        lastArea = la;
        lastLevel = ll;
        scoreboard = sb;
    }
    
    /**
     * Writes the save to file
     */
    public func saveToFile() {
        
        var payload : Data?;
        
        do {
            payload = try JSONEncoder().encode(self);
        } catch {
            NSLog("Failed to encode player profile");
        }
        
        let payloadStr : String! = String(data: payload!, encoding: .utf8)!;
        
        //this is the file. we will write to and read from it
        let file = "playerprofile0.sav";
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file);
            
            //writing
            do {
                try payloadStr.write(to: fileURL, atomically: false, encoding: .utf8);
            } catch {
                /* error handling here */
                
            }
        }
    }
    
    /**
     * Tries to load a Player Profile from local storage
     * If loading a profile is successful, it is returned
     */
    public static func loadFromFile() -> PlayerProfile? {
        
        //this is the file. we will write to and read from it
        let file = "playerprofile0.sav";
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file);
            
            //reading
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8);
                
                let profileData : Data? = text.data(using: .utf8);
                
                if (profileData == nil) {
                    NSLog("Error reading a player profile!");
                }
                
                let loadedProfile : PlayerProfile = try JSONDecoder().decode(PlayerProfile.self, from: profileData!);
                
                return loadedProfile;
                
            } catch {
                NSLog("Error reading a player profile!");
            }
        }
        
        return nil;
    }
}
