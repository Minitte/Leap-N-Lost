//
//  Tile.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-03-18.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation

class Tile : GameObject {
    
    // This tile's row
    var row : Int;
    
    // This tile's column
    var column : Int;
    
    init(model: Model, row : Int, column : Int) {
        self.row = row;
        self.column = column;
        super.init(model);
    }
    
}
