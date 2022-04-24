//
//  BreatheScene.swift
//  Elements
//
//  Created by Matthew Simpson on 15/03/2022.
//

import SpriteKit
import GameplayKit
import UIKit
import AudioKit
import SoundpipeAudioKit
import AVFoundation


class BreatheScene: SKScene {
    
    // Define scene emitters
    private var rain: SKEmitterNode!
    
    // Define background image
    let background = SKSpriteNode(imageNamed: "forest.png")
    
    // Define text boxes
    private var themeSelectButtonBox : SKSpriteNode?
    private var themeSelectBox : SKSpriteNode?
    
    // Define text buttons
    private var themeSelectButton : SKLabelNode?
    private var forestThemeButton : SKLabelNode?
    private var magicThemeButton : SKLabelNode?
    private var rainfallThemeButton : SKLabelNode?
    
    
    // Define audio engine, players and mixer
    var player: AudioPlayer! // One player for each sound
    var ballPlayer: AudioPlayer!
    var mixer: Mixer! // Mixer to combine sounds
    var engine = AudioEngine() // Output engine
    

    // Define variables for navigation
    var themeSelector = 1 // Toggle variable for theme selection, set to first theme inisitally
    var openThemes = 0 // Switch variable to open/close themes box
    var buttonPressed = 0 // Variable to distinguish between button pressing and emitter generation
    
    
    override func didMove(to view: SKView) {
        
        // Initialise Properties //
        
        // Background
        background.zPosition = -1 // Set position behind everything else
        background.scale(to: self.size) // Scale to display
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        self.addChild(background) // Add background image to scene
        
        // Emitter
        rain = SKEmitterNode(fileNamed: "Rain")
        rain.position = CGPoint(x: 0, y: 1500) // Place emitter to top of screen
        rain.advanceSimulationTime(10) // Advance simulation
        self.addChild(rain) // Add emitter to scene
        
        // Return button
        let button = SKSpriteNode(imageNamed: "previousbutton.png") // Initialise node
        button.position = CGPoint(x: 50, y: self.frame.size.height - 50) // Set position
        button.name = "previousButton" // Set name
        button.setScale(0.5) // Set size
        self.addChild(button) // Add button to scene
        
        // Theme button box
        themeSelectButtonBox = self.childNode(withName: "ThemeSelectButtonBox") as? SKSpriteNode // Initialise node
        themeSelectButtonBox?.alpha = 0.0 // Set visibility to hidden
        themeSelectButtonBox?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Theme button
        themeSelectButton = self.childNode(withName: "ThemeSelectButton") as? SKLabelNode // Initialise node
        themeSelectButton?.alpha = 0.0 // Set visibility to hidden
        themeSelectButton?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Theme selection box
        themeSelectBox = self.childNode(withName: "ThemeSelectBox") as? SKSpriteNode // Initialise node
        themeSelectBox?.alpha = 0.0 // Set visibility to hidden
        
        // Audio players //
        
        // Background music
        let filePath = Bundle.main.path(forResource: "rain.wav", ofType: nil)! // Initialise file path to audio file
        let fileURL = URL(fileURLWithPath: filePath) // Initialise URL from path
        player = AudioPlayer(url:fileURL) // Set player using file URL
        player.volume = 0.4 // Set volume
        player.isLooping = true // Set to loop until stopped
        
        // Interactive sound
        let ballPath = Bundle.main.path(forResource: "drop.mp3", ofType: nil)! // Initialise file path to audio file
        let ballURL = URL(fileURLWithPath: ballPath) // Initialise URL from path
        ballPlayer = AudioPlayer(url:ballURL) // Set player using file URL
        ballPlayer.volume = 0.4 // Set volume
        ballPlayer.isLooping = false // Set to play once
        
        // Audio output //
        
        // Send both players into mixer
        mixer = Mixer(player, ballPlayer)
        mixer.volume = 0.8 // Set volume
        engine.output = mixer // Set audio engine output
        try!engine.start() // Start the engine
        player.play() // Play background music
    }

    // Function for when user touches screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touch
        if let touch = touches.first {
            let location = touch.location(in: self) // Get location of touch
            let nodesarray = nodes(at: location) // Variable to get all nodes that have been touched
         
            // For each node in touch
            for node in nodesarray {
                // If the touched node is the return button
                if node.name == "previousButton" {
                    buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    // Create new instance of home scene to transition to
                    let firstScene = GameScene(fileNamed: "GameScene") // Initialise new scene
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5) // Transition
                    firstScene?.scaleMode = .aspectFill // Set scene to fill display
                    scene?.view?.presentScene(firstScene!, transition: transition) // Perform transition to new scene
                }
                // If the touched node is the theme selection button
                else if node.name == "ThemeSelectButton" {
                    // If the theme selection box is not currently visible
                    if openThemes == 0 {
                        // Set selection box to be visible
                        themeSelectBox?.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in box
                        themeSelectButton?.text = "Close" // Set theme selection button to prompt user to close box when finished
                        openThemes = 1 // Set condition true for theme box being opened
                        buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    }
                    // If the theme selection box is currently visible
                    else {
                        // Set selection box to be hidden
                        themeSelectBox?.run(SKAction.fadeOut(withDuration: 2.0)) // Fade out box
                        themeSelectButton?.text = "Theme" // Set theme selection button to prompt user to open box when needed again
                        openThemes = 0 // Set condition true for theme box being closed
                        buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    }
                }
            }
            // If there was a button pressed in the touch
            if buttonPressed == 1 {
                buttonPressed = 0 // Reset condition for next touch
            }
            // If no button was pressed during touch
            else {
                // Generate particle emitter at touch location
                let ball = SKSpriteNode(imageNamed: "ball") // Initialise new particle emitter
                ball.position = touch.location(in: self) // Set location
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) // Give emitter physical behaviour
                ball.setScale(0.5) // Set size of emitter
                self.addChild(ball) // Add emitter to scene at touch location
                
                // Play sound to accompany particle emitter
                ballPlayer.play() // Play interactive sound player
            }
        }
    }
}
