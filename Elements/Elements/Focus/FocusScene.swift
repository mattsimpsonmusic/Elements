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
        let button = SKSpriteNode(imageNamed: "previousbutton.png")
        button.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        button.name = "previousButton"
        
        self.addChild(button)
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
