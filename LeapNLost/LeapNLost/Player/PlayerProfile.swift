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
    
    // scoreboard object for the player
    var scoreboard : Scoreboard;
    
    // animallist object for the player
    var animalList : AnimalList;
    
    /**
     * Initalization of a player profile where all the values are zero
     */
    init () {
        coins = 0;
        
        // For debug purposes ***
        reachedArea = 4;
        reachedLevel = 5;
        // ***
        
        lastArea = 0;
        lastLevel = 0;
        scoreboard = Scoreboard.init();
        animalList = AnimalList();
    }
    
    /**
     * Initalization of a player profile where the values are given
     */
    init (coinCount c:Int, reachedArea ra:Int, reachedLevel rl:Int, lastArea la:Int, lastLevel ll:Int, scoreboard sb:Scoreboard, animalList al:AnimalList) {
        coins = c;
        reachedArea = ra;
        reachedLevel = rl;
        lastArea = la;
        lastLevel = ll;
        scoreboard = sb;
        animalList = al;
    }
    
    /**
     * Writes the save to file
     */
    public func saveToFile() {
        
        var payload : Data?;
        
        // try to encode the player object
        do {
            payload = try JSONEncoder().encode(self);
        } catch {
            NSLog("Failed to encode player profile");
        }
        
        let payloadStr : String! = String(data: payload!, encoding: .utf8)!;
        
        //this is the file. we will write to and read from it
        let file = "playerprofile0.sav";
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // file location
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
                // text of the json file
                let text = try String(contentsOf: fileURL, encoding: .utf8);
                
                // convert to json data
                let profileData : Data? = text.data(using: .utf8);
                
                // check if success
                if (profileData == nil) {
                    NSLog("Error reading a player profile!");
                }
                
                // decode json
                let loadedProfile : PlayerProfile = try JSONDecoder().decode(PlayerProfile.self, from: profileData!);
                
                return loadedProfile;
                
            } catch {
                NSLog("Error reading a player profile!");
            }
        }
        
        return nil;
    }
    
    // Checks if profile exists
    public static func profileExists() -> Bool{
        //this is the file. we will write to and read from it
        let file = "playerprofile0.sav";
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file);
            
            //reading
            do {
                // text of the json file
                let text = try String(contentsOf: fileURL, encoding: .utf8);
                
                // convert to json data
                let profileData : Data? = text.data(using: .utf8);
                
                // check if success
                if (profileData == nil) {
                    NSLog("No player profile!");
                    return false;
                }
                
                
            } catch {
                NSLog("Error reading a player profile!");
                return false;
            }
        }
        return true;
        
    }
}
