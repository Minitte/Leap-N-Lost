//
//  ViewControllerCutscene.swift
//  LeapNLost
//
//  Created by Jackee Ma on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import UIKit

//Adding typewritter effect function to UITextView
extension UITextView {
    //animate will take in a string and sets the UITextView's text
    func animate(text: String, delay: TimeInterval) {
        //Sets a block of code for asynchronous execution
        DispatchQueue.main.async {
            //Set the text to blank.
            self.text = ""
            
            //Loop through the passed in String
            for (index, character) in text.enumerated() {
                //Enqueues the append function to execute eventually.
                DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
}

extension Cutscene {
    func readCutscene(json: String) -> Data {
        let path = Bundle.main.path(forResource: json, ofType: "json");
        var result = Data();
        
        do {
            result = try Data(contentsOf: URL(fileURLWithPath: path!));
        }catch {
            print("Error reading file. \(error)");
        }
        return result;
    }
    
    func parseCutscene(data: Data) -> Cutscene{
        var cutscene = Cutscene();
        do {
            let decoder = JSONDecoder();
            cutscene = try decoder.decode(Cutscene.self, from: data);
        } catch{
            print("Error parsing JSON. \(error)");
        }
        
        return cutscene;
    }

}
class ViewControllerCutscene: UIViewController {
    @IBOutlet weak var dialogController: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad();
        var cutscene = Cutscene();
        let data = cutscene.readCutscene(json: "intro");
        cutscene = cutscene.parseCutscene(data: data);
        print(cutscene.dialog[0].lines);
    }
    
   
}
