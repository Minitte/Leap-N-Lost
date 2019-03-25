//
//  Animal.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-25.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Animal : Codable {
    // animal name
    var animalName : String;
    
    // animal's model file name
    var modelFileName : String;
    
    // unlocked flag
    var unlocked : Bool;
    
    init(animalName : String, modelFileName : String, unlocked : Bool) {
        self.animalName = animalName;
        
        self.modelFileName = modelFileName;
        
        self.unlocked = unlocked;
    }
    
}
