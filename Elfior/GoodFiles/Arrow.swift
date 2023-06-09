//
//  Arrow.swift
//  Elfior
//
//  Created by Mattia Ferrara on 12/12/22.
//

import Foundation
import SpriteKit

func shootArrow(gameScene:GameScene, _ touches: Set<UITouch>) -> SKSpriteNode{
    let touch = touches.first
    let touchPosition = touch!.location(in: gameScene)
    let arrow = SKSpriteNode(imageNamed: "Arrow")
    arrow.setScale(5.0)
    arrow.position = elfior.position
    arrow.position.y = elfior.position.y + 30
    
    let distance = touchPosition - arrow.position
    
    arrow.physicsBody = SKPhysicsBody(circleOfRadius: arrow.size.width/4)
    arrow.physicsBody?.isDynamic = true
    arrow.isHidden = true
    arrow.physicsBody?.categoryBitMask = PhysicsCategory.arrow.rawValue
    arrow.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
    arrow.physicsBody?.collisionBitMask = PhysicsCategory.nothing.rawValue
    arrow.physicsBody?.usesPreciseCollisionDetection = true
    let direction = distance.normalized()
    let maxDistance = direction * 800
    let realDistance = maxDistance + arrow.position
    
    let shootAction = SKAction.move(to: realDistance, duration: 1.0)
    let rotateAction = SKAction.rotate(toAngle: -(.pi / 4), duration: 3.0)
    let shootActionDone = SKAction.removeFromParent()
    let showArrow = SKAction.run {
        arrow.isHidden = false
    }
    ElfiorAttackAnimation()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(220)) {
        arrow.run(SKAction.sequence([showArrow ,SKAction.group([shootAction, rotateAction]), shootActionDone]))
    }
    return arrow
}
    func arrowCollidesWithEnemy(arrow: SKSpriteNode, enemy: SKSpriteNode) {
        arrow.removeFromParent()
        
        enemy.removeAllActions()
        enemy.physicsBody?.categoryBitMask = 0
        enemyDeathAnimation(enemy: enemy)
        enemy.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
    }

