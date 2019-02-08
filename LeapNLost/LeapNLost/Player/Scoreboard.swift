//
//  Scoreboard.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Scoreboard : Codable {
    
    // Array of level and score
    var scores : [[LevelScoreboard]];
    
    init () {
        let numWorlds : Int = 4;
        let numLevelPerWorld : Int = 5;
    
        scores = Array(repeating: Array(repeating: LevelScoreboard.init(), count: numLevelPerWorld), count: numWorlds);
    }
    
    /**
     * Gets the scoreboard corresponding to the world-level
     */
    public func getLevelScoreboard(forWorld world:Int, forLevel level:Int) -> LevelScoreboard {
        return scores[world][level];
    }
}
