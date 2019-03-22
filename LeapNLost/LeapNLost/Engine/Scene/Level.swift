//
//  Level.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-02-05.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation;

struct Level : Decodable {
    
    // The number of tiles per row
    static let tilesPerRow : Int = 15;
    
    var info: Info;
    var rows: [Row];
    // Level Constructor
    init(){
        info = Info();
        rows = [Row]();
    }
    //Reads the level file for Area area and Level level i.e. Level 1-1 readLevel(1,1)
    func readLevel(withArea area: Int, withLevel level: Int) -> Data{
        //let pathS = "Levels/Level_" + String(area) + "-" + String(level);
        let path = Bundle.main.path(forResource: "Level_" + String(area) + "-" + String(level), ofType: "json", inDirectory: "Levels");
        
        var result = Data();
        do {
            result = try Data(contentsOf: URL(fileURLWithPath: path!));
        }
        catch {
            print("Error reading file. \(error)");
        }
        
        return result;
    }
    
    // Accepts a JSON string as argument, returns a Level object
    func parseJSON(data: Data) -> Level{
        var level = Level();
        do {
            let decoder = JSONDecoder();
            decoder.keyDecodingStrategy = .convertFromSnakeCase;
            level = try decoder.decode(Level.self, from: data);
        } catch{
            print("Error parsing JSON. \(error)");
        }
        
        return level;
    }
    
    // Does the level exist?
    func levelExists(num: Int, num2: Int) -> Bool{
        if (Bundle.main.path(forResource: "Level_" + String(num) + "-" + String(num2), ofType: "json", inDirectory: "Levels") != nil)
        {
            return true;
        }
        return false;
    }
}

// Info struct
struct Info : Decodable {
    let area: Int;
    let level: Int;
    let desc: String;
    
    // If you want the fields to be a specific name
    /*enum CodingKeys : String, CodingKey {
        case area;
        case level
        case desc
    }*/
    
    // Info Constructor
    init(){
        area = -1;
        level = -1;
        desc = "";
    }
}

// Row struct
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


