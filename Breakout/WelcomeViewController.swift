//
//  WelcomeViewController.swift
//  Breakout
//
//  Created by Nikhil Wali on 30/03/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var highestScore: UILabel!
    
    let settings = Settings()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        highestScore!.text = "\(settings.highestScore)"
    }

}
