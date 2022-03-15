//
//  GameScene.swift
//  Elements
//
//  Created by Matthew Simpson on 02/03/2022.
//

import SpriteKit

class GameScene: SKScene {
    
    private var fire: SKEmitterNode!
    private var smoke: SKEmitterNode!
    
    private var enso : SKSpriteNode?
    private var label : SKLabelNode?
    
    override func didMove(to view: SKView) {

        
        // Initialise properties defined above
        fire = SKEmitterNode(fileNamed: "Fire")
        
        // Set position to be top left of display
        fire.position = CGPoint(x: self.frame.size.width/2 - 50, y: self.frame.size.height/2 + 330)
        
        // Set animation to start a few seconds in
        fire.advanceSimulationTime(5)
        
        // Add animation to display
        self.addChild(fire)
        
        
        smoke = SKEmitterNode(fileNamed: "Smoke")
        
        //smoke.position = CGPoint(x: self.frame.size.width / 2 , y: self.frame.size.height / 2 + 20)
        smoke.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 200)
        
        smoke.advanceSimulationTime(5)
        
        self.addChild(smoke)
        
        self.enso = self.childNode(withName: "ensoNode") as? SKSpriteNode
        if let enso = self.enso {
            enso.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 3)))
        }
        //enso?.name = "Enso"
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "Title") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 3.0))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = nodes(at: location)
               
            for node in nodesArray {
                if node.name == "ensoNode" {
                    let focusScene = FocusScene(fileNamed: "FocusScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    focusScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(focusScene!, transition: transition)
                }
                else if node.name == "Leaves" {
                    let breatheScene = BreatheScene(fileNamed: "BreatheScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    breatheScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(breatheScene!, transition: transition)
                }
                else if node.name == "Trees" {
                    let restScene = RestScene(fileNamed: "RestScene")
                    let transition = SKTransition.crossFade(withDuration: 2.0)
                    restScene?.scaleMode = .aspectFill
                    scene?.view?.presentScene(restScene!, transition: transition)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
