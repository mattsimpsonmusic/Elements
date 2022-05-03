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
import CryptoKit

class BreatheScene: SKScene {
    
    // Define scene emitters
    private var forestEmitter: SKEmitterNode!
    private var magicEmitter: SKEmitterNode!
    private var starsEmitter: SKEmitterNode!
    private var rainfallEmitter: SKEmitterNode!
    
    //private var touch1: SKEmitterNode!
    private var touch1: SKEmitterNode!
    private var touch2: SKEmitterNode!
    private var touch3: SKEmitterNode!
    
    
    // Define background images
    let forestBackground = SKSpriteNode(imageNamed: "theme1.png")
    let magicBackground = SKSpriteNode(imageNamed: "theme2.png")
    let rainfallBackground = SKSpriteNode(imageNamed: "theme3.png")
    
    // Define text boxes
    private var themeSelectButtonBox : SKSpriteNode?
    private var themeSelectBox : SKSpriteNode?
    
    // Define text buttons
    private var themeSelectButton : SKLabelNode?
    private var forestThemeButton : SKLabelNode?
    private var magicThemeButton : SKLabelNode?
    private var rainfallThemeButton : SKLabelNode?
    
    
    // Define audio engine, players and mixer
    var forestPlayer: AudioPlayer! // One player for each sound
    var magicPlayer: AudioPlayer! // One player for each sound
    var rainfallPlayer: AudioPlayer! // One player for each sound
    
    var note1Player: AudioPlayer!
    var note2Player: AudioPlayer!
    var note3Player: AudioPlayer!
    var note4Player: AudioPlayer!
    
    var droplet1Player: AudioPlayer!
    var droplet2Player: AudioPlayer!
    
    var touchPanner: Panner!
    
    var mixer: Mixer! // Mixer to combine sounds
    var engine = AudioEngine() // Output engine
    

    // Define variables for navigation
    var themeSelector = 1 // Toggle variable for theme selection, set to first theme inisitally
    var openThemes = 0 // Switch variable to open/close themes box
    var buttonPressed = 0 // Variable to distinguish between button pressing and emitter generation
    
    var soundCounter = 1
    
    
    override func didMove(to view: SKView) {
        
        // Initialise Properties //
        
        // Forest background
        forestBackground.zPosition = -1 // Set position behind everything else
        forestBackground.scale(to: self.size) // Scale to display
        forestBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        self.addChild(forestBackground) // Add background image to scene
        
        // Magic background
        magicBackground.zPosition = -1 // Set position behind everything else
        magicBackground.scale(to: self.size) // Scale to display
        magicBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        magicBackground.alpha = 0.0 // Set to be hidden initially
        self.addChild(magicBackground) // Add background image to scene
        
        // Rainfall background
        rainfallBackground.zPosition = -1 // Set position behind everything else
        rainfallBackground.scale(to: self.size) // Scale to display
        rainfallBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        rainfallBackground.alpha = 0.0 // Set to be hidden initially
        self.addChild(rainfallBackground) // Add background image to scene
        
        // Emitters
        
        // Forest emitter
        forestEmitter = SKEmitterNode(fileNamed: "ForestEmitter")
        forestEmitter.position = CGPoint(x: 0, y: 0) // Place emitter on screen
        forestEmitter.advanceSimulationTime(10) // Advance simulation
        self.addChild(forestEmitter) // Add emitter to scene
        
        // Magic emitter
        magicEmitter = SKEmitterNode(fileNamed: "MagicEmitter")
        magicEmitter.position = CGPoint(x: 0, y: 200) // Place emitter to top of screen
        magicEmitter.advanceSimulationTime(10) // Advance simulation
        
        // Rainfall emitter
        rainfallEmitter = SKEmitterNode(fileNamed: "RainfallEmitter")
        rainfallEmitter.position = CGPoint(x: 0, y: 1500) // Place emitter to top of screen
        rainfallEmitter.advanceSimulationTime(10) // Advance simulation
        
        // Stars emitter
        starsEmitter = SKEmitterNode(fileNamed: "StarsEmitter")
        starsEmitter.position = CGPoint(x: 300, y: 700) // Place emitter to top of screen
        starsEmitter.advanceSimulationTime(10) // Advance simulatio
        
        //touch1 = SKEmitterNode(fileNamed: "Theme1Touch")
        touch1 = SKEmitterNode(fileNamed: "Theme1Touch")
        touch2 = SKEmitterNode(fileNamed: "Theme2Touch")
        touch3 = SKEmitterNode(fileNamed: "Theme3Touch")
        
        // Return button
        let button = SKSpriteNode(imageNamed: "leaf.png") // Initialise node
        button.position = CGPoint(x: 50, y: self.frame.size.height - 70) // Set position
        button.name = "previousButton" // Set name
        button.setScale(0.20) // Set size
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
        
        
        // Forest theme background music
        let forestFilePath = Bundle.main.path(forResource: "forest.mp3", ofType: nil)! // Initialise file path to audio file
        let forestFileURL = URL(fileURLWithPath: forestFilePath) // Initialise URL from path
        forestPlayer = AudioPlayer(url:forestFileURL) // Set player using file URL
        forestPlayer.volume = 0.3 // Set volume
        forestPlayer.isLooping = true // Set to loop until stopped
        
        // Forest theme background music
        let magicFilePath = Bundle.main.path(forResource: "Dream.wav", ofType: nil)! // Initialise file path to audio file
        let magicFileURL = URL(fileURLWithPath: magicFilePath) // Initialise URL from path
        magicPlayer = AudioPlayer(url:magicFileURL) // Set player using file URL
        magicPlayer.volume = 0.55 // Set volume
        magicPlayer.isLooping = true // Set to loop until stopped
        
        
        // Background music
        let rainfallFilePath = Bundle.main.path(forResource: "piano.mp3", ofType: nil)! // Initialise file path to audio file
        let rainfallFileURL = URL(fileURLWithPath: rainfallFilePath) // Initialise URL from path
        rainfallPlayer = AudioPlayer(url:rainfallFileURL) // Set player using file URL
        rainfallPlayer.volume = 0.9 // Set volume
        rainfallPlayer.isLooping = true // Set to loop until stopped
        
        
        
        
        // Send output player to mixer
        mixer = Mixer(forestPlayer, magicPlayer, rainfallPlayer)
        mixer.volume = 0.8 // Set volume
        engine.output = mixer // Set audio engine output
        try!engine.start() // Start the engine
        forestPlayer.play() // Play background music for first theme
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
                else if node.name == "ForestThemeButton" {
                    buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    if themeSelector == 2 {
                        // Transition between backgrounds
                        magicBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        forestBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 1
                        // Swap between background soundscapes
                        magicPlayer.stop()
                        forestPlayer.start()
                        // Change emitters
                        magicEmitter.removeFromParent()
                        starsEmitter.removeFromParent()
                        self.addChild(forestEmitter)
                    }
                    else {
                        // Transition between backgrounds
                        rainfallBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        forestBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 1
                        // Swap between background soundscapes
                        rainfallPlayer.stop()
                        forestPlayer.start()
                        // Change emitters
                        rainfallEmitter.removeFromParent()
                        self.addChild(forestEmitter)
                    }
                }
                else if node.name == "MagicThemeButton" {
                    buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    if themeSelector == 1 {
                        // Transition between backgrounds
                        forestBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        magicBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 2
                        // Swap between background soundscapes
                        forestPlayer.stop()
                        magicPlayer.start()
                        // Change emitters
                        forestEmitter.removeFromParent()
                        self.addChild(magicEmitter)
                        self.addChild(starsEmitter)
                    }
                    else {
                        // Transition between backgrounds
                        rainfallBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        magicBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 2
                        // Swap between background soundscapes
                        rainfallPlayer.stop()
                        magicPlayer.start()
                        // Change emitters
                        rainfallEmitter.removeFromParent()
                        self.addChild(magicEmitter)
                        self.addChild(starsEmitter)
                    }
                }
                else if node.name == "RainfallThemeButton" {
                    buttonPressed = 1 // Set condition true for a button being pressed instead of emitter generation
                    if themeSelector == 1 {
                        // Transition between backgrounds
                        forestBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        rainfallBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 3
                        // Swap between background soundscapes
                        forestPlayer.stop()
                        rainfallPlayer.start()
                        // Change emitters
                        forestEmitter.removeFromParent()
                        self.addChild(rainfallEmitter)
                    }
                    else {
                        // Transition between backgrounds
                        magicBackground.run(SKAction.fadeOut(withDuration: 2.0))
                        rainfallBackground.run(SKAction.fadeIn(withDuration: 2.0))
                        // Set theme selector
                        themeSelector = 3
                        // Swap between background soundscapes
                        magicPlayer.stop()
                        rainfallPlayer.start()
                        // Change emitters
                        magicEmitter.removeFromParent()
                        starsEmitter.removeFromParent()
                        self.addChild(rainfallEmitter)
                    }
                }
            }
            // If there was a button pressed in the touch
            if buttonPressed == 1 {
                buttonPressed = 0 // Reset condition for next touch
            }
            // If no button was pressed during touch
            else {
    
                if themeSelector == 1 {
                    // Create a copy of the touch down animation and add it at the touch position
                    if let emitter = self.touch1?.copy() as! SKEmitterNode? {
                        emitter.position = touch.location(in: self)
                        self.addChild(emitter)
                    }
                }
                else if themeSelector == 2 {
                    // Create a copy of the touch down animation and add it at the touch position
                    if let emitter = self.touch2?.copy() as! SKEmitterNode? {
                        emitter.position = touch.location(in: self)
                        self.addChild(emitter)
                    }
                }
                else {
                    // Create a copy of the touch down animation and add it at the touch position
                    if let emitter = self.touch3?.copy() as! SKEmitterNode? {
                        emitter.position = touch.location(in: self)
                        self.addChild(emitter)
                    }
                }
                
                // Interactive sound generation
                 
                
                let note1FilePath = Bundle.main.path(forResource: "note1.mp3", ofType: nil)! // Initialise file path to audio file
                let note1FileURL = URL(fileURLWithPath: note1FilePath) // Initialise URL from path
                note1Player = AudioPlayer(url: note1FileURL) // Set player using file URL
                note1Player.volume = 0.6 // Set volume
                
                let note2FilePath = Bundle.main.path(forResource: "note2.mp3", ofType: nil)! // Initialise file path to audio file
                let note2FileURL = URL(fileURLWithPath: note2FilePath) // Initialise URL from path
                note2Player = AudioPlayer(url: note2FileURL) // Set player using file URL
                note2Player.volume = 0.6 // Set volume
                
                let note3FilePath = Bundle.main.path(forResource: "note3.mp3", ofType: nil)! // Initialise file path to audio file
                let note3FileURL = URL(fileURLWithPath: note3FilePath) // Initialise URL from path
                note3Player = AudioPlayer(url: note3FileURL) // Set player using file URL
                note3Player.volume = 0.6 // Set volume
                
                let note4FilePath = Bundle.main.path(forResource: "note4.mp3", ofType: nil)! // Initialise file path to audio file
                let note4FileURL = URL(fileURLWithPath: note4FilePath) // Initialise URL from path
                note4Player = AudioPlayer(url: note4FileURL) // Set player using file URL
                note4Player.volume = 0.6 // Set volume
                
                let droplet1FilePath = Bundle.main.path(forResource: "droplet1.mp3", ofType: nil)! // Initialise file path to audio file
                let droplet1FileURL = URL(fileURLWithPath: droplet1FilePath) // Initialise URL from path
                droplet1Player = AudioPlayer(url: droplet1FileURL) // Set player using file URL
                droplet1Player.volume = 0.55 // Set volume
                
                let droplet2FilePath = Bundle.main.path(forResource: "droplet2.mp3", ofType: nil)! // Initialise file path to audio file
                let droplet2FileURL = URL(fileURLWithPath: droplet2FilePath) // Initialise URL from path
                droplet2Player = AudioPlayer(url: droplet2FileURL) // Set player using file URL
                droplet2Player.volume = 0.35 // Set volume
                
                // Touch on x between 0 and 414
                let touchNormaliser = (location.x - 207) / 207 // Range now between -207 and 207
                let panAmount = AUValue(touchNormaliser)
                //print(touchNormaliser)
                //print(panAmount)
                
                
                if themeSelector == 1{
                    if soundCounter == 1 {
                        touchPanner = Panner(note1Player, pan:  panAmount)
                        mixer.addInput(touchPanner) // Add new player to mixer
                        note1Player.play()
                        touchPanner.play() // Play interactive sound player
                        soundCounter = Int.random(in: 1..<5)
                    }
                    else if soundCounter == 2 {
                        touchPanner = Panner(note2Player, pan:  panAmount)
                        mixer.addInput(touchPanner) // Add new player to mixer
                        note2Player.play()
                        touchPanner.play() // Play interactive sound player
                        soundCounter = Int.random(in: 1..<5)
                    }
                    else if soundCounter == 3 {
                        touchPanner = Panner(note3Player, pan:  panAmount)
                        mixer.addInput(touchPanner) // Add new player to mixer
                        note3Player.play()
                        touchPanner.play() // Play interactive sound player
                        soundCounter = Int.random(in: 1..<5)
                    }
                    else {
                        touchPanner = Panner(note4Player, pan:  panAmount)
                        mixer.addInput(touchPanner) // Add new player to mixer
                        note4Player.play()
                        touchPanner.play() // Play interactive sound player
                        soundCounter = Int.random(in: 1..<5)
                    }
                }
                else if themeSelector == 2 {
                    touchPanner = Panner(droplet1Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    droplet1Player.play()
                    touchPanner.play() // Play interactive sound player
                }
                else {
                    touchPanner = Panner(droplet2Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    droplet2Player.play()
                    touchPanner.play() // Play interactive sound player
                }
            }
        }
    }
}
