//
//  Explosion.swift
//  BomberMan
//
//  Created by Luca Salmi, Daniel Falkedal, Calle Höglund, Hampus Brandtman on 2022-02-18.
//

import Foundation
import SpriteKit

enum ExplosionSettings{
    
    static var range: Int = 1
    static var size: Int = 5
    static var distancePos: CGFloat = 32
    static var distanceNeg: CGFloat = -32
    static var permanence: Int = 30
    static var explosionsArray: [Explosion] = []
    static var explosionId: Int = 0
}

class Explosion: SKSpriteNode{
    
    static let physicsBodyPct = CGFloat(0.85)
    var count: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint){
        
        let texture = SKTexture(imageNamed: "explosion1")
        let size: CGSize = GameScene.tileSize ?? CGSize(width: 32, height: 32)
        super.init(texture: texture, color: .white, size: size)
        self.position = position
        zPosition = 50
        name = "Explosion\(ExplosionSettings.explosionId)"
        ExplosionSettings.explosionId += 1
        
    }
    
    func createPhysicsBody(){
        
        physicsBody = SKPhysicsBody(circleOfRadius: (size.width/2) * Explosion.physicsBodyPct)
        //physicsBody = SKPhysicsBody(rectangleOf: GameScene.tileSize ?? CGSize(width: 32, height: 32))
        physicsBody?.categoryBitMask = PhysicsCategory.Explosion
        physicsBody?.collisionBitMask = PhysicsCategory.All
        physicsBody?.contactTestBitMask = PhysicsCategory.All
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = false
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
    }
    
    func update(){
       
        count += 1
        
        if count == 1{
            createPhysicsBody()
        }
        
        if count >= ExplosionSettings.permanence{
            
            count = 0
            self.removeFromParent()
            ExplosionSettings.explosionsArray.remove(at: ExplosionSettings.explosionsArray.firstIndex(of: self)!)
        }
        
    }
}