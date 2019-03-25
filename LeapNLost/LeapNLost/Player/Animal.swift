//
//  Animal.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-25.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Animal : Codable {
    
    var animalName : String;
    
    var modelFileName : String;
    
    var unlocked : Bool;
    
    init(animalName : String, modelFileName : String, unlocked : Bool) {
        self.animalName = animalName;
        
        self.modelFileName = modelFileName;
        
        self.unlocked = unlocked;
    }
    
}
