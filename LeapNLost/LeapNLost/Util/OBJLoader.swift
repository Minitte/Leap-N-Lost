//
//  OBJLoader.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-11.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class OBJLoader {
    
    public static func loadModel(nameOfModel name:String) {
        let path = Bundle.main.path(forResource: "Model_" + name, ofType: "obj", inDirectory: "Models");
        
        do {
            let contents : String = try String(contentsOfFile: path!);
            
            let lines : [String] = contents.components(separatedBy: "\n");
            
            NSLog(contents);
        }
        catch {
            print("Error reading file. \(error)");
        }
    }
    
    private static func extractVertex(vertexLine vl:String) {
        
    }
    
}
