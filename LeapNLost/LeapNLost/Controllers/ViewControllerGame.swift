//
//  ViewControllerGame.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-04.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit
import Swift

class ViewControllerGame : GLKViewController, GLKViewControllerDelegate {
    
    // The openGL game engine.
    private var gameEngine : GameEngine?;
    let buttonAudio = Audio();
    let hopAudio = Audio();
    let squishDieAudio = Audio();
    let splashDieAudio = Audio();
    let coinAudio = Audio();
    let winAudio = Audio();
    var area: Int = 1;
    var level: Int = 1;
    var profile = PlayerProfile.init();
    
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var winText: UILabel!
    @IBOutlet weak var loseText: UILabel!
    @IBOutlet weak var loseView: UIView!
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    // This view as a GLKView
    private var glkView : GLKView?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupGL();
        winView.layer.borderWidth = 5.0;
        winView.layer.borderColor =  UIColor(red: 90/255, green: 181/255, blue: 77/255, alpha: 1.0).cgColor;
        buttonAudio.setURL(fileName: "click", fileType: "wav");
        hopAudio.setURL(fileName: "boing", fileType: "wav");
        splashDieAudio.setURL(fileName: "splashDie", fileType: "wav");
        squishDieAudio.setURL(fileName: "squishDie", fileType: "wav");
        coinAudio.setURL(fileName: "coin", fileType: "wav");
        winAudio.setURL(fileName: "win", fileType: "wav");
    }
    
    /**
     * Sets up the openGL engine.
     */
    func setupGL() {
        // Set the context
        glkView = self.view as? GLKView;
        glkView!.context = EAGLContext(api: .openGLES2)!;
        EAGLContext.setCurrent(glkView!.context);
        delegate = self;
        
        // Enable depth buffer
        glkView!.drawableDepthFormat = GLKViewDrawableDepthFormat.format24;
        glEnable(GLbitfield(GL_DEPTH_TEST));
        
        // Start the engine
        gameEngine = GameEngine(self.view as! GLKView, area: area, level: level);
    }
    
    @IBAction func OnTapGesture(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            hopAudio.play(loop: false);
            let tapPos : CGPoint = sender.location(in: self.view);
            let tapPosVec : Vector3 = Vector3.init(Float(tapPos.x), Float(tapPos.y), 0);
            InputManager.registerSingleTap(at: tapPosVec);
        }
    }

    @IBAction func OnSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            hopAudio.play(loop: false);
            InputManager.registerRightSwipe();
        }
    }
    
    @IBAction func OnSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            hopAudio.play(loop: false);
            InputManager.registerUpSwipe();
        }
    }
    
    @IBAction func OnSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            hopAudio.play(loop: false);
            InputManager.registerLeftSwipe();
        }
    }
    
    @IBAction func NextLevelButton(_ sender: Any) {
        buttonAudio.play(loop: false);
        if(level == 5){
            area += 1;
            level = 1;
        }else{
            level += 1;
        }
        gameEngine = nil;
        gameEngine = GameEngine(self.view as! GLKView, area: area, level: level);
        winView.isHidden = true;
        winText.isHidden = true;
    }
    
    @IBAction func LevelSelectButton(_ sender: Any) {
        buttonAudio.play(loop: false);
        dismiss(animated: true, completion: nil);
        playMainTheme();
    }
    
    @IBAction func MainMenuButton(_ sender: Any) {
        buttonAudio.play(loop: false);
        self.presentingViewController!.dismiss(animated: false, completion: nil);
        self.presentingViewController!.dismiss(animated: true, completion: nil);
        playMainTheme();
    }
    @IBAction func TryAgainButton(_ sender: Any) {
        gameEngine = nil;
        gameEngine = GameEngine(self.view as! GLKView, area: area, level: level);
        loseView.isHidden = true;
        loseText.isHidden = true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputManager.registerTouch()
    }
    
    /**
     * Updates the game.
     */
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        InputManager.nextFrame();
        gameEngine?.update();
        
        // Check if the player is dead
        if ((gameEngine?.currentScene.player.isDead)!) {
            loseText.text = "You Lost";
            loseText.isHidden = false;
            loseView.isHidden = false;
            profile.lastArea = area;
            profile.lastLevel = level;
            pauseButton.isEnabled = false;
        }
        
        // Check if the game is over
        if ((gameEngine?.currentScene.player.isGameOver)!) {
            pauseButton.isEnabled = false;
            profile.lastArea = area;
            profile.lastLevel = level;
            if(area >= profile.reachedArea){
                if(level >= profile.reachedLevel){
                    profile.reachedArea = area + 1;
                    profile.reachedLevel = level + 1;
                    profile.saveToFile();
                }
            }
            if(level == 5){
                if(!((gameEngine?.currentScene.level.levelExists(
                    num: (gameEngine?.currentScene.currArea)!+1,
                    num2: (gameEngine?.currentScene.currLevel)!))!)){
                    nextLevelButton.isHidden = true;
                } else{
                    nextLevelButton.isHidden = false;
                }
            } else{
                if(!((gameEngine?.currentScene.level.levelExists(
                    num: (gameEngine?.currentScene.currArea)!,
                    num2: (gameEngine?.currentScene.currLevel)!+1))!)){
                    nextLevelButton.isHidden = true;
                } else{
                    nextLevelButton.isHidden = false;
                }
            }
            winText.isHidden = false;
            winView.isHidden = false;
        }
        
        if((gameEngine?.physicsEngine.isMemoryFragment)!) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyBoard.instantiateViewController(withIdentifier: "cutscene") as! ViewControllerCutscene;
            
            vc.currentArea = (gameEngine?.currentScene.currArea)!;
            vc.currentLevel = (gameEngine?.currentScene.currLevel)!;
            
            gameEngine?.physicsEngine.isMemoryFragment = false;
            if(vc.fileExist(area: vc.currentArea, level: vc.currentLevel)) {
                self.present(vc, animated: false, completion: nil);
                
            }
            gameEngine?.currentScene.player.isDead = true;
        }
    }
    
    // Pause button
    @IBAction func pause(_ sender: Any) {
        gameEngine?.currentScene.pause = !(gameEngine?.currentScene.pause)!;
        loseView.isHidden = !loseView.isHidden;
        loseText.text = "Pause";
        loseText.isHidden = !loseText.isHidden;
    }
    func playMainTheme(){
        AudioPlayers.shared.stop(index: 0);
        AudioPlayers.shared.set(index: 0, fileName: "MainTheme", fileType: "mp3");
        AudioPlayers.shared.play(index: 0, loop: true);
    }
    
    /**
     * Renders the game.
     */
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        gameEngine?.render(rect);
    }

    
    deinit {
        print("ViewControllerGame deinit");
        gameEngine = nil;
        glkView = nil;
        EAGLContext.setCurrent(nil);
    }
}
