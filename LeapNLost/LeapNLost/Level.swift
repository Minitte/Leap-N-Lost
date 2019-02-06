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
        
        // Info Constructor
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
        
        // Row constructor
        init(){
            id = -1;
            type = "";
            speed = 0.0;
        }
    }
    
    let info: Info;
    let rows: [Row];
    
    // Level Constructor
    init(){
        info = Info();
        rows = [Row]();
    }
}

//Reads the level file for Area area and Level level i.e. Level 1-1 readLevel(1,1)
func readLevel(withArea area: Int, withLevel level: Int) -> Data{
    let path = "Levels\\Level_" + String(area) + "-" + String(level) + ".json";
    var data = Data();
    do {
        data =  try JSONSerialization.data(withJSONObject: path);
    }
    catch {
        print("Error reading file.")
    }
    
    return data;
}

// Accepts a JSON string as argument, returns a Level object
func parseJSON(data: Data) -> Level{
    var level = Level();
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        level = try decoder.decode(Level.self, from: data)
    } catch{
        print("Error parsing JSON.")
    }
    
    return level;
}
