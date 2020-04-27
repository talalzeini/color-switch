//
//  GameScene.swift
//  Color
//
//  Created by Talal Zeini on 4/27/20.
//  Copyright © 2020 Talal Zeini. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor.blue,
        UIColor.red,
        UIColor.yellow,
        UIColor.purple
    ]
}

enum SwitchState: Int {
    case red,  blue, yellow, purple
}






class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.5)
        physicsWorld.contactDelegate = self
    }
    func layoutScene(){
        backgroundColor = UIColor.black
        colorSwitch = SKSpriteNode(imageNamed:"colorSwitch.jpg")
        colorSwitch.size = CGSize(width:frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX , y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius:colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = UInt32(PhysicsCategories.switchCategory)
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.minX + 30, y: frame.maxY - 60)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        spawnBall()
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "circle.png"), color: PlayColors.colors[currentColorIndex!], size:CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius:ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = UInt32(PhysicsCategories.switchCategory)
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.1))
    }
    
    func gameOver(){
        print("Game Over")
        
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore"){
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        turnWheel()
    }
}
 


extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact){
        // 01
        // 10
        // 11
        let contactMask = contact.bodyA.categoryBitMask |
        contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory |
PhysicsCategories.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion:false))
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion:{
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                }else{
               //   run(SKAction.playSoundFileNamed("game_over", waitForCompletion:false))
                    gameOver()
                    ball.removeFromParent()
                }
            }
        }
    }
}
   
