//
//  Cutscene.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

struct Cutscene: Decodable {
    var title : String;
    var picture : String;
    var dialog : [Lines];
    
    init() {
        title = "";
        picture = ""
        dialog = [Lines]();
    }
}

struct Lines: Decodable {
    var id : Int;
    var speaker : String;
    var lines : String;
    
    init() {
        id = 0;
        speaker = "";
        lines = "";
    }
}


