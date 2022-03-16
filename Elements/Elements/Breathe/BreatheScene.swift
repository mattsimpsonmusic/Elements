//
//  BreatheScene.swift
//  Elements
//
//  Created by Matthew Simpson on 15/03/2022.
//

import UIKit
import SpriteKit


class BreatheScene: SKScene {
    
    
    private var emitter: SKEmitterNode!
    
    //let emitter = SKEmitterNode(fileNamed: "Squares.sks")
    let colors = [SKColor.red, SKColor.green, SKColor.blue]
    var lastUpdateTime: TimeInterval?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        let button = SKSpriteNode(imageNamed: "previousbutton.png")
        button.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 200)
        button.name = "previousButton"
        
        self.addChild(button)
        
        emitter = SKEmitterNode(fileNamed: "Squares")
        
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        emitter.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(emitter)
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
                else if node.name == "YellowLabel" {
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
                }
            }
        }
    }
    
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
    
}
