//
//  FocusScene.swift
//  Elements
//
//  Created by Matthew Simpson on 10/03/2022.
//

import UIKit
import SpriteKit

class FocusScene: SKScene, UITextFieldDelegate {
    
    // Define background images
    let startBackground = SKSpriteNode(imageNamed: "FocusBackground.png")
    let viewBackground = SKSpriteNode(imageNamed: "ItemBackground.png")
    let addItemBackground = SKSpriteNode(imageNamed: "AddItemBackground.png")
    
    // Define particle emitters
    private var smoke: SKEmitterNode!
    
    // Define text boxes
    private var returnButtonBox : SKSpriteNode?
    private var itemBox : SKSpriteNode?
    private var addStoneBox : SKSpriteNode?
    private var stoneDescriptionBox: SKSpriteNode?
    
    // Define text buttons & labels
    private var title : SKLabelNode?
    private var viewButton : SKLabelNode?
    private var addItemButton : SKLabelNode?
    private var returnButton : SKLabelNode?
    private var addStoneLabel : SKLabelNode?
    private var redButtonLabel : SKLabelNode?
    private var blueButtonLabel : SKLabelNode?
    private var greenButtonLabel : SKLabelNode?
    private var priority1 : SKLabelNode?
    private var priority2 : SKLabelNode?
    private var priority3 : SKLabelNode?
    private var stoneLabel : SKLabelNode?
    private var stoneDescriptionLabel : SKLabelNode?
    
    // Define shape for task (stone)
    var shape = SKShapeNode()
    
    // Define counters, variables and conditions
    var viewCounter = 1 // Counter to transition between views
    var stoneExists = 0 // Condition for if a task has been created
    var stoneName = "" // Variable to store task name
    var stoneColour = SKColor.blue // Variable to store task colour
    var stonePriority  = 1 // Variable to store task priority
    var stoneNotes = "" // Varuiable to store task notes
    
    // Define text fields to store use input
    var taskTitle = UITextField(frame: CGRect(x: 160, y: 285, width: 100, height: 50)) // Input for task name
    var taskNotes = UITextField(frame: CGRect(x: 160, y: 685, width: 100, height: 50)) // Input for task notes
    
    
    override func didMove(to view: SKView) {
        
        // Initialise backgrounds
       
        // Start background
        startBackground.zPosition = -1 // Set position behind everything else
        startBackground.scale(to: self.size) // Scale to display
        startBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        self.addChild(startBackground) // Add background image to scene
        
        // Item background
        viewBackground.zPosition = -1 // Set position behind everything else
        viewBackground.scale(to: self.size) // Scale to display
        viewBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        viewBackground.alpha = 0.0 // Set to be hidden initially
        self.addChild(viewBackground) // Add background to scene
        
        // Add Item background
        addItemBackground.zPosition = -1 // Set position behind everything else
        addItemBackground.scale(to: self.size) // Scale to display
        addItemBackground.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2) // Place background in middle of scene
        addItemBackground.alpha = 0.0 // Set to be hidden initially
        self.addChild(addItemBackground) // Add background to scene
        
        // Particle emitter
        smoke = SKEmitterNode(fileNamed: "GreySmoke") // Initialise emitter
        smoke.position = CGPoint(x: self.frame.size.width/2 + 65, y: self.frame.size.height - 157) // Place location
        smoke.zPosition = -1 // Set to be behind labels
        self.addChild(smoke) // Add to scene
        
        // Button to return to main home screen
        let button = SKSpriteNode(imageNamed: "leaf.png") // Initialise node
        button.position = CGPoint(x: 50, y: self.frame.size.height - 70) // Set position
        button.name = "previousButton" // Set name
        button.setScale(0.20) // Set size
        self.addChild(button) // Add button to scene
        
        // Theme selection box
        returnButtonBox = self.childNode(withName: "ReturnButtonBox") as? SKSpriteNode // Initialise node
        returnButtonBox?.alpha = 0.0 // Set visibility to hidden
        
        // Add stone box
        addStoneBox = self.childNode(withName: "AddStoneBox") as? SKSpriteNode
        addStoneBox?.alpha = 0.0
        
        // Theme selection box
        itemBox = self.childNode(withName: "ItemInfoBox") as? SKSpriteNode // Initialise node
        itemBox?.alpha = 0.0 // Set visibility to hidden
        itemBox?.color = SKColor.clear
    
        // Stone button
        stoneLabel = self.childNode(withName: "Stone") as? SKLabelNode // Initialise node
        stoneLabel?.alpha = 0.0 // Set visibility to hidden
        
        stoneDescriptionLabel = self.childNode(withName: "StoneDescriptionLabel") as? SKLabelNode // Initialise node
        stoneDescriptionLabel?.alpha = 0.0 // Set visibility to hidden
        
        // Theme button
        title = self.childNode(withName: "TitleLabel") as? SKLabelNode // Initialise node
        title?.alpha = 0.0 // Set visibility to hidden
        title?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // View items button
        viewButton = self.childNode(withName: "CurrentLabel") as? SKLabelNode // Initialise node
        viewButton?.alpha = 0.0 // Set visibility to hidden
        viewButton?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Add item button
        addItemButton = self.childNode(withName: "NewItemLabel") as? SKLabelNode // Initialise node
        addItemButton?.alpha = 0.0 // Set visibility to hidden
        addItemButton?.run(SKAction.fadeIn(withDuration: 3.0)) // Fade in
        
        // Return button
        returnButton = self.childNode(withName: "ReturnLabel") as? SKLabelNode // Initialise node
        //returnButton?.alpha = 0.0 // Set visibility to hidden
        
        // Other buttons and labels
        redButtonLabel = self.childNode(withName: "RedButton") as? SKLabelNode
        blueButtonLabel = self.childNode(withName: "BlueButton") as? SKLabelNode
        greenButtonLabel = self.childNode(withName: "GreenButton") as? SKLabelNode
        priority1 = self.childNode(withName: "PriorityOneButton") as? SKLabelNode
        priority2 = self.childNode(withName: "PriorityTwoButton") as? SKLabelNode
        priority3 = self.childNode(withName: "PriorityThreeButton") as? SKLabelNode
        addStoneLabel = self.childNode(withName: "AddStoneLabel") as? SKLabelNode
        
        // Set visibility to hidden
        addStoneLabel?.alpha = 0.0
        redButtonLabel?.alpha = 0.0
        blueButtonLabel?.alpha = 0.0
        greenButtonLabel?.alpha = 0.0
        priority1?.alpha = 0.0
        priority2?.alpha = 0.0
        priority3?.alpha = 0.0
        
        // Initialise shape for task
        shape.path = UIBezierPath(ovalIn: CGRect(x: -128, y: -128, width: 256, height: 100)).cgPath // Create oval
        shape.position = CGPoint(x: frame.midX, y: frame.midY) // Set position
        shape.fillColor = UIColor.clear // Set fill colour
        shape.strokeColor = UIColor.lightGray // Set border coloue
        shape.lineWidth = 7 // Set border width
        shape.alpha = 0.0 // Set visibility to hidden
        self.addChild(shape) // Add shape to scene
        
        // Task notes box
        stoneDescriptionBox = self.childNode(withName: "StoneDescription") as? SKSpriteNode // Initialise node
        stoneDescriptionBox?.alpha = 0.0 // Set visibility to hidden
        
        // Initialise audio functionality
        let music = SKAudioNode(fileNamed: "Dream.wav") // Connect audio file to variabe
        addChild(music) // Add to scene
        music.isPositional = true // Allow movement
        music.position = CGPoint(x: -1024, y: -1024) // Set initial position
        let moveForward = SKAction.moveTo(x: 1024, duration: 2) // Create forward movement action
        let moveBack = SKAction.moveTo(x: -1024, duration: 2) // Create backward movement action
        let moveRight = SKAction.moveTo(y: 1024, duration: 2) // Create movement action to the right
        let moveLeft = SKAction.moveTo(y: -1024, duration: 2) // Create movement action to the left
        let sequence = SKAction.sequence([moveForward, moveLeft, moveBack, moveRight]) // Create movement sequence
        let repeatForever = SKAction.repeatForever(sequence) // Create endless movement sequence
        music.run(repeatForever) // Assign sequence to music
        
        
        // Text Inputs
        
        // Task title
        taskTitle.borderStyle = UITextField.BorderStyle.roundedRect // Make border a rounded rectangle
        taskTitle.textColor = SKColor.white // Set text colour to white
        taskTitle.placeholder = "Enter your name here" // Set initial text in display
        taskTitle.autocorrectionType = UITextAutocorrectionType.yes // Allow autocorrection
        taskTitle.backgroundColor = SKColor.darkGray // Set background colour of text box
        taskTitle.clearButtonMode = UITextField.ViewMode.whileEditing // Set to clear text when editing
        taskTitle.autocapitalizationType = UITextAutocapitalizationType.none // Allow case sensitivity
        taskTitle.delegate = self // Assign text box to scene delegate
        taskTitle.returnKeyType = .done // Change return key to display "done"
        taskTitle.alpha = 0.0 // Set visibility to hidden
        self.view!.addSubview(taskTitle) // Add to scene
        
        // Task notes
        taskNotes.borderStyle = UITextField.BorderStyle.roundedRect // Make border a rounded rectangle
        taskNotes.textColor = SKColor.white // Set text colour to white
        taskNotes.placeholder = "Enter your name here" // Set initial text in display
        taskNotes.autocorrectionType = UITextAutocorrectionType.yes // Allow autocorrection
        taskNotes.backgroundColor = SKColor.darkGray // Set background colour of text box
        taskNotes.clearButtonMode = UITextField.ViewMode.whileEditing // Set to clear text when editing
        taskNotes.autocapitalizationType = UITextAutocapitalizationType.none // Allow case sensitivity
        taskNotes.delegate = self // Assign text box to scene delegate
        taskNotes.returnKeyType = .done // Change return key to display "done"
        taskNotes.alpha = 0.0 // Set visibility to hidden
        self.view!.addSubview(taskNotes) // Add to scene
    }
    
    // Function to release control of text editors upon pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTitle.resignFirstResponder() // Release control of text field
        taskNotes.resignFirstResponder() // Release control of text field
        return true // Return success
    }
    
    // Function for when a touch is registered on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If there is a touch on the screen
        if let touch = touches.first {
            // Get the location of the touch
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location) // Gets every interactive feature on the screen in touch location
         
            // For every object within the touch
            for node in nodesarray {
                // If the home button is pressed
                if node.name == "previousButton" {
                    // Create new instance of home screen
                    let firstScene = GameScene(fileNamed: "GameScene")
                    // Create transition
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    // Scale scene to fit screen
                    firstScene?.scaleMode = .aspectFill
                    // Perform trasition between scenes
                    scene?.view?.presentScene(firstScene!, transition: transition)
                }
                // If the 'View current item' button is pressed
                else if node.name == "CurrentLabel" {
                    // Set view counter to 1
                    viewCounter = 1
                    // Swap backgrounds
                    startBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    viewBackground.run(SKAction.fadeIn(withDuration: 2.0))
                    // Hide emitter
                    smoke.alpha = 0.0
                    // Hide home screen labels
                    title?.run(SKAction.fadeOut(withDuration: 2.0))
                    viewButton?.run(SKAction.fadeOut(withDuration: 2.0))
                    addItemButton?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Show return label
                    returnButtonBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    
                    // If a task has been created
                    if stoneExists == 1 {
                        shape.alpha = 1.0 // Show the stone shape
                        shape.strokeColor = stoneColour // Set task colour
                        stoneLabel?.text = stoneName // Set task name
                        stoneLabel?.alpha = 1.0 // Show task title on screen
                    }
                }
                // If the 'Return to main screen' button is pressed
                else if node.name == "ReturnLabel" {
                    // Swap backgrounds
                    // Condition to transition from view tasks section
                    if viewCounter == 1 {
                        viewBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                    // Condition to transition from add tasks section
                    else {
                        addItemBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                    // Add original background back in
                    startBackground.run(SKAction.fadeIn(withDuration: 2.0))
                    // Show emitter
                    smoke.alpha = 1.0
                    // Show home screen labels
                    title?.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in title button
                    viewButton?.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in view items button
                    addItemButton?.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in add item button
                    returnButtonBox?.run(SKAction.fadeOut(withDuration: 2.0)) // Hide return label
                    itemBox?.run(SKAction.fadeOut(withDuration: 2.0)) // Hide item box
                    // Set text fields to be hidden
                    taskTitle.alpha = 0.0
                    taskNotes.alpha = 0.0
                    // Fade out colour buttons
                    redButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    blueButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    greenButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Fade out priority buttons
                    priority1?.run(SKAction.fadeOut(withDuration: 2.0))
                    priority2?.run(SKAction.fadeOut(withDuration: 2.0))
                    priority3?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Fade out add stone information
                    addStoneBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    addStoneLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    
                    // If a task has been added
                    if stoneExists == 1 {
                        // Hide task information
                        stoneLabel?.alpha = 0.0
                        stoneDescriptionLabel?.alpha = 0.0
                        shape.alpha = 0.0
                        stoneDescriptionBox?.run(SKAction.fadeOut(withDuration: 2.0))
                        stoneDescriptionLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                }
                // If the button has been pressed to add a new item
                else if node.name == "NewItemLabel" {
                    // Set view counter to 0
                    viewCounter = 0
                    // Swap backgrounds
                    startBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    addItemBackground.run(SKAction.fadeIn(withDuration: 2.0))
                    // Hide emitter
                    smoke.alpha = 0.0
                    // Hide home screen labels
                    title?.run(SKAction.fadeOut(withDuration: 2.0))
                    viewButton?.run(SKAction.fadeOut(withDuration: 2.0))
                    addItemButton?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Show return label
                    returnButtonBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    itemBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    taskTitle.alpha = 1.0
                    taskNotes.alpha = 1.0
                    // Show colour and priority buttons
                    redButtonLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    blueButtonLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    greenButtonLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                    priority1?.run(SKAction.fadeIn(withDuration: 2.0))
                    priority2?.run(SKAction.fadeIn(withDuration: 2.0))
                    priority3?.run(SKAction.fadeIn(withDuration: 2.0))
                    // Show add stone information
                    addStoneBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    addStoneLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                }
                // If the red colour button is pressed
                else if node.name == "RedButton" {
                    stoneColour = SKColor.red // Set stone colour to red
                    redButtonLabel?.fontColor = SKColor.blue // Highlight red button
                    blueButtonLabel?.fontColor = SKColor.white // Reset blue button
                    greenButtonLabel?.fontColor = SKColor.white // Reset green button
                }
                // If the blue colour button is pressed
                else if node.name == "BlueButton" {
                    stoneColour = SKColor.blue // Set stone colour to blue
                    redButtonLabel?.fontColor = SKColor.white // Reset red button
                    blueButtonLabel?.fontColor = SKColor.blue // Highlight blue button
                    greenButtonLabel?.fontColor = SKColor.white // Reset green button
                }
                // If the green colour button is pressed
                else if node.name == "GreenButton" {
                    stoneColour = SKColor.green // Set stone colour to green
                    redButtonLabel?.fontColor = SKColor.white // Reset red button
                    blueButtonLabel?.fontColor = SKColor.white // Reset blue button
                    greenButtonLabel?.fontColor = SKColor.blue // Highlight green button
                }
                // If the first priority button is pressed
                else if node.name == "PriorityOneButton" {
                    stonePriority = 1 // Set stone priority counter
                    priority1?.fontColor = SKColor.blue // Highlight priority button
                    priority2?.fontColor = SKColor.white // Reset priority button
                    priority3?.fontColor = SKColor.white // Reset priority button
                }
                // If the second priority button is pressed
                else if node.name == "PriorityTwoButton" {
                    stonePriority = 2 // Set stone priority counter
                    priority1?.fontColor = SKColor.white // Reset priority button
                    priority2?.fontColor = SKColor.blue // Highlight priority button
                    priority3?.fontColor = SKColor.white // Reset priority button
                }
                // If the third priority button is pressed
                else if node.name == "PriorityThreeButton" {
                    stonePriority = 3 // Set stone priority counter
                    priority1?.fontColor = SKColor.white // Reset priority button
                    priority2?.fontColor = SKColor.white // Reset priority button
                    priority3?.fontColor = SKColor.blue // Highlight priority button
                }
                // If the add stone button is pressed
                else if node.name == "AddStoneLabel" {
                    
                    stoneName = taskTitle.text ?? "" // Set text field name
                    stoneNotes = taskNotes.text ?? "" // Set text notes
                    addItemButton?.text = "Change Stone" // Change add item label text to change stone
                    addStoneLabel?.text = "Update" // Change add stone label to update stone
                    
                    // Swap backgrounds
                    
                    // Condition to swap from view background
                    if viewCounter == 1 {
                        // Fade out view background
                        viewBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                    // Condition to swap from add item background
                    else {
                        // Fade out add item background
                        addItemBackground.run(SKAction.fadeOut(withDuration: 2.0))
                    }
                    // Add start background
                    startBackground.run(SKAction.fadeIn(withDuration: 2.0))
                    // Show emitter
                    smoke.alpha = 1.0
                    // Show home screen labels
                    title?.run(SKAction.fadeIn(withDuration: 2.0))
                    viewButton?.run(SKAction.fadeIn(withDuration: 2.0))
                    addItemButton?.run(SKAction.fadeIn(withDuration: 2.0))
                    // Hide return label
                    returnButtonBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    itemBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    taskTitle.alpha = 0.0
                    taskNotes.alpha = 0.0
                    // Add colour and priotity buttons
                    redButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    blueButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    greenButtonLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    priority1?.run(SKAction.fadeOut(withDuration: 2.0))
                    priority2?.run(SKAction.fadeOut(withDuration: 2.0))
                    priority3?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Fade in add stone information
                    addStoneBox?.run(SKAction.fadeOut(withDuration: 2.0))
                    addStoneLabel?.run(SKAction.fadeOut(withDuration: 2.0))
                    // Set stone exists condition to true
                    stoneExists = 1
                }
                // If the stone button is pressed
                else if node.name == "Stone" {
                    // Show the stone description
                    stoneDescriptionLabel?.text = stoneNotes
                    stoneDescriptionBox?.run(SKAction.fadeIn(withDuration: 2.0))
                    stoneDescriptionLabel?.run(SKAction.fadeIn(withDuration: 2.0))
                }
            }
        }
    }
    
}
