//
//  GameScene.swift
//  BomberMan
//
//  Created by Luca Salmi, Daniel Falkedal, Calle Höglund, Hampus Brandtman on 2022-02-15.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    static var viewController: GameViewController? = nil
    static var tileSize: CGSize? = nil
    
    var leftUI: SKSpriteNode? = nil
    var rightUI: SKSpriteNode? = nil
    
    var bombsNode = SKNode()
    var explosionsNode: SKNode? = SKNode()
    var actionManager: ActionManagager!
    var backgroundMap: SKTileMapNode?
    
    var enemyNode: SKNode? = SKNode()
    var breakablesNode: SKNode? = SKNode()
    var obstaclesNode: SKNode? = SKNode()
    var player: Player? = nil
    
    var movementManager: MovementManager? = nil
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundMap = (childNode(withName: "background") as! SKTileMapNode)
        addChild(bombsNode)
        addChild(explosionsNode!)
        
    }
    
    override func didMove(to view: SKView) {
        
        setupWorldPhysics()
        setupObstaclesPhysics()
        setupBreakablesPhysics()
        setupEnemiesPhysics()
        setupPlayer()
        setupCamera()
        movementManager = MovementManager(self)
        actionManager = ActionManagager(self, camera!)
    }
    
    
    
    override func sceneDidLoad() {
        
        
    
    }
    
    func setupCamera(){
        
        let camera = Player.camera!
        
        leftUI = (camera.childNode(withName: "leftUI") as! SKSpriteNode)
        rightUI = (camera.childNode(withName: "rightUI") as! SKSpriteNode)
      
        let zeroDistance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(zeroDistance, to: player!)

        let xInset = min((view?.bounds.width)!/2*camera.xScale, backgroundMap!.frame.width/2)
        let yInset = min((view?.bounds.height)!/2*camera.yScale, backgroundMap!.frame.height/2)

        let constrainRect = backgroundMap!.frame.insetBy(dx: xInset, dy: yInset)

        let xRange = SKRange(lowerLimit: constrainRect.minX, upperLimit: constrainRect.maxX)
        let yRange = SKRange(lowerLimit: constrainRect.minY, upperLimit: constrainRect.maxY)

        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundMap

        camera.constraints = [playerConstraint, edgeConstraint]

        camera.removeFromParent()
        self.camera = camera
        addChild(camera)
    }
    
    func setupWorldPhysics(){
        backgroundMap!.physicsBody = SKPhysicsBody(edgeLoopFrom: backgroundMap!.frame)
        backgroundMap!.physicsBody?.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.contactDelegate = self
    }
    
    func setupBreakablesPhysics(){
        
        guard let breakablesTileMap = childNode(withName: "breakables")as? SKTileMapNode else {
            return
        }

        for row in 0..<breakablesTileMap.numberOfRows{
            for column in 0..<breakablesTileMap.numberOfColumns{
                
                guard let tile = tile(in: breakablesTileMap, at: (column, row)) else {continue}
                GameScene.tileSize = tile.size
                guard tile.userData?.object(forKey: "breakable") != nil else {continue}
                
                var breakable: BreakableObject
                //eventualy different types of breakable obj???
                if tile.userData?.value(forKey: "breakable") as! Bool == true{
                    
                    breakable = BreakableObject()
                    
                }else{
                    
                    breakable = BreakableObject()
                }
                
                breakable.createPhysicsBody(tile: tile)
                breakable.position = breakablesTileMap.centerOfTile(atColumn: column, row: row)
                
                breakablesNode!.addChild(breakable)
                
            }
        }
        
        breakablesNode!.name = "BreakableObjects"
        addChild(breakablesNode!)
        breakablesTileMap.removeFromParent()
    }
    
    
    func setupObstaclesPhysics(){
        guard let obstaclesTileMap = childNode(withName: "obstacles")as? SKTileMapNode else {
            return
        }

        for row in 0..<obstaclesTileMap.numberOfRows{
            for column in 0..<obstaclesTileMap.numberOfColumns{
                
                guard let tile = tile(in: obstaclesTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "obstacle") != nil else {continue}
                
                var obstacle: ObstacleObject
                if tile.userData?.value(forKey: "obstacle") as! Bool == true{
                    
                    obstacle = ObstacleObject()
                    
                }else{
                    
                    obstacle = ObstacleObject()
                }
                
                obstacle.createPhysicsBody(tile: tile)
                obstacle.position = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
                
                obstaclesNode!.addChild(obstacle)
            }
        }
        
        obstaclesNode!.name = "ObstaclesObjects"
        addChild(obstaclesNode!)
        obstaclesTileMap.removeFromParent()
    }
    
    func setupEnemiesPhysics() {
        
        guard let enemiesMap = childNode(withName: "enemies") as? SKTileMapNode else {
            return
        }
        
        for row in 0..<enemiesMap.numberOfRows {
            for column in 0..<enemiesMap.numberOfColumns {
                
                guard let tile = tile(in: enemiesMap, at: (column, row)) else {
                    continue
                }
                
                if tile.userData?.object(forKey: "enemyType") != nil {
                    
                    let value = tile.userData?.value(forKey: "enemyType") as! String
                    
                    var enemy: Enemy
                    
                    if value == "rushEnemy" {
                        enemy = RushEnemy()

                    }
                    else {
                        enemy = TestEnemy()
                    }
                
                    enemy.position = enemiesMap.centerOfTile(atColumn: column, row: row)
                    Enemy.enemies.append(enemy)
                    enemyNode!.addChild(enemy)
                    
                }
            }
        }
        
        enemyNode!.name = "Enemies"
        addChild(enemyNode!)
        
        enemiesMap.removeFromParent()
    }
    
    private func setupPlayer() {
        
        guard let playerMap = childNode(withName: "player") as? SKTileMapNode else {
            return
        }
        
        
        for row in 0..<playerMap.numberOfRows {
            for column in 0..<playerMap.numberOfColumns {
                
                guard let tile = tile(in: playerMap, at: (column, row)) else {
                    continue
                }
                
                if tile.userData?.object(forKey: "player") != nil {
                
                    player = Player()
                    player!.position = playerMap.centerOfTile(atColumn: column, row: row)
                    
                }
            }
        }
        
        addChild(player!)
        
        playerMap.removeFromParent()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
      return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        movementManager!.updateJoystickPosition(touches, with: event)
        
        actionManager.checkInput(touches, with: event)
        movementManager!.checkInput(touches, with: event)

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementManager!.checkInput(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementManager!.stopMovement()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Game logic for updating movement goes in movementManagers update()-method
        movementManager?.update()
        
        //Call update()-method on all enemies
        for enemy in Enemy.enemies {
            enemy.update()
        }
        
        for explosion in ExplosionSettings.explosionsArray{
            explosion.update()
        }
        
        for bomb in Bomb.bombs {
            bomb.update()
        }
        
    }
    
    func stopScene() {
        backgroundMap = nil
        enemyNode = nil
        explosionsNode = nil
        breakablesNode = nil
        obstaclesNode = nil
        player = nil
        movementManager = nil
    }
}
