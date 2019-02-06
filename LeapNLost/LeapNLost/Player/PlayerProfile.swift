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
}
