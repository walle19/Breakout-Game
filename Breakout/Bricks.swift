//
//  Bricks.swift
//  Breakout
//
//  Created by Nikhil Wali on 30/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

/*
 Bricks class construct the bricks for the view provided based on the rows and columns details. Also add the dynamic behavior to the bricks for collision and other effects.
 Mandatory parameter: rows, columns, gameView and dynamicBehavior
 */

import UIKit

class Bricks: NSObject {
    
    init(row: Int, column: Int) {
        brickRows = row
        brickColumns = column
    }
    
    fileprivate struct BrickConstants {
        struct BrickInfo {
            static let BrickHeight:CGFloat = 10.0
            static let BrickSeparation:CGFloat = 4.0
        }
        
        struct GameOffSet {
            static let TopOffset:CGFloat = 70.0
        }
    }
    
    var gameView: BezierPathsView!
    var breakoutBehavior: BreakoutBehavior!

    var bricks = [UIView]()
    
    fileprivate var brickRows: Int = 0
    fileprivate var brickColumns: Int = 0
    
    fileprivate var brickSize: CGSize {
        let width = (gameView.bounds.size.width - BrickConstants.BrickInfo.BrickSeparation) /  CGFloat(brickColumns) - BrickConstants.BrickInfo.BrickSeparation
        return CGSize(width: width, height: BrickConstants.BrickInfo.BrickHeight)
    }
    
    func buildBricks() {
        removeAllBricks()
        
        let top = BrickConstants.GameOffSet.TopOffset
        let middle = BrickConstants.BrickInfo.BrickSeparation
        
        if  brickRows / 2 != 0{
            let origin = CGPoint(x: BrickConstants.BrickInfo.BrickSeparation, y: top)
            addBricks(origin, rowStart: 0, rowEnd:  brickRows / 2 - 1)
        }
        
        let origin = CGPoint(x: BrickConstants.BrickInfo.BrickSeparation, y: top + middle + CGFloat(brickRows / 2) * (BrickConstants.BrickInfo.BrickHeight + BrickConstants.BrickInfo.BrickSeparation) - BrickConstants.BrickInfo.BrickSeparation)
        addBricks(origin, rowStart: brickRows / 2, rowEnd: brickRows - 1)
    }
    
    // Add bricks to the view and dynamic behavior
    fileprivate func addBricks(_ origin: CGPoint, rowStart: Int, rowEnd: Int) {
        var brickOrigin = origin
        
        for _ in rowStart...rowEnd {
            for _ in 0..<brickColumns {
                let brick = UIView(frame: CGRect(origin: brickOrigin, size: brickSize))
                brick.backgroundColor = UIColor.yellow
                
                gameView.addSubview(brick)
                bricks.append(brick)
                
                breakoutBehavior?.addBarrier(UIBezierPath(rect: brick.frame), named: "\(bricks.count - 1)")
                
                brickOrigin.x += BrickConstants.BrickInfo.BrickSeparation + brickSize.width
            }
            
            brickOrigin.x = BrickConstants.BrickInfo.BrickSeparation
            brickOrigin.y += BrickConstants.BrickInfo.BrickSeparation + brickSize.height
        }
    }
    
    // Remove the bricks from the view and dynamic behavior
    fileprivate func removeAllBricks() {
        if bricks.count == 0 {
            return
        }
        
        for i in 0..<bricks.count {
            breakoutBehavior?.removeBarrier(named: "\(i)")
            bricks[i].removeFromSuperview()
        }
        
        bricks = []
    }
    
}
