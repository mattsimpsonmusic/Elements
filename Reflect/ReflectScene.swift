//
//  ReflectScene.swift
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


class ReflectScene: SKScene {
    
    // Define background image
    let reflectBackground = SKSpriteNode(imageNamed: "FireBackground.png")
    
    // Define audio engine, players and mixer
    var firePlayer: AudioPlayer! // Declare an AudioPlayer for setting up later
    // Define players for note presses
    var note1Player: AudioPlayer!
    var note2Player: AudioPlayer!
    var note3Player: AudioPlayer!
    var note4Player: AudioPlayer!
    var touchPanner: Panner! // Panner to spread sounds
    var mixer: Mixer! // Mixer to combine sounds
    var engine = AudioEngine() // Main audio engine
    
    // Define emitters
    private var question1Fire: SKEmitterNode!
    private var question2Fire: SKEmitterNode!
    private var question3Fire: SKEmitterNode!
    
    // Define labels
    private var questionLabel : SKLabelNode?
    private var titleLabel : SKLabelNode?
    private var beginLabel : SKLabelNode?
    private var redLabel : SKLabelNode?
    private var yellowLabel : SKLabelNode?
    private var blueLabel : SKLabelNode?
    private var greenLabel : SKLabelNode?
    private var nextLabel : SKLabelNode?
    private var prevLabel : SKLabelNode?
    private var resultsLabel : SKLabelNode?
    private var moreInfoLabel : SKLabelNode?
    private var returnLabel : SKLabelNode?
    
    // Define boxes
    private var moreInfoBox : SKSpriteNode?
    private var returnBox : SKSpriteNode?
    
    // Define counter variable
    private var questionCount = 0
    
    // Define time interval
    var lastUpdateTime: TimeInterval?
    
    override func didMove(to view: SKView) {
        
        // Start background
        reflectBackground.zPosition = -1 // Set position behind everything else
        reflectBackground.scale(to: self.size) // Scale to display
        reflectBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        self.addChild(reflectBackground) // Add background image to scene
        
        // Initialise background sounds
        let fireFilePath = Bundle.main.path(forResource: "Fire.mp3", ofType: nil)!
        let fireFileURL = URL(fileURLWithPath: fireFilePath)
        firePlayer = AudioPlayer(url:fireFileURL)
        firePlayer.volume = 0.4 // Set volume
        firePlayer.isLooping = true // Loop playback until stopped
        
        // Send output player to mixer
        mixer = Mixer(firePlayer)
        mixer.volume = 0.8 // Set volume
        engine.output = mixer // Set audio engine output
        try!engine.start() // Start the engine
        firePlayer.play() // Play background sounds
        
        // Return button
        let button = SKSpriteNode(imageNamed: "leaf.png") // Initialise node
        button.position = CGPoint(x: 50, y: self.frame.size.height - 70) // Set position
        button.name = "previousButton" // Set name
        button.setScale(0.20) // Set size
        self.addChild(button) // Add button to scene
        
        // Fade in title
        titleLabel = self.childNode(withName: "TitleLabel") as? SKLabelNode // Initialise label
        titleLabel?.alpha = 0.0 // Set visibility to hidden
        titleLabel?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
         
        // Fade in Results label
        questionLabel = self.childNode(withName: "QuestionLabel") as? SKLabelNode // Initialise label
        questionLabel?.alpha = 0.0 // Set visibility to hidden
        questionLabel?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Fade in begin message
        beginLabel = self.childNode(withName: "BeginLabel") as? SKLabelNode // Initialise label
        beginLabel?.alpha = 0.0 // Set visibility to hidden
        beginLabel?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Initialise other labels
        nextLabel = self.childNode(withName: "NextLabel") as? SKLabelNode
        prevLabel = self.childNode(withName: "PrevLabel") as? SKLabelNode
        blueLabel = self.childNode(withName: "BlueLabel") as? SKLabelNode
        redLabel = self.childNode(withName: "RedLabel") as? SKLabelNode
        greenLabel = self.childNode(withName: "GreenLabel") as? SKLabelNode
        yellowLabel = self.childNode(withName: "YellowLabel") as? SKLabelNode
        resultsLabel = self.childNode(withName: "ResultsLabel") as? SKLabelNode
        moreInfoLabel = self.childNode(withName: "MoreInfoLabel") as? SKLabelNode
        returnLabel = self.childNode(withName: "ReturnLabel") as? SKLabelNode
        
        // Set other labels to be invisible
        nextLabel?.alpha = 0.0
        prevLabel?.alpha = 0.0
        blueLabel?.alpha = 0.0
        redLabel?.alpha = 0.0
        greenLabel?.alpha = 0.0
        yellowLabel?.alpha = 0.0
        resultsLabel?.alpha = 0.0
        moreInfoLabel?.alpha = 0.0
        returnLabel?.alpha = 0.0
        
        // Initialise boxes
        returnBox = self.childNode(withName: "ReturnBox") as? SKSpriteNode
        moreInfoBox = self.childNode(withName: "MoreInfoBox") as? SKSpriteNode
        
        // Set visibility to hidden
        returnBox?.alpha = 0.0
        moreInfoBox?.alpha = 0.0
        
        
        
        // Add fire emitters
        
        // Question one emitter
        question1Fire = SKEmitterNode(fileNamed: "Question1Fire") // Initialise emitter
        question1Fire.particleColorBlendFactor = 1.0 // Set blend to be full tint
        question1Fire.particleColorSequence = nil // Don't change colour over time
        question1Fire.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 80) // Set position
        addChild(question1Fire) // Add to scene
        
        // Question one emitter
        question2Fire = SKEmitterNode(fileNamed: "Question2Fire") // Initialise emitter
        question2Fire.particleColorBlendFactor = 1.0 // Set blend to be full tint
        question2Fire.particleColorSequence = nil // Don't change colour over time
        question2Fire.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 80) // Set position
        addChild(question2Fire) // Add to scene
        
        // Question one emitter
        question3Fire = SKEmitterNode(fileNamed: "Question3Fire") // Initialise emitter
        question3Fire.particleColorBlendFactor = 1.0 // Set blend to be full tint
        question3Fire.particleColorSequence = nil // Don't change colour over time
        question3Fire.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 80) // Set position
        addChild(question3Fire) // Add to scene
    }
    
    // Function for when the screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If there is a touch on the screen
        if let touch = touches.first {
            let location = touch.location(in: self) // Get the location of the touch
            let nodesarray = nodes(at: location) // Create array of objects within touch
            
            // Create note players
            
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
            
            // Touch on x between 0 and 414
            let touchNormaliser = (location.x - 207) / 207 // Range now between -207 and 207
            let panAmount = AUValue(touchNormaliser)
         
            // Check if any objects are within the touch
            for node in nodesarray {
                // If the previous button was presse
                if node.name == "previousButton" {
                    let firstScene = GameScene(fileNamed: "GameScene") // Create new instance of home screen
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5) // Create transition
                    firstScene?.scaleMode = .aspectFill // Set scene to fill display
                    scene?.view?.presentScene(firstScene!, transition: transition) // Perform transition to new scene
                }
                // If begin button is pressed
                else if node.name == "BeginLabel" {
                    // Fade out begin label
                    beginLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    
                    // Fade in prev, next & colour labels
                    prevLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    nextLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    greenLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    blueLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    yellowLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    redLabel?.run(SKAction.fadeIn(withDuration: 2.0))
        
                    // Increment questopm counter
                    questionCount += 1
                    // Display first question
                    questionLabel?.text = "How are you feeling?"
                    
                }
                // If yellow button is pressed
                else if node.name == "YellowLabel" {
                    // If on the first question
                    if questionCount == 1 {
                        // Set first question emitter to yellow
                        question1Fire.particleColor = SKColor.yellow
                    }
                    // If on the second question
                    else if questionCount == 2 {
                        // Set second question emitter to yellow
                        question2Fire.particleColor = SKColor.yellow
                    }
                    // If on the third question
                    else {
                        // Set third question emitter to yellow
                        question3Fire.particleColor = SKColor.yellow
                    }
                
                    // Set panner to take in touch location
                    touchPanner = Panner(note1Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    note1Player.play() // Play note sound
                    touchPanner.play() // Play interactive sound player
                }
                // If blue button is pressed
                else if node.name == "BlueLabel" {
                    // If on the first question
                    if questionCount == 1 {
                        // Set first question emitter to blue
                        question1Fire.particleColor = SKColor.blue
                    }
                    // If on the second question
                    else if questionCount == 2 {
                        // Set second question emitter to blue
                        question2Fire.particleColor = SKColor.blue
                    }
                    // If on the third question
                    else {
                        // Set third question emitter to blue
                        question3Fire.particleColor = SKColor.blue
                    }
                    
                    // Set panner to take in touch location
                    touchPanner = Panner(note2Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    note2Player.play() // Play note sound
                    touchPanner.play() // Play interactive sound player
                }
                // If red button is pressed
                else if node.name == "RedLabel" {
                    // If on the first question
                    if questionCount == 1 {
                        // Set first question emitter to red
                        question1Fire.particleColor = SKColor.red
                    }
                    // If on the second question
                    else if questionCount == 2 {
                        // Set second question emitter to red
                        question2Fire.particleColor = SKColor.red
                    }
                    // If on the third question
                    else {
                        // Set third question emitter to red
                        question3Fire.particleColor = SKColor.red
                    }
                    
                    // Set panner to take in touch location
                    touchPanner = Panner(note3Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    note3Player.play() // Play note sound
                    touchPanner.play() // Play interactive sound player
                }
                // If green button is pressed
                else if node.name == "GreenLabel" {
                    // If on the first question
                    if questionCount == 1 {
                        // Set first question emitter to green
                        question1Fire.particleColor = SKColor.green
                    }
                    // If on the second question
                    else if questionCount == 2 {
                        // Set second question emitter to green
                        question2Fire.particleColor = SKColor.green
                    }
                    // If on the third question
                    else {
                        // Set third question emitter to green
                        question3Fire.particleColor = SKColor.green
                    }
                    
                    // Set panner to take in touch location
                    touchPanner = Panner(note4Player, pan:  panAmount)
                    mixer.addInput(touchPanner) // Add new player to mixer
                    note4Player.play() // Play note sound
                    touchPanner.play() // Play interactive sound player
                }
                // If previous question button is pressed
                else if node.name == "PrevLabel" {
                    // If not on the first question
                    if questionCount != 1 {
                        // Decrement question counter
                        questionCount -= 1
                        // If now on the first question
                        if questionCount == 1 {
                            // Present first question
                            questionLabel?.text = "How are you feeling right now?"
                        }
                        // If now on the second question
                        else if questionCount == 2{
                            // Present second question
                            questionLabel?.text = "How is your day going?"
                        }
                    }
                }
                // If next question button is pressed
                else if node.name == "NextLabel" {
                    // If at the end of the questions
                    if questionCount == 3 {
                        
                        // Fade in prev, next & colour labels, and show results
                        questionLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        prevLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        nextLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        greenLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        blueLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        yellowLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        redLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        resultsLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                        moreInfoLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    }
                    else {
                        // Increment question counter
                        questionCount += 1
                        // If now on the second question
                        if questionCount == 2{
                            // Present second question
                            questionLabel?.text = "How is your day going?"
                        }
                        // If now on the third question
                        else if questionCount == 3{
                            // Present third question
                            questionLabel?.text = "Describe your mood today:"
                        }
                    }
                }
                // If more information button is pressed
                else if node.name == "MoreInfoLabel" {
                    
                    // Hide results and title objects
                    titleLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    resultsLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    beginLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    moreInfoLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Hide emitters
                    question1Fire.alpha = 0.0
                    question2Fire.alpha = 0.0
                    question3Fire.alpha = 0.0
                    
                    // Display more info objects
                    moreInfoBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    returnBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    returnLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                }
                // If return button is pressent
                else if node.name == "ReturnLabel" {
                    
                    // Hide more info objects
                    moreInfoBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    returnBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    returnLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    
                    // Show results objects
                    resultsLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    moreInfoLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    // Show emitters
                    question1Fire.alpha = 1.0
                    question2Fire.alpha = 1.0
                    question3Fire.alpha = 1.0
                }
            }
        }
    }
}
