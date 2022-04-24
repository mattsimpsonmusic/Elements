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
    
    // Define audio engine, players and mixer
    var player: AudioPlayer!   // Declare an AudioPlayer for setting up later
    var engine = AudioEngine()
    
    // Define emitters
    private var emitter: SKEmitterNode!
    
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
    
    // Define counter variable
    private var questionCount = 0
    
    
    // Define colours
    let colors = [SKColor.red, SKColor.green, SKColor.blue]
    
    // Define time interval
    var lastUpdateTime: TimeInterval?
    
    
    
    override func didMove(to view: SKView) {
        
        // Set up the audio file and link it to the player
        let filePath = Bundle.main.path(forResource: "Fire.mp3", ofType: nil)!
        let fileURL = URL(fileURLWithPath: filePath)
        player = AudioPlayer(url:fileURL)
        // Set volume
        player.volume = 0.4
        // Loop player
        player.isLooping = true     // Loop playback until stopped
        
        engine.output = player
        try!engine.start()
        player.play()
        
        // Set background colour
        backgroundColor = SKColor(red: 0.15, green:0.2, blue:0.3, alpha: 1.0)
        
        // Define return button
        let button = SKSpriteNode(imageNamed: "previousbutton.png")
        button.position = CGPoint(x: 50, y: self.frame.size.height - 50)
        button.name = "previousButton"
        button.setScale(0.5)
        self.addChild(button)
        
        // Fade in title
        titleLabel = self.childNode(withName: "TitleLabel") as? SKLabelNode
        titleLabel?.alpha = 0.0
        titleLabel?.run(SKAction.fadeIn(withDuration: 3.0))
        
        // Fade in Results label
        questionLabel = self.childNode(withName: "QuestionLabel") as? SKLabelNode
        questionLabel?.alpha = 0.0
        questionLabel?.run(SKAction.fadeIn(withDuration: 3.0))
        
        // Fade in begin message
        beginLabel = self.childNode(withName: "BeginLabel") as? SKLabelNode
        beginLabel?.alpha = 0.0
        beginLabel?.run(SKAction.fadeIn(withDuration: 3.0))
        
        
        // Set other labels to be invisible
        nextLabel = self.childNode(withName: "NextLabel") as? SKLabelNode
        prevLabel = self.childNode(withName: "PrevLabel") as? SKLabelNode
        blueLabel = self.childNode(withName: "BlueLabel") as? SKLabelNode
        redLabel = self.childNode(withName: "RedLabel") as? SKLabelNode
        greenLabel = self.childNode(withName: "GreenLabel") as? SKLabelNode
        yellowLabel = self.childNode(withName: "YellowLabel") as? SKLabelNode
        nextLabel?.alpha = 0.0
        prevLabel?.alpha = 0.0
        blueLabel?.alpha = 0.0
        redLabel?.alpha = 0.0
        greenLabel?.alpha = 0.0
        yellowLabel?.alpha = 0.0
        
        // Add fire
        emitter = SKEmitterNode(fileNamed: "Fire")
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        emitter.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(emitter)
        
        // Get label node from scene and store it for use later
        /*self.questionLabel = self.childNode(withName: "QuestionLabel") as? SKLabelNode
        if let label = self.questionLabel {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 3.0))
        }*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
         
            for node in nodesarray {
                if node.name == "previousButton" {
                    let firstScene = GameScene(fileNamed: "GameScene")
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    firstScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(firstScene!, transition: transition)
                }
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
                    
                    questionCount += 1
                    questionLabel?.text = "Question \(questionCount)"
                    
                } else if node.name == "YellowLabel" {
                    emitter.particleColor = SKColor.yellow
                }
                else if node.name == "BlueLabel" {
                    emitter.particleColor = SKColor.blue
                }
                else if node.name == "RedLabel" {
                    emitter.particleColor = SKColor.red
                }
                else if node.name == "GreenLabel" {
                    emitter.particleColor = SKColor.green
                } else if node.name == "PrevLabel" {
                    if questionCount != 1 {
                        questionCount -= 1
                        questionLabel?.text = "Question \(questionCount)"
                    }
                } else if node.name == "NextLabel" {
                    if questionCount == 3 {
                        questionLabel?.text = "Results"
                        
                        // Fade in prev, next & colour labels
                        prevLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        nextLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        greenLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        blueLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        yellowLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        redLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                        
                    } else {
                        questionCount += 1
                        questionLabel?.text = "Question \(questionCount)"
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
         
            for node in nodesarray {
                if node.name == "previousButton" {
                    let firstScene = GameScene(fileNamed: "GameScene")
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    firstScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(firstScene!, transition: transition)
                }
                else if node.name == "YellowLabel" {
                    emitter.particleColor = SKColor.yellow
                    beginLabel?.run(SKAction.fadeIn(withDuration: 3.0))
                }
                else if node.name == "BlueLabel" {
                    emitter.particleColor = SKColor.blue
                }
                else if node.name == "RedLabel" {
                    emitter.particleColor = SKColor.red
                }
                else if node.name == "GreenLabel" {
                    emitter.particleColor = SKColor.green
                }
                else if node.name == "QuestionLabel" {
                    if questionCount == 1{
                        questionLabel?.text = "Question 2"
                        questionCount += 1
                    }
                    else if questionCount == 2{
                        questionLabel?.text = "Question 3"
                        questionCount += 1
                    }
                    else{
                        questionLabel?.text = "Results"
                    }
                }
                
            }
        }
    }
    
    */
    
    
    /*
    // Update function to periodically change the flame to a random colour
    override func update(_ currentTime: TimeInterval) {
        var delta = TimeInterval()
        if let last = lastUpdateTime {
            delta = currentTime - last
        } else {
            delta = currentTime
        }
        if delta > 1.0 {
            lastUpdateTime = currentTime
            let random = Int(arc4random_uniform(UInt32(self.colors.count)))
            emitter.particleColor = colors[random]
        }
    }
    */
    
}
