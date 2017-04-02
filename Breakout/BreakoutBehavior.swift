//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Nikhil Wali on 23/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    var items: [UIView] {
        return ballBehavior.items.map{$0 as! UIView}
    }
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet {
            collisionBehavior.collisionDelegate = collisionDelegate
        }
    }
    
    fileprivate lazy var collisionBehavior: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        return collisionBehavior
    }()
    
    fileprivate lazy var ballBehavior: UIDynamicItemBehavior = {
        let ballBehavior = UIDynamicItemBehavior()
        ballBehavior.allowsRotation = false
        ballBehavior.elasticity = 1.0
        ballBehavior.friction = 0.0
        ballBehavior.resistance = 0.0
        return ballBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(ballBehavior)
    }
    
    // MARK: Barrier
    
    func addBarrier(_ path: UIBezierPath, named name: String) {
        collisionBehavior.removeBoundary(withIdentifier: name as NSCopying)
        collisionBehavior.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func removeBarrier(named name: String) {
        collisionBehavior.removeBoundary(withIdentifier: name as NSCopying)
    }
    
    // MARK: Ball
    
    func addBall(_ ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collisionBehavior.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(_ ball: UIView) {
        collisionBehavior.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func stopBall(_ ball: UIView) -> CGPoint {
        let linVeloc = ballBehavior.linearVelocity(for: ball)
        ballBehavior.addLinearVelocity(CGPoint(x: -linVeloc.x, y: -linVeloc.y), for: ball)
        return linVeloc
    }
    
    func startBall(_ ball: UIView, velocity: CGPoint) {
        ballBehavior.addLinearVelocity(velocity, for: ball)
    }
    
}
