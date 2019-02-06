//
//  Level.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

struct Level : Codable {
    struct Info : Codable {
        let area: Int;
        let level: Int;
        let desc: String;
        
        // If you want the fields to be a specific name
        enum CodingKeys : String, CodingKey {
            case area;
            case level
            case desc
        }
    }
    
    struct Row : Codable {
        let id: Int;
        let type: String;
        let speed: Float;
    }
    
    let info: Info;
    let rows: [Row];
}
