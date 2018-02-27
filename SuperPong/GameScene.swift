//
//  GameScene.swift
//  Pong
//
//  Created by Mauricio Takashi Kiyama on 2/6/18.
//  Copyright © 2018 a+. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BodyType: UInt32 {
    
    case the0Block = 1
    case the1Block = 2
    case the2Block = 4
    case the3Block = 8
    case the4Block = 16
    case theBall = 32
    case thePaddle = 64
    case thePlayer2Paddle = 128
    // powers of 2
    
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameBackgroundMusic: SKAudioNode!
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var blocks4 = [forthBlock]()
    var blocks3 = [thirdBlock]()
    var blocks2 = [secondBlock]()
    var blocks1 = [firstBlock]()
    var blocks = [zeroBlock]()
    
    var gameOverLabel = SKLabelNode()
    var youWinLabel = SKLabelNode()
    var topLabel = SKLabelNode()
    var bottomLabel = SKLabelNode()
    
    var score = [Int]()
    var lives = Int()
    var life1 = SKLabelNode()
    var life2 = SKLabelNode()
    var life3 = SKLabelNode()
    var life4 = SKLabelNode()
    var life5 = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        
        gameBackgroundMusic = SKAudioNode(url: Bundle.main.url(forResource: "Zoom", withExtension: ".mp3")!)
        gameBackgroundMusic.autoplayLooped = true
        addChild(gameBackgroundMusic)
        
        self.physicsWorld.contactDelegate = self
        
        // setup the labels, ball, and paddles
        setupLabelsBallAndPaddles()
        
        // setup the border
        setupBorder()
        
        // apply changes depending if it's single or 2 player
        switch currentGameType {
        case .singleGame:
            setupSinglePlayer()
            break
        case .player2:
            setup2Player()
            break
        }
        
        // setup the game itself
        startGame()
        
        
        
    }
    
    func startGame() {
        score = [0,0]
        lives = 5
        
        switch currentGameType {
        case .singleGame:
            topLabel.isHidden = true
            break
        case .player2:
            
            break
            
        }
        topLabel.text = "\(score[1])"
        bottomLabel.text = "\(score[0])"
        ball.physicsBody?.applyImpulse(CGVector(dx: 7, dy: 7))
    }
    
    func userDied() {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 10))
        
        lives -= 1
        topLabel.text = "\(score[1])"
        bottomLabel.text = "\(score[0])"
        
        if lives == 4 {
            life5.isHidden = true
        }
        else if lives == 3 {
            life4.isHidden = true
        }
        else if lives == 2 {
            life3.isHidden = true
        }
        else if lives == 1 {
            life2.isHidden = true
        }
        
        if lives == 0 {
            life1.isHidden = true
            ball.removeFromParent()
            main.removeFromParent()
            gameOverLabel.isHidden = false
            
        }
    }
    
    func addScore(playerWhoWon : SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == main {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        
        topLabel.text = "\(score[1])"
        bottomLabel.text = "\(score[0])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
            }
            else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view?.addGestureRecognizer(tap)
        
    }
    
    @objc func doubleTapped() {
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.1))
                }
            }
            else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //called before each frame is rendered
        
        switch currentGameType {
        case .player2:
            playing2PlayerGame()
            break
        case .singleGame:
            playingSingleGame()
            break
        }
    }
    
    
    func playingSingleGame() {
        
        if ball.position.y <= main.position.y - 25 {
            userDied()
        }
        if (score[0] == 60) {
            youWinLabel.isHidden = false
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
        }
    }
    
    func playing2PlayerGame() {
        
        
        life1.isHidden = true
        life2.isHidden = true
        life3.isHidden = true
        life4.isHidden = true
        life5.isHidden = true
        
        if ball.position.y <= main.position.y - 25 {
            addScore(playerWhoWon: enemy)
            
        }
        else if ball.position.y >= enemy.position.y + 25 {
            addScore(playerWhoWon: main)
        }
    }
    
    func setupLabelsBallAndPaddles() {
        
        // setup game over label
        gameOverLabel = self.childNode(withName: "gameOverLabel") as! SKLabelNode
        gameOverLabel.position.x = 0
        gameOverLabel.position.y = 0
        gameOverLabel.isHidden = true
        
        // setup lives
        life1 = self.childNode(withName: "life1") as! SKLabelNode
        life1.position.x = self.frame.width / 2 - 15
        life1.position.y = -self.frame.height / 2 + 20
        
        life2 = self.childNode(withName: "life2") as! SKLabelNode
        life2.position.x = self.frame.width / 2 - 35
        life2.position.y = -self.frame.height / 2 + 20
        
        life3 = self.childNode(withName: "life3") as! SKLabelNode
        life3.position.x = self.frame.width / 2 - 55
        life3.position.y = -self.frame.height / 2 + 20
        
        life4 = self.childNode(withName: "life4") as! SKLabelNode
        life4.position.x = self.frame.width / 2 - 75
        life4.position.y = -self.frame.height / 2 + 20
        
        life5 = self.childNode(withName: "life5") as! SKLabelNode
        life5.position.x = self.frame.width / 2 - 95
        life5.position.y = -self.frame.height / 2 + 20

        
        // setup you win label
        youWinLabel = self.childNode(withName: "youWinLabel") as! SKLabelNode
        youWinLabel.position.x = 0
        youWinLabel.position.y = 0
        youWinLabel.isHidden = true
        
        // setup top label
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        topLabel.position.x = self.frame.width / 2 - 30
        topLabel.position.y = self.frame.height / 2 - 20
        
        // setup bottom label
        bottomLabel = self.childNode(withName: "bottomLabel") as! SKLabelNode
        bottomLabel.position.x = -self.frame.width / 2 + 30
        bottomLabel.position.y = -self.frame.height / 2 + 20
        
        // setup ball
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody?.categoryBitMask = BodyType.theBall.rawValue
        ball.physicsBody?.collisionBitMask = BodyType.thePaddle.rawValue | BodyType.the0Block.rawValue | BodyType.the1Block.rawValue | BodyType.the2Block.rawValue | BodyType.the3Block.rawValue | BodyType.the4Block.rawValue | BodyType.thePlayer2Paddle.rawValue
        ball.physicsBody?.contactTestBitMask = BodyType.thePlayer2Paddle.rawValue | BodyType.thePaddle.rawValue | BodyType.the0Block.rawValue | BodyType.the1Block.rawValue | BodyType.the2Block.rawValue | BodyType.the3Block.rawValue | BodyType.the4Block.rawValue
        
        // setup enemy paddle
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        enemy.physicsBody?.categoryBitMask = BodyType.thePlayer2Paddle.rawValue
        
        // setup main paddle
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 100
        main.physicsBody?.categoryBitMask = BodyType.thePaddle.rawValue
    }
    
    func setupBorder() {
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
    }
    
    func setupSinglePlayer() {
        
        // remove the top label and the enemyPaddle
        topLabel.removeFromParent()
        enemy.removeFromParent()
        
        blocks4 = [self.childNode(withName: "forthBlock") as! forthBlock, self.childNode(withName: "forthBlock1") as! forthBlock, self.childNode(withName: "forthBlock2") as! forthBlock, self.childNode(withName: "forthBlock3") as! forthBlock]
        blocks3 = [self.childNode(withName: "thirdBlock") as! thirdBlock, self.childNode(withName: "thirdBlock1") as! thirdBlock, self.childNode(withName: "thirdBlock2") as! thirdBlock, self.childNode(withName: "thirdBlock3") as! thirdBlock]
        blocks2 = [self.childNode(withName: "secondBlock") as! secondBlock, self.childNode(withName: "secondBlock1") as! secondBlock, self.childNode(withName: "secondBlock2") as! secondBlock, self.childNode(withName: "secondBlock3") as! secondBlock]
        blocks1 = [self.childNode(withName: "firstBlock") as! firstBlock, self.childNode(withName: "firstBlock1") as! firstBlock, self.childNode(withName: "firstBlock2") as! firstBlock, self.childNode(withName: "firstBlock3") as! firstBlock]
        blocks = [self.childNode(withName: "zeroBlock") as! zeroBlock, self.childNode(withName: "zeroBlock1") as! zeroBlock, self.childNode(withName: "zeroBlock2") as! zeroBlock, self.childNode(withName: "zeroBlock3") as! zeroBlock]
        
        for index in 0...3 {
            blocks4[index].position.x = self.frame.width / 2 - 50 - (CGFloat(index) * 104)
            blocks4[index].position.y = self.frame.height / 2 - 20
            blocks4[index].setUpForthBlock()
        }
        
        for index in 0...3 {
            blocks3[index].position.x = self.frame.width / 2 - 50 - (CGFloat(index) * 104)
            blocks3[index].position.y = self.frame.height / 2 - 45
            blocks3[index].setUpThirdBlock()
        }
        
        for index in 0...3 {
            blocks2[index].position.x = self.frame.width / 2 - 50 - (CGFloat(index) * 104)
            blocks2[index].position.y = self.frame.height / 2 - 70
            blocks2[index].setUpSecondBlock()
        }
        
        for index in 0...3 {
            blocks1[index].position.x = self.frame.width / 2 - 50 - (CGFloat(index) * 104)
            blocks1[index].position.y = self.frame.height / 2 - 95
            blocks1[index].setUpFirstBlock()
        }
        
        for index in 0...3 {
            blocks[index].position.x = self.frame.width / 2 - 50 - (CGFloat(index) * 104)
            blocks[index].position.y = self.frame.height / 2 - 120
            blocks[index].setUpZeroBlock()
        }
        
    }
    
    func setup2Player() {
        
    }
    
    //MARK: Physics Contacts
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == BodyType.thePaddle.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
         
            if (contact.contactPoint.x >= (contact.bodyA.node?.position.x)!) {
                contact.bodyB.node?.physicsBody?.applyImpulse(CGVector(dx: 1, dy: 1))
            }
            else {
                contact.bodyB.node?.physicsBody?.applyImpulse(CGVector(dx: -1, dy: -1))
            }
            
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.the0Block.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
            
            contact.bodyA.node?.removeFromParent()
            score[0] += 1
            bottomLabel.text = "\(score[0])"
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.the1Block.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
            
            contact.bodyA.node?.removeFromParent()
            score[0] += 2
            bottomLabel.text = "\(score[0])"
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.the2Block.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
            
            contact.bodyA.node?.removeFromParent()
            score[0] += 3
            bottomLabel.text = "\(score[0])"
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.the3Block.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
            
            contact.bodyA.node?.removeFromParent()
            score[0] += 4
            bottomLabel.text = "\(score[0])"
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.the4Block.rawValue && contact.bodyB.categoryBitMask == BodyType.theBall.rawValue) {
            
            contact.bodyA.node?.removeFromParent()
            score[0] += 5
            bottomLabel.text = "\(score[0])"
        }
        
    }
    
    
}



