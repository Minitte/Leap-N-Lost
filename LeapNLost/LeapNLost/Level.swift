//
//  Level.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation;

struct Level : Decodable {
    struct Info : Decodable {
        let area: Int;
        let level: Int;
        let desc: String;
        
        // If you want the fields to be a specific name
        enum CodingKeys : String, CodingKey {
            case area;
            case level
            case desc
        }
        
        init(){
            area = -1;
            level = -1;
            desc = "";
        }
    }
    
    struct Row : Decodable {
        let id: Int;
        let type: String;
        let speed: Float;
        init(){
            id = -1;
            type = "";
            speed = 0.0;
        }
    }
    
    let info: Info;
    let rows: [Row];
    
    init(){
        info = Info();
        rows = [Row]();
    }
}

// Accepts a JSON string as argument, returns a Level object
func parseJSON(string: String) -> Level{
    let data = string.data(using: .utf8)!
    var level = Level();
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        level = try decoder.decode(Level.self, from: data)
    } catch{
        print("Error parsing JSON")
    }
    
    return level;
}
