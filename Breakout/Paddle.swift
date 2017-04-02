//
//  Paddle.swift
//  Breakout
//
//  Created by Nikhil Wali on 02/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

/*
 Paddle class builds the paddle based on view provided and reset the paddle to original position on request.
 Mandatory parameter: gameView and dynamicBehavior
 */

import UIKit

class Paddle: NSObject {

    fileprivate struct PaddleInfo {
        static let PaddleItem = "PaddleItem"
        static let PaddleHeight: CGFloat = 10.0
        static let PaddleYOffset: CGFloat = 80.0
        static let PaddleImage = "paddle"
    }
    
    var gameView: BezierPathsView!
    var breakoutBehavior: BreakoutBehavior!
    
    var paddleWidthOffset: CGFloat!

    var paddleHeight = PaddleInfo.PaddleHeight

    var paddleXPosition: CGFloat {
        get {
            return paddleImageView.frame.origin.x
        }
        set {
            paddleImageView.frame.origin.x = min(max(newValue, 0), gameView.bounds.maxX - paddleSize.width)
            breakoutBehavior.addBarrier(UIBezierPath(rect: paddleImageView.frame), named: PaddleInfo.PaddleItem)
        }
    }
    
    var paddleCenter : CGPoint {
        get {
            return paddleImageView.center
        }
        set {
            self.paddleCenter = paddleImageView.center
        }
    }
    
    fileprivate lazy var paddleImageView: UIImageView = {
        let paddle = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.paddleSize))
        if let image = UIImage(named: PaddleInfo.PaddleImage) {
            paddle.image = image
            paddle.contentMode = .scaleAspectFill
        }
        return paddle
    }()
    
    fileprivate var paddleSize : CGSize {
        let width = paddleWidthOffset * gameView.bounds.size.width
        return CGSize(width: width, height: PaddleInfo.PaddleHeight)
    }
    
    // MARK: Paddle
    func setupPaddle() {
        self.gameView.addSubview(paddleImageView)
    }
    
    func resetPaddle() {
        paddleImageView.frame.size = paddleSize
        paddleImageView.contentMode = .scaleAspectFill
        paddleImageView.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - paddleImageView.frame.size.height / 2 - PaddleInfo.PaddleYOffset)
        breakoutBehavior.addBarrier(UIBezierPath(ovalIn: paddleImageView.frame), named: PaddleInfo.PaddleItem)
    }
    
}
