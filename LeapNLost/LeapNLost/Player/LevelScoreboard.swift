//
//  LevelScoreboard.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class LevelScoreboard : Codable {
    
    // list of top scores
    var scoreArray : Array<Int>;
    
    init() {
        scoreArray = Array<Int> (repeating: 0, count: 10);
    }
    
    /**
     * Tries to insert the given score into the scoreboard.
     * Returns a boolean if the score was successfully inserted into the top 10.
     */
    func tryInsertScore(withScore score:Int) -> Bool {
        var spot : Int = -1;
        
        // find score spot
        for i in 0..<scoreArray.count {
            if (score > scoreArray[i]) {
                spot = i;
                break;
            }
        }
        
        // if no spot was found, return
        if (spot == -1) {
            return false;
        }
        
        // shift scores
        for i in (spot + 1)..<scoreArray.count {
            if (i == scoreArray.count - 1) {
                break;
            }
            
            scoreArray[i + 1] = scoreArray[i];
        }
        
        // insert scores
        scoreArray[spot] = score;
        
        return true;
    }
}
