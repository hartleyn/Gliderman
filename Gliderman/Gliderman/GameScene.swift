//
//  GameScene.swift
//  Gliderman
//
//  Created by Nicholas Hartley on 12/16/16.
//  Copyright © 2016 Nicholas Hartley. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    // NODE DECLARATIONS
    
    
    // gliderMan
    
    var gliderMan:SKSpriteNode!
    
    
    // background
    
    var starSetting:SKEmitterNode!
   
    
    // Possible Buildings Array
    
    var possibleBuildings = ["building", "building2", "building3", "building4", "building5"]
    
    
    // Score and Score Label
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // NODE DECLARATIONS END
    
    
    // MOTION SETUP
    
    let motionManager = CMMotionManager()
    var yAcceleration:CGFloat = 0;
    
    
    // PHYSICS CATEGORY STRUCT
    
    struct PhysicsCategory {
        
        static let None : UInt32 = 0      // 0
        static let Border : UInt32 = 0b1  // 1
        static let Glider : UInt32 = 0b10 // 2
        
    }
    
    // Screen Boundaries
    
    let screenWidth:CGFloat = UIScreen.main.bounds.height
    let screenHeight:CGFloat = UIScreen.main.bounds.width
    
    
    override func didMove(to view: SKView) {
        
        
        // Set Scene Anchor Point to (0, 0)
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        // PHYSICS SETUP
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -10)
        self.physicsWorld.contactDelegate = self
        
        // Motion
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
            
               
                
                self.yAcceleration = CGFloat(acceleration.y) * 0.50 + self.yAcceleration * 0.25
            }
            
        }
        
        
        // Scene Physics Body
        
        let scenePhysics = SKPhysicsBody(edgeLoopFrom: self.frame)
        scenePhysics.friction = 0
        
        
        // Attach Physics Body to Scene and Set Physics Attributes
        
        self.physicsBody = scenePhysics
        self.physicsBody?.categoryBitMask = PhysicsCategory.Border
        self.physicsBody?.collisionBitMask = PhysicsCategory.Glider
        
        
        // Setting Attributes for gliderMan
        
        gliderMan = SKSpriteNode(imageNamed: "Spaceship")
        gliderMan.size = CGSize(width: screenWidth * 0.08, height: screenHeight * 0.15)
        gliderMan.position = CGPoint(x: screenWidth * 0.1, y: screenHeight * 0.5)
        gliderMan.zPosition = 100 // Always closest element
        // Set Up gliderMan Physics
        gliderMan.physicsBody = SKPhysicsBody(rectangleOf: gliderMan.size)
        gliderMan.physicsBody?.isDynamic = true
        gliderMan.physicsBody?.affectedByGravity = true
        gliderMan.physicsBody?.restitution = 0
        gliderMan.physicsBody?.linearDamping = 25
        gliderMan.physicsBody?.categoryBitMask = PhysicsCategory.Glider
        gliderMan.physicsBody?.collisionBitMask = PhysicsCategory.Border
        self.addChild(gliderMan)
        
        
        // Setting Attributes for starSetting
        
        starSetting = SKEmitterNode(fileNamed: "Starfield.sks")
        starSetting.position = CGPoint(x: UIScreen.main.bounds.height / 2, y: UIScreen.main.bounds.width / 2)
        starSetting.zPosition = -100 // Always furthest element
        starSetting.advanceSimulationTime(10)
        self.addChild(starSetting)
        
        
        // Setting Attributes for Score Label
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 12
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.height * 0.9, y: UIScreen.main.bounds.width * 0.1)
        score = 0
        self.addChild(scoreLabel)
        
        
        
        
        
    }
    
    
    override func didSimulatePhysics() {
        
        gliderMan.position.y += yAcceleration * 5
        
        if gliderMan.position.y > screenHeight {
            gliderMan.position.y = screenHeight - 20
        }
        else if gliderMan.position.x > screenWidth {
            gliderMan.position.x = screenWidth - 20
        }
    }
    
}












