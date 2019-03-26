//
//  AnimalList.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-25.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class AnimalList : Codable {
    // list of animals
    var animals : [Animal];
    
    // current selected animal
    var animalIndex : Int;
    
    init() {
        animals = [Animal]();
        
        // ANIMAL LIST
        
        animals.append(Animal(animalName: "Frog", modelFileName: "frog", textureFileName: "frogtex.png", unlocked: true));
        
        animals.append(Animal(animalName: "Rabbit", modelFileName: "rabbit", textureFileName: "rabbit.png", unlocked: true));
        
        // END OF ANIMAL LIST
        
        animalIndex = 0;
    }
    
    /**
     * Moves the animal index to the next unlocked animal.
     * If there is no other animal, it cycles back to the original.
     */
    func nextUnlockedAnimal() -> Int {
        for offset in 0 ..< animals.count {
            var currentIndex : Int = animalIndex + 1 + offset;
            
            currentIndex = currentIndex % animals.count;
            
            if (animals[currentIndex].unlocked) {
                animalIndex = currentIndex;
                return animalIndex;
            }
        }
        
        return animalIndex;
    }
    
    /**
     * Moves the animal index to the prev unlocked animal.
     * If there is no other animal, it cycles back to the original.
     */
    func prevUnlockedAnimal() -> Int {
        for offset in 0 ..< animals.count {
            var currentIndex : Int = animalIndex - 1 - offset;
            
            currentIndex = (currentIndex + animals.count) % animals.count;
            
            if (animals[currentIndex].unlocked) {
                animalIndex = currentIndex;
                return animalIndex;
            }
        }
        
        return animalIndex;
    }
    
    /**
     * Returns the current animal from the current index.
     */
    func getCurrentAnimal() -> Animal {
        return animals[animalIndex];
    }
}
