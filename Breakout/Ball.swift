//
//  Ball.swift
//  Breakout
//
//  Created by Nikhil Wali on 02/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

/*
 Ball class creates ball(s) depending upon the input parameter values. Also takes into consideration the gameView to construct the ball size accordingly followed with handling the dynamic behavior of the ball(s).
 Mandatory parameter: numberOfBalls, speed, gameView and dynamicBehavior
 */
import UIKit

class Ball:NSObject {
 
    init(numberOfBalls: Int, speed: CGFloat) {
        ballCount = numberOfBalls
        speedOfBall = speed
    }

    fileprivate struct BallInfo {
        static let BallSizeConstant: CGFloat = 0.05
        static let BallColor = UIColor.red
    }
    
    var speedOfBall: CGFloat!
    var ballCount: Int!
    
    var gameView: BezierPathsView!
    var breakoutBehavior: BreakoutBehavior!
    
    var paddleCenter: CGPoint!
    var paddleHeight: CGFloat!
    
    fileprivate var ballSize: CGSize {
        let size = BallInfo.BallSizeConstant * min(gameView.bounds.size.width, gameView.bounds.size.height)
        return CGSize(width: size, height: size)
    }
    
    /*
     Place ball(s) at center of the paddle in gameView
     @return : [UIPushBehavior]
    */
    func placeBall() -> [UIPushBehavior] {
        var pushes = [UIPushBehavior]()
        
        /*
         place number of balls as per the count from settings
         default value is 1
         */
        for _ in 1...ballCount {
            let ballView = UIView(frame: CGRect(origin: CGPoint.zero, size: ballSize))
            
            ballView.center = paddleCenter
            ballView.center.y -= (paddleHeight + ballSize.height) / 2
            
            ballView.backgroundColor = BallInfo.BallColor
            ballView.layer.cornerRadius = ballSize.width / 2.0
            
            breakoutBehavior.addBall(ballView)
            pushes.append(push(breakoutBehavior.items.last!))
        }
        
        return pushes
    }
    
    /*
     Add push behavoir to the ball(s)
     @return : UIPushBehavior
     */
    fileprivate func push(_ view: UIView) -> UIPushBehavior {
        let pushBehaviour = UIPushBehavior(items: [view], mode: UIPushBehaviorMode.instantaneous)
        pushBehaviour.magnitude = speedOfBall * CGFloat(M_PI) / 100
        pushBehaviour.angle = CGFloat(getRandomAngle())
        pushBehaviour.action = {
            [unowned pushBehaviour] in pushBehaviour.dynamicAnimator!.removeBehavior(pushBehaviour)
        }
        
        return pushBehaviour
    }
    
    // Generate random angle for the ball(s)
    fileprivate func getRandomAngle() -> Double {
        return M_PI * (Double(arc4random_uniform(30)) + 1) + 10   // To get the right anlge for starting the ball
    }
    
}
