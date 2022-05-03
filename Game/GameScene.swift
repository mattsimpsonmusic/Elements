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
    
    // Define scene emitters
    private var fireflies: SKEmitterNode!
    private var magic: SKEmitterNode!
    private var smoke: SKEmitterNode!
    private var bokeh: SKEmitterNode!
    
    // Define labels & buttons
    private var titleLabel: SKLabelNode?
    private var breatheLabel: SKLabelNode?
    private var focusLabel: SKLabelNode?
    private var reflectLabel: SKLabelNode?
    
    
    // Define audio engine and player
    var player: AudioPlayer!   // Declare an AudioPlayer for setting up later
    var engine = AudioEngine()
    
    // Define background image
    let background = SKSpriteNode(imageNamed: "homescreen.jpg")
    
    
    override func didMove(to view: SKView) {
        
        // Initialise background
        background.zPosition = -1// Set image to be behind everything else
        background.scale(to: self.size)// Scale image to display
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Set position
        self.addChild(background) // Add background image to display

        
        // Initialise emitters
        
        // Title
        fireflies = SKEmitterNode(fileNamed: "Fireflies")
        fireflies.position = CGPoint(x: self.frame.size.width/2 - 50, y: self.frame.size.height/2 + 330) // Set position to be top left of display
        fireflies.advanceSimulationTime(5) // Set animation to start a few seconds in
        self.addChild(fireflies) // Add emitter to display
        
        // Mode 1
        magic = SKEmitterNode(fileNamed: "Magic")
        magic.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 140) // Set position on screen
        self.addChild(magic) // Add emitter to display
        
        // Mode 2
        smoke = SKEmitterNode(fileNamed: "Smoke")
        smoke.position = CGPoint(x: self.frame.size.width/2 + 65, y: self.frame.size.height/2 - 65) // Set position on screen
        smoke.zPosition = -1 // Set to be behind text
        self.addChild(smoke) // Add emitter to display
        
        
        // Mode 3
        bokeh = SKEmitterNode(fileNamed: "Bokeh")
        bokeh.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 260) // Set position on screen
        bokeh.zPosition = -1 // Set to be behind text
        self.addChild(bokeh) // Add emitter to display
        
        
        // Set up the intro audio file and link it to the player
        let filePath = Bundle.main.path(forResource: "Welcome.mp3", ofType: nil)! // Connect audio file from path
        let fileURL = URL(fileURLWithPath: filePath) // Create URL
        player = AudioPlayer(url:fileURL) // Initialise audio player
        player.isLooping = false  // Don't loop
        engine.output = player // Connect audio player to output
        try!engine.start() // Start the audio engine
        player.play() // Start the file playing
        player.volume = 0.6 // Set volume
        
        
        
        // Initialise labels & buttons
        
        // Title label
        self.titleLabel = self.childNode(withName: "Title") as? SKLabelNode
        if let titleLabel = self.titleLabel {
            titleLabel.alpha = 0.0 // Set to be hidden
            titleLabel.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        }
        
        // Mode 1 button
        self.breatheLabel = self.childNode(withName: "breatheLabel") as? SKLabelNode
        if let breatheLabel = self.breatheLabel {
            breatheLabel.alpha = 0.0 // Set to be hidden
            breatheLabel.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        }
        
        // Mode 2 button
        self.focusLabel = self.childNode(withName: "focusLabel") as? SKLabelNode
        if let focusLabel = self.focusLabel {
            focusLabel.alpha = 0.0 // Set to be hidden
            focusLabel.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        }
        
        // Mode 3 button
        self.reflectLabel = self.childNode(withName: "reflectLabel") as? SKLabelNode
        if let reflectLabel = self.reflectLabel {
            reflectLabel.alpha = 0.0 // Set to be hidden
            reflectLabel.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        }
    }
    
    
    // Function for if there is a touch on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If there is a touch on the screen, store the first touch
        if let touch = touches.first {
            let location = touch.location(in: self) // Get location of touch on screen
            let nodesArray = nodes(at: location) // Create array of nodes at touch location
              
            // For every node within the touch
            for node in nodesArray {
                // Check if an object on the screen is within the touch location
                // App mode 1
                if node.name == "breatheLabel" {
                    let breatheScene = BreatheScene(fileNamed: "BreatheScene") // Create new instance of scene
                    let transition = SKTransition.crossFade(withDuration: 2.0) // Create transition
                    breatheScene?.scaleMode = .aspectFill // Set scene to fill screen
                    scene?.view?.presentScene(breatheScene!, transition: transition) // Perform transition into scene
                }
                // App mode 2
                else if node.name == "focusLabel" {
                    let focusScene = FocusScene(fileNamed: "FocusScene") // Create new instance of scene
                    let transition = SKTransition.crossFade(withDuration: 2.0) // Create transition
                    focusScene?.scaleMode = .aspectFill // Set scene to fill screen
                    scene?.view?.presentScene(focusScene!, transition: transition) // Perform transition into scene
                }
                // App mode 3
                else if node.name == "reflectLabel" {
                    let reflectScene = ReflectScene(fileNamed: "ReflectScene") // Create new instance of scene
                    let transition = SKTransition.crossFade(withDuration: 2.0) // Create transition
                    reflectScene?.scaleMode = .aspectFill // Set scene to fill screen
                    scene?.view?.presentScene(reflectScene!, transition: transition) // Perform transition into scene
                }
            }
        }
    }
    
    // Update function
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
