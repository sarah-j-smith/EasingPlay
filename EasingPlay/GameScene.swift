//
//  GameScene.swift
//  EasingPlay
//
//  Created by Sarah Smith on 11/24/16.
//  Copyright © 2016 Sarah Smith. All rights reserved.
//

import SpriteKit
import GameplayKit
import SpriteKitEasingSwift

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    fileprivate var lastUpdateTime : TimeInterval = 0
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.2
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        let easeTime = 4.0

        let fn = SKEase.getEaseFunction(.curveTypeQuadratic, easeType: .easeTypeInOut)
        let easeFat = SKEase.createFloatTween(2.5, end: 30.0, time: easeTime/2, easingFunction: fn) { (node: SKNode, param: CGFloat) in
            let spinny = node as! SKShapeNode
            spinny.lineWidth = param
        }
        let easeThin = SKEase.createFloatTween(30.0, end: 2.5, time: easeTime/2, easingFunction: fn) { (node: SKNode, param: CGFloat) in
            let spinny = node as! SKShapeNode
            spinny.lineWidth = param
        }

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            let rotate = SKAction.rotate(byAngle: CGFloat(M_PI) * CGFloat(2.0), duration: easeTime)
            let easeFatThin = SKAction.sequence([easeFat, easeThin])
            let rotateAndEase = SKAction.group([rotate, easeFatThin])
            
            spinnyNode.run(SKAction.repeatForever(rotateAndEase))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: easeTime),
                                              SKAction.fadeOut(withDuration: easeTime),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [SKColor.green, SKColor.red, SKColor.orange, SKColor.blue, SKColor.cyan]).first as! SKColor
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
