//
//  SettingsViewController.swift
//  Breakout
//
//  Created by Nikhil Wali on 23/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var speedSlider: UISlider!
    @IBOutlet fileprivate weak var paddleSlider: UISlider!
    
    @IBOutlet fileprivate weak var ballCountControl: UISegmentedControl!
    
    @IBOutlet fileprivate weak var audioSwitch: UISwitch!
    
    fileprivate let settings = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettings()
    }
    
    // MARK: - Reset
    
    @IBAction fileprivate func resetSettings() {
        settings.setDefaultSettings()
        
        updateSettings()
        
        // Post notification
        NotificationCenter.default.post(name: .audioUpdateNotification, object: nil, userInfo: ["isPlay":settings.isAudioOn])
    }
    
    // MARK: Update screen properties as per provided value
    
    fileprivate func updateSettings() {
        speedSlider.value = Float(settings.ballSpeed)
        paddleSlider.value = Float(settings.paddleWidth)
        ballCountControl.selectedSegmentIndex = settings.numberOfBalls-1
        audioSwitch.setOn(settings.isAudioOn, animated: false)
    }
    
    // MARK: Setting methods
    
    @IBAction fileprivate func ballSpeedChanged(_ sender: UISlider) {
        settings.isUpdated = true
        settings.ballSpeed = CGFloat(sender.value)
    }
    
    @IBAction fileprivate func paddleWidthChanged(_ sender: UISlider) {
        settings.isUpdated = true
        settings.paddleWidth = CGFloat(sender.value)
    }
    
    @IBAction fileprivate func ballCountChanged(_ sender: UISegmentedControl) {
        settings.isUpdated = true
        settings.numberOfBalls = Int(sender.titleForSegment(at: sender.selectedSegmentIndex)!)!
    }
    
    @IBAction fileprivate func audioChanged(_ sender: UISwitch) {
        settings.isAudioOn = sender.isOn
        
        // Post notification        
        NotificationCenter.default.post(name: .audioUpdateNotification, object: nil, userInfo: ["isPlay":settings.isAudioOn])
    }
    
}
