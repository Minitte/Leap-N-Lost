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
    func animate(text: String, label: UILabel, delay: TimeInterval, view: UIViewController) {
        //Sets a block of code for asynchronous execution
        DispatchQueue.main.async {
            //Set the text to blank.
            self.text = ""
            var isSpeaker : Bool = false;
            var currentSpeaker : String = "";
            
            //Loop through the passed in String
            for (index, character) in text.enumerated() {
               //Enqueues the append function to execute eventually.
                DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                    //if the character is an @ symbol
                    if(character == "@") {
                        
                        //Toggle a boolean used to read who is speaking.
                        isSpeaker = !isSpeaker;
                        
                        //If false and character is still @ symbol
                        if(!isSpeaker) {
                            //Display who is speaking in a UILabel.
                            label.text = currentSpeaker;
                        }else {
                            //Make the local String blank.
                            currentSpeaker = "";
                        }
                    }else if(character == "\t") {
                        view.navigationController?.popViewController(animated: true);
                        view.dismiss(animated: false, completion: nil);
                    }else {
                        //If character is not @ symbol. Display character in UITextField
                        if(!isSpeaker) {
                            self.text?.append(character)
                        }else {
                            //Append local string for speaker.
                            currentSpeaker.append(character);
                        }
                    }
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
    
    //Function to concatenate a line object.
    func combineLines(lines : Cutscene) -> String{
        var data : String = "";
        
        for i in 0..<lines.dialog.count {
            data += "@" + lines.dialog[i].speaker + "@" + lines.dialog[i].lines;
        }
        
        return data;
    }

}
class ViewControllerCutscene: UIViewController {
    @IBOutlet weak var dialogController: UITextView!;
    @IBOutlet weak var dialogSpeaker: UILabel!
    var currentArea : Int = 0;
    var currentLevel : Int = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //Create Cutscene object.
        var cutscene = Cutscene();
        //Load intro.
        let data = cutscene.readCutscene(json: "\(currentArea)-\(currentLevel)");
        cutscene = cutscene.parseCutscene(data: data);
        let lines : String = cutscene.combineLines(lines: cutscene);
        //Call animate to show cutscene.
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: cutscene.picture)!);
        self.image(data: cutscene);
        dialogController.animate(text: lines, label: dialogSpeaker , delay: 0.039, view: self);
        
        
    }
    
    func image(data: Cutscene) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds);
        backgroundImage.image = UIImage(named: data.picture);
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0);
    }
}
