//
//  Blocks.swift
//  SuperPong
//
//  Created by Mauricio Takashi Kiyama on 2/7/18.
//  Copyright © 2018 a+. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class forthBlock : SKSpriteNode {
    
    var lives: Int = 5
    
    func setUpForthBlock() {
        self.physicsBody?.categoryBitMask = BodyType.the4Block.rawValue
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
     
    }
}

class thirdBlock : SKSpriteNode {
    
    var lives: Int = 4
    
    func setUpThirdBlock() {
        self.physicsBody?.categoryBitMask = BodyType.the3Block.rawValue
    }
}

class secondBlock : SKSpriteNode {
    
    var lives: Int = 3
    
    func setUpSecondBlock() {
        self.physicsBody?.categoryBitMask = BodyType.the2Block.rawValue
    }
}

class firstBlock : SKSpriteNode {
    
    var lives: Int = 2
    
    func setUpFirstBlock() {
        self.physicsBody?.categoryBitMask = BodyType.the1Block.rawValue
    }
}

class zeroBlock : SKSpriteNode {
    
    var lives: Int = 1
    
    func setUpZeroBlock() {
        self.physicsBody?.categoryBitMask = BodyType.the0Block.rawValue
    }
}
