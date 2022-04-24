//
//  FocusScene.swift
//  Elements
//
//  Created by Matthew Simpson on 10/03/2022.
//

import UIKit
import SpriteKit


class FocusScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        
        // Define return button
        let button = SKSpriteNode(imageNamed: "previousbutton.png")
        button.position = CGPoint(x: 50, y: self.frame.size.height - 50)
        button.name = "previousButton"
        button.setScale(0.5)
        self.addChild(button)
        
        let music = SKAudioNode(fileNamed: "Dream.wav")
        addChild(music)

        music.isPositional = true
        music.position = CGPoint(x: -1024, y: -1024)

        let moveForward = SKAction.moveTo(x: 1024, duration: 2)
        let moveBack = SKAction.moveTo(x: -1024, duration: 2)
        let moveRight = SKAction.moveTo(y: 1024, duration: 2)
        let moveLeft = SKAction.moveTo(y: -1024, duration: 2)
        let sequence = SKAction.sequence([moveForward, moveLeft, moveBack, moveRight])
        let repeatForever = SKAction.repeatForever(sequence)

        music.run(repeatForever)
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
            }
        }
    }
    
}

