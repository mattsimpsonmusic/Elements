//
//  GameScene.swift
//  Elements
//
//  Created by Matthew Simpson on 02/03/2022.
//

import SpriteKit
import GameplayKit
import UIKit
import AudioKit
import SoundpipeAudioKit
import AVFoundation

class GameScene: SKScene {
    
    private var fireflies    : SKEmitterNode!
    private var magic        : SKEmitterNode!
    private var smoke        : SKEmitterNode!
    private var bokeh        : SKEmitterNode!
    
    private var titleLabel   : SKLabelNode?
    private var breatheLabel : SKLabelNode?
    private var focusLabel   : SKLabelNode?
    private var reflectLabel : SKLabelNode?
    
    
    // Define audio engine and player
    var player: AudioPlayer!   // Declare an AudioPlayer for setting up later
    var engine = AudioEngine()
    
    // Define background image
    let background = SKSpriteNode(imageNamed: "bg.jpg")
    
    override func didMove(to view: SKView) {
        
        // Set image to be behind everything else
        background.zPosition = -1
        
        // Scale image to display
        background.scale(to: self.size)
        
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        // Add background image to display
        self.addChild(background)

        
        // Initialise properties defined above
        fireflies = SKEmitterNode(fileNamed: "Fireflies")
        
        // Set position to be top left of display
        fireflies.position = CGPoint(x: self.frame.size.width/2 - 50, y: self.frame.size.height/2 + 330)
        
        // Set animation to start a few seconds in
        fireflies.advanceSimulationTime(5)
        
        // Add animation to display
        self.addChild(fireflies)
        
        
        
        magic = SKEmitterNode(fileNamed: "Magic")
        
        // Set position to be top left of display
        magic.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 140)
        
        //magic.advanceSimulationTime(5)
        
        self.addChild(magic)
        
        
        smoke = SKEmitterNode(fileNamed: "Smoke")
        
        // Set position to be top left of display
        smoke.position = CGPoint(x: self.frame.size.width/2 + 65, y: self.frame.size.height/2 - 65)
        
        smoke.zPosition = -1
        
        
        self.addChild(smoke)
        
        
        
        bokeh = SKEmitterNode(fileNamed: "Bokeh")
        
        // Set position to be top left of display
        bokeh.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 260)
        
        bokeh.zPosition = -1
        
        
        self.addChild(bokeh)
        
        
        // Set up the audio file and link it to the player
                    
        let filePath = Bundle.main.path(forResource: "Welcome.mp3", ofType: nil)!
        let fileURL = URL(fileURLWithPath: filePath)
        player = AudioPlayer(url:fileURL)
                
        player.isLooping = false     // Loop playback until stopped
        engine.output = player    // Connect audio player to output
        try!engine.start()
        player.play()               // Start the file playing
            
        player.volume = 0.4
        
        
        
        // Get label node from scene and store it for use later
        self.titleLabel = self.childNode(withName: "Title") as? SKLabelNode
        if let titleLabel = self.titleLabel {
            titleLabel.alpha = 0.0
            titleLabel.run(SKAction.fadeIn(withDuration: 3.0))
        }
        
        // Get label node from scene and store it for use later
        self.breatheLabel = self.childNode(withName: "breatheLabel") as? SKLabelNode
        if let breatheLabel = self.breatheLabel {
            breatheLabel.alpha = 0.0
            breatheLabel.run(SKAction.fadeIn(withDuration: 3.0))
        }
        
        // Get label node from scene and store it for use later
        self.focusLabel = self.childNode(withName: "focusLabel") as? SKLabelNode
        if let focusLabel = self.focusLabel {
            focusLabel.alpha = 0.0
            focusLabel.run(SKAction.fadeIn(withDuration: 3.0))
        }
        
        // Get label node from scene and store it for use later
        self.reflectLabel = self.childNode(withName: "reflectLabel") as? SKLabelNode
        if let reflectLabel = self.reflectLabel {
            reflectLabel.alpha = 0.0
            reflectLabel.run(SKAction.fadeIn(withDuration: 3.0))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = nodes(at: location)
               
            for node in nodesArray {
                if node.name == "breatheLabel" {
                    let breatheScene = BreatheScene(fileNamed: "BreatheScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    breatheScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(breatheScene!, transition: transition)
                }
                else if node.name == "focusLabel" {
                    let focusScene = FocusScene(fileNamed: "FocusScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    focusScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(focusScene!, transition: transition)
                }
                else if node.name == "reflectLabel" {
                    let reflectScene = ReflectScene(fileNamed: "ReflectScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    reflectScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(reflectScene!, transition: transition)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
