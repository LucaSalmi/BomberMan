//
//  TestEnemy.swift
//  BomberMan
//
//  Created by Daniel Falkedal on 2022-02-15.
//

import Foundation
import GameplayKit

class TestEnemy: Enemy {
    
    //Movement AI logic variables
    var changeDirectionInterval: CGFloat = 0.0
    let tileSize: CGFloat = 32.0  //32 = tile size
    let minIntervalMultiplier: Int = 1
    let maxIntervalMultiplier: Int = 5
    var currentMovementDistance: CGFloat = 0.0
    var direction = CGPoint(x: 0, y: 0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(){
        let texture = SKTexture(imageNamed: "bug_ft1")
        super.init(texture, .white, texture.size())
        name = "Test Enemy"
        
        enemySpeed = 0.5
        difficult = Enemy.superEasy
        direction = getRandomDirection()
        
    }
    
    internal func getRandomDirection() -> CGPoint {
        var newDirection = CGPoint(x: 0, y: 0)
        
        let moveSideways: Bool = Bool.random()
        if moveSideways {
            newDirection.x = 1
        }
        else {
            newDirection.y = 1
        }
        
        let invertDirection: Bool = Bool.random()
        if invertDirection {
            newDirection.x *= -1
            newDirection.y *= -1
        }
        
        //set random move distance based on tile size and a random multiplier within limits
        let intervalMultiplier: Int = Int.random(in: minIntervalMultiplier...maxIntervalMultiplier)
        changeDirectionInterval = tileSize * CGFloat(intervalMultiplier)
        currentMovementDistance = 0 //reset move distance after changing direction
        
        return newDirection
    }
    
    private func updateDirection(newDirection: CGPoint) {
        
        guard let backgroundMap = scene!.childNode(withName: "background")as? SKTileMapNode else {
            return
        }
        let center = PhysicsUtils.findCenterOfClosestTile(map: backgroundMap, object: self)
        if center != nil {
            self.position = center!
        }
        
        direction = newDirection
    }
    
    override func collision(with other: SKNode?) {
        super.collision(with: other)
        
        let oldDirection = direction
        var newDirection = direction
        //loop until the new direction is different from the old direction
        while newDirection == oldDirection {
            newDirection = getRandomDirection()
        }
        updateDirection(newDirection: newDirection)
    }
    
    override func update() {
        
        position.x += (direction.x * enemySpeed)
        position.y += (direction.y * enemySpeed)
        
        currentMovementDistance += enemySpeed
        if currentMovementDistance == changeDirectionInterval {
            updateDirection(newDirection: getRandomDirection())
        }
        
    }
    
}
