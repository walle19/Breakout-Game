//
//  Settings.swift
//  Breakout
//
//  Created by Nikhil Wali on 24/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class Settings {
    fileprivate let defaults = UserDefaults.standard
    
    fileprivate struct SettingConstants {
        static let kBallSpeed = "ballSpeed"
        static let vBallSpeedDefault: CGFloat = 5.0
        
        static let kPaddleWidth = "paddleWidth"
        static let vPaddleWidthDefault: CGFloat = 0.3
        
        static let kBallCount = "ballcount"
        static let vBallCountDefault: Int = 1
        
        static let kAudioSetting = "audioPlaying"
        static let vAudioDefault = true
        
        static let kIsUpdated = "isUpdated"
        static let vIsUpdated = false
        
        static let kHighestScore = "highestScore"
        static let vHighestScoreDefault: Int = 0
    }
    
    func setDefaultSettings() {
        paddleWidth = SettingConstants.vPaddleWidthDefault
        ballSpeed = SettingConstants.vBallSpeedDefault
        numberOfBalls = SettingConstants.vBallCountDefault
        isAudioOn = SettingConstants.vAudioDefault
        isUpdated = true
    }
    
    var ballSpeed: CGFloat {
        get {
            return defaults.object(forKey: SettingConstants.kBallSpeed) as? CGFloat ?? SettingConstants.vBallSpeedDefault
        } set {
            defaults.set(newValue, forKey: SettingConstants.kBallSpeed)
        }
    }

    var paddleWidth: CGFloat {
        get {
            return defaults.object(forKey: SettingConstants.kPaddleWidth) as? CGFloat ?? SettingConstants.vPaddleWidthDefault
        }
        set {
            defaults.set(newValue, forKey: SettingConstants.kPaddleWidth)
        }
    }
    
    var numberOfBalls: Int {
        get {
            return defaults.object(forKey: SettingConstants.kBallCount) as? Int ?? SettingConstants.vBallCountDefault
        }
        set {
            defaults.set(newValue, forKey: SettingConstants.kBallCount)
        }
    }
    
    var isAudioOn: Bool {
        get {
            return defaults.object(forKey: SettingConstants.kAudioSetting) as? Bool ?? SettingConstants.vAudioDefault
        } set {
            defaults.set(newValue, forKey: SettingConstants.kAudioSetting)
        }
    }
    
    var isUpdated: Bool  {
        get {
            return defaults.object(forKey: SettingConstants.kIsUpdated) as? Bool ?? SettingConstants.vIsUpdated
        }
        set {
            defaults.set(newValue, forKey: SettingConstants.kIsUpdated)
        }
    }
    
    var highestScore: Int {
        get {
            return defaults.object(forKey: SettingConstants.kHighestScore) as? Int ?? SettingConstants.vHighestScoreDefault
        }
        set {
            defaults.set(newValue, forKey: SettingConstants.kHighestScore)
        }
    }
}
