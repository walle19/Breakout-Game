//
//  UIBezierPathView.swift
//  Breakout
//
//  Created by Nikhil Wali on 23/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {

    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(_ path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
    
}
