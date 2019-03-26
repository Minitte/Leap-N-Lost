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
    
    var textureFileName : String;
    
    // unlocked flag
    var unlocked : Bool;
    
    init(animalName : String, modelFileName : String, textureFileName : String, unlocked : Bool) {
        self.animalName = animalName;
        
        self.modelFileName = modelFileName;
        
        self.textureFileName = textureFileName;
        
        self.unlocked = unlocked;
    }
    
}
