//
//  ViewControllerMainMenu.swift
//  LeapNLost
//
//  Created by Ricky Mok on 2019-01-31.
//  Copyright © 2019 bcit. All rights reserved.
//

import UIKit

class ViewControllerMainMenu: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        OBJLoader.loadModel(nameOfModel: "cube");
    }
    
    /*@IBAction func testJSON(_ sender: Any) {
        var level = Level();
        let data = level.readLevel(withArea: 0, withLevel: 0);
        level = level.parseJSON(data: data);
        print(level.rows[0].type);
    }*/
    
    
    // Exits app when Exit button is pressed
    @IBAction func exitApp(_ sender: Any) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
}
