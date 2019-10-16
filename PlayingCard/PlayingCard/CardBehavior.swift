//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by QDSG on 2019/10/16.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        
        // 往中心推进
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                pushBehavior.angle = (CGFloat.pi / 2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                pushBehavior.angle = CGFloat.pi - (CGFloat.pi / 2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                pushBehavior.angle = (-CGFloat.pi / 2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                pushBehavior.angle = CGFloat.pi + (CGFloat.pi / 2).arc4random
            default:
                pushBehavior.angle = (2 * CGFloat.pi).arc4random
            }
        }
        
        pushBehavior.magnitude = 1.0 + CGFloat(2.0).arc4random
        pushBehavior.action = { [unowned pushBehavior, weak self] in
            self?.removeChildBehavior(pushBehavior)
        }
        addChildBehavior(pushBehavior)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
