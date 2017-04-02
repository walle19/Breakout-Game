//
//  SettingsViewController.swift
//  Breakout
//
//  Created by Nikhil Wali on 23/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    fileprivate let settings = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print ("Settings: \(settings)")
    }
    
    // MARK: - Reset
    
    @IBAction func resetSettings() {
        
    }
    
    struct Identifiter {
        static let SpeedCellIdentifier = "speedCell"
        static let PaddleCellIdentifier = "paddleCell"
        static let BallCellIdentifier = "ballCell"
        static let audioCellIdentifier = "audioCell"
    }
    
}
